#!/usr/bin/env python3
"""
Convert an .xlsx workbook (multiple sheets) into per-locale nested JSON files.

This is meant for the workflow where each language is in a separate Excel/Sheets tab.

Supported sheet layout:
- Row 1 headers: key, description, and either:
  - a column named like the locale (e.g. en_GB / nl_NL), OR
  - a column named "value"

The locale for a sheet is chosen as:
1) the header column that matches a locale pattern like xx_YY, else
2) the sheet name if it matches xx_YY, else
3) error

Example:
python3 scripts/i18n/xlsx_to_json.py \
  --input scripts/i18n/translations-multisheet.xlsx \
  --output-dir packages/bear_necessities/assets/locales \
  --reference-locale en_GB \
  --strict
"""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
import zipfile
import xml.etree.ElementTree as ET
from typing import Any, Dict, List, Optional, Tuple


KEY_COL = "key"
DESC_COL = "description"
VALUE_COL = "value"

LOCALE_NAME_RE = re.compile(r"^[a-z]{2}_[A-Z]{2}$")
PLACEHOLDER_RE = re.compile(r"%[A-Za-z0-9_]+%")

NS = {
    "main": "http://schemas.openxmlformats.org/spreadsheetml/2006/main",
    "rel": "http://schemas.openxmlformats.org/officeDocument/2006/relationships",
}
PKG_REL_NS = {"rel": "http://schemas.openxmlformats.org/package/2006/relationships"}


def _unescape_common_sequences(s: str) -> str:
    return s.replace("\\n", "\n")


def _placeholders(s: str) -> List[str]:
    return sorted(set(PLACEHOLDER_RE.findall(s)))


def _col_letters_to_index(col: str) -> int:
    # A -> 0, B -> 1, ..., Z -> 25, AA -> 26 ...
    n = 0
    for ch in col:
        if not ("A" <= ch <= "Z"):
            break
        n = n * 26 + (ord(ch) - ord("A") + 1)
    return n - 1


def _parse_cell_ref(cell_ref: str) -> Tuple[int, int]:
    # e.g. "C12" -> (row=12, col=2)
    letters = ""
    digits = ""
    for ch in cell_ref:
        if ch.isalpha():
            letters += ch.upper()
        elif ch.isdigit():
            digits += ch
    return int(digits), _col_letters_to_index(letters)


def _load_shared_strings(z: zipfile.ZipFile) -> List[str]:
    if "xl/sharedStrings.xml" not in z.namelist():
        return []
    ss = ET.fromstring(z.read("xl/sharedStrings.xml"))
    out: List[str] = []
    for si in ss.findall("main:si", NS):
        # concatenate all <t> nodes (handles rich text runs)
        texts = [t.text or "" for t in si.findall(".//main:t", NS)]
        out.append("".join(texts))
    return out


def _cell_text(cell: ET.Element, shared: List[str]) -> str:
    t = cell.attrib.get("t")
    v = cell.find("main:v", NS)
    if v is None:
        # inline string
        is_el = cell.find("main:is", NS)
        if is_el is None:
            return ""
        texts = [t_el.text or "" for t_el in is_el.findall(".//main:t", NS)]
        return "".join(texts)

    raw = v.text or ""
    if t == "s":
        try:
            return shared[int(raw)]
        except Exception:
            return raw
    return raw


def _sheet_id_map(z: zipfile.ZipFile) -> Dict[str, str]:
    # rId -> worksheet target (e.g. worksheets/sheet1.xml)
    rels = ET.fromstring(z.read("xl/_rels/workbook.xml.rels"))
    rid_to_target: Dict[str, str] = {}
    for r in rels.findall("rel:Relationship", PKG_REL_NS):
        rid_to_target[r.attrib["Id"]] = r.attrib["Target"]
    return rid_to_target


def _list_sheets(z: zipfile.ZipFile) -> List[Tuple[str, str]]:
    # returns (sheetName, sheetXmlPath)
    wb = ET.fromstring(z.read("xl/workbook.xml"))
    rid_to_target = _sheet_id_map(z)
    sheets: List[Tuple[str, str]] = []
    for s in wb.findall("main:sheets/main:sheet", NS):
        name = s.attrib.get("name") or ""
        rid = s.attrib.get(f"{{{NS['rel']}}}id") or ""
        target = rid_to_target.get(rid)
        if not target:
            continue
        sheet_path = "xl/" + target.lstrip("/")
        sheets.append((name, sheet_path))
    return sheets


def _read_sheet_table(z: zipfile.ZipFile, sheet_path: str, shared: List[str]) -> List[List[str]]:
    root = ET.fromstring(z.read(sheet_path))

    # We'll build a sparse grid by row number, then output as dense rows.
    rows: Dict[int, Dict[int, str]] = {}
    for row in root.findall(".//main:sheetData/main:row", NS):
        r_attr = row.attrib.get("r")
        if not r_attr:
            continue
        rnum = int(r_attr)
        cols: Dict[int, str] = {}
        for c in row.findall("main:c", NS):
            ref = c.attrib.get("r", "")
            if not ref:
                continue
            _, cidx = _parse_cell_ref(ref)
            cols[cidx] = _cell_text(c, shared)
        rows[rnum] = cols

    if not rows:
        return []

    max_row = max(rows.keys())
    max_col = 0
    for cols in rows.values():
        if cols:
            max_col = max(max_col, max(cols.keys()))

    table: List[List[str]] = []
    for rnum in range(1, max_row + 1):
        cols = rows.get(rnum, {})
        row_vals = [cols.get(c, "") for c in range(0, max_col + 1)]
        table.append(row_vals)
    return table


def _set_nested(obj: Dict[str, Any], dotted_key: str, value: Any) -> None:
    parts = [p for p in dotted_key.split(".") if p]
    if not parts:
        raise ValueError(f"Invalid key '{dotted_key}'")
    cur: Dict[str, Any] = obj
    for p in parts[:-1]:
        existing = cur.get(p)
        if existing is None:
            nxt: Dict[str, Any] = {}
            cur[p] = nxt
            cur = nxt
            continue
        if not isinstance(existing, dict):
            raise ValueError(
                f"Key collision: '{dotted_key}' wants object at '{p}', but found non-object."
            )
        cur = existing
    leaf = parts[-1]
    if leaf in cur and isinstance(cur[leaf], dict):
        raise ValueError(
            f"Key collision: '{dotted_key}' wants a value at '{leaf}', but found an object."
        )
    cur[leaf] = value


def _detect_locale(sheet_name: str, headers: List[str]) -> Optional[str]:
    for h in headers:
        h2 = (h or "").strip()
        if LOCALE_NAME_RE.match(h2):
            return h2
    s = sheet_name.strip()
    if LOCALE_NAME_RE.match(s):
        return s
    return None


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--input", required=True, help="Path to .xlsx file")
    ap.add_argument("--output-dir", required=True, help="Directory to write <locale>.json files into")
    ap.add_argument("--reference-locale", default="en_GB", help="Reference locale for key/placeholder checks")
    ap.add_argument("--strict", action="store_true", help="Fail on missing/blank values and placeholder mismatch")
    args = ap.parse_args()

    locale_to_flat: Dict[str, Dict[str, str]] = {}

    with zipfile.ZipFile(args.input) as z:
        shared = _load_shared_strings(z)
        sheets = _list_sheets(z)
        if not sheets:
            raise SystemExit("No sheets found in workbook.")

        for sheet_name, sheet_path in sheets:
            table = _read_sheet_table(z, sheet_path, shared)
            if not table:
                continue
            headers = [c.strip() for c in table[0]]
            if not headers or KEY_COL not in headers:
                # ignore sheets that don't look like translation sheets
                continue

            locale = _detect_locale(sheet_name, headers)
            if locale is None:
                raise SystemExit(
                    f"Could not detect locale for sheet '{sheet_name}'. "
                    f"Add a locale header column like en_GB / nl_NL, or name the sheet en_GB."
                )

            key_idx = headers.index(KEY_COL)
            value_idx: Optional[int] = None
            if VALUE_COL in headers:
                value_idx = headers.index(VALUE_COL)
            elif locale in headers:
                value_idx = headers.index(locale)
            else:
                raise SystemExit(
                    f"Sheet '{sheet_name}' ({locale}) must have a '{VALUE_COL}' column or a '{locale}' column."
                )

            flat: Dict[str, str] = {}
            for row_i, row in enumerate(table[1:], start=2):  # 1-based, header is row 1
                if key_idx >= len(row):
                    continue
                key = row[key_idx].strip()
                if not key:
                    continue
                if key in flat:
                    raise SystemExit(f"Duplicate key '{key}' in sheet '{sheet_name}' on row {row_i}.")
                val = row[value_idx] if (value_idx is not None and value_idx < len(row)) else ""
                val = _unescape_common_sequences((val or "").strip())
                if args.strict and val == "":
                    raise SystemExit(f"Missing {locale} value for key '{key}' in sheet '{sheet_name}' on row {row_i}.")
                flat[key] = val

            if flat:
                locale_to_flat[locale] = flat

    if not locale_to_flat:
        raise SystemExit("No translation sheets found. Expect a 'key' column in row 1.")

    if args.reference_locale not in locale_to_flat:
        raise SystemExit(
            f"Reference locale '{args.reference_locale}' not found in workbook. "
            f"Found: {', '.join(sorted(locale_to_flat.keys()))}"
        )

    reference_flat = locale_to_flat[args.reference_locale]
    ref_keys = set(reference_flat.keys())

    for locale, flat in locale_to_flat.items():
        keys = set(flat.keys())
        missing = sorted(ref_keys - keys)
        extra = sorted(keys - ref_keys)
        if missing or extra:
            msg = [f"Key mismatch for locale {locale}:"]
            if missing:
                msg.append(f"  Missing ({len(missing)}): {', '.join(missing)}")
            if extra:
                msg.append(f"  Extra ({len(extra)}): {', '.join(extra)}")
            raise SystemExit("\n".join(msg))

        if args.strict:
            for k in ref_keys:
                ref_val = reference_flat.get(k, "")
                val = flat.get(k, "")
                ref_ph = _placeholders(ref_val)
                if ref_ph:
                    ph = _placeholders(val)
                    if ph != ref_ph:
                        raise SystemExit(
                            f"Placeholder mismatch for key '{k}' ({locale}):\n"
                            f"  expected: {ref_ph}\n"
                            f"  got:      {ph}"
                        )

    os.makedirs(args.output_dir, exist_ok=True)
    for locale, flat in sorted(locale_to_flat.items()):
        nested: Dict[str, Any] = {}
        for k in sorted(flat.keys()):
            _set_nested(nested, k, flat[k])
        out_path = os.path.join(args.output_dir, f"{locale}.json")
        with open(out_path, "w", encoding="utf-8") as f:
            json.dump(nested, f, ensure_ascii=False, indent=2)
            f.write("\n")
        print(f"Wrote {out_path}")

    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except KeyboardInterrupt:
        raise SystemExit(130)

