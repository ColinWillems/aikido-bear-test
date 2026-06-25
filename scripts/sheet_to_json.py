#!/usr/bin/env python3
"""
Convert a translations CSV (e.g. exported from Google Sheets/Excel) into per-locale
nested JSON files compatible with the repo's GetX locale JSON structure.

Supported column layouts:

1) Simple: key, description (optional), and locale columns named exactly en_GB, fr_FR, etc.

2) Excel-style (e.g. from "App copy WIP"):
   - Screen (ignored)
   - Key (PLEASE DON'T CHANGE) -> used as key column (any header starting with "key")
   - Description (optional, case-insensitive)
   - en_GB translation, en_GB translation - NEW VERSION -> both map to locale en_GB.
     When multiple columns map to the same locale, "NEW VERSION" is preferred if non-empty.
   - Comments (ignored)

Locale columns are detected by a leading locale code (xx_YY). Multiple columns per locale
(e.g. "en_GB translation" and "en_GB translation - NEW VERSION") are merged: the first
non-empty value is used, with columns whose name contains "NEW VERSION" tried first.

Example:
python3 scripts/sheet_to_json.py --input scripts/translations.csv \
  --output-dir packages/bear_necessities/assets/locales --strict
"""

from __future__ import annotations

import argparse
import csv
import io
import json
import os
import re
import sys
import urllib.request
from typing import Any, Dict, Iterable, List, Tuple


# Matches placeholders used in this repo, e.g. %character_name%
PLACEHOLDER_RE = re.compile(r"%[A-Za-z0-9_]+%")
# Locale code at start of column name, e.g. en_GB from "en_GB translation - NEW VERSION"
LOCALE_PREFIX_RE = re.compile(r"^([a-z]{2}_[A-Z]{2})\b", re.IGNORECASE)

def _unescape_common_sequences(s: str) -> str:
    """
    Allow spreadsheet-friendly escapes.

    In Sheets/Excel, it's painful to enter literal newlines in a cell. We allow
    users to type '\\n' and have it converted to an actual newline in JSON.
    """
    # Order matters: handle \\n as newline, but keep other backslashes intact.
    return s.replace("\\n", "\n")


def _read_input_bytes(input_value: str) -> bytes:
    if input_value.startswith("http://") or input_value.startswith("https://"):
        with urllib.request.urlopen(input_value) as resp:
            return resp.read()
    with open(input_value, "rb") as f:
        return f.read()


def _iter_rows(csv_bytes: bytes) -> Tuple[List[str], Iterable[Dict[str, str]]]:
    # UTF-8 with optional BOM from Excel
    text = csv_bytes.decode("utf-8-sig")
    reader = csv.DictReader(io.StringIO(text))
    if reader.fieldnames is None:
        raise ValueError("CSV has no header row.")
    headers = [h.strip() for h in reader.fieldnames if h is not None]

    def _rows() -> Iterable[Dict[str, str]]:
        for raw in reader:
            # Normalize keys; keep values as-is (they may contain \n)
            row: Dict[str, str] = {}
            for k, v in raw.items():
                if k is None:
                    continue
                row[k.strip()] = (v if v is not None else "")
            yield row

    return headers, _rows()


def _get_key_column(headers: List[str]) -> str:
    """Return the header used as the key column (starts with 'key', case-insensitive)."""
    for h in headers:
        if not (h and h.strip()):
            continue
        if h.strip().lower().startswith("key"):
            return h
    raise SystemExit(
        "No key column found. Expected a column whose title starts with 'key' "
        "(e.g. 'key' or 'Key (PLEASE DON'T CHANGE)')."
    )


def _is_ignored_column(header: str) -> bool:
    """Columns that are never treated as locale or key."""
    h = header.strip().lower()
    return h in ("screen", "comments", "comment")


def _is_description_column(header: str) -> bool:
    return header.strip().lower() == "description"


def _locale_columns(headers: List[str]) -> Tuple[str, Dict[str, List[str]]]:
    """
    Resolve key column and locale -> ordered list of source columns.
    Key column: header starting with 'key' (case-insensitive).
    Locale columns: header starts with xx_YY (e.g. en_GB). Multiple columns can
    map to the same locale; we order them so "NEW VERSION" is preferred.
    Returns (key_header, {locale: [col1, col2, ...]}).
    """
    key_col = _get_key_column(headers)
    # locale -> list of column names; we'll order each list so "NEW VERSION" columns come first
    locale_to_cols: Dict[str, List[str]] = {}
    for h in headers:
        if not h or not h.strip():
            continue
        if h.strip().lower().startswith("key") or _is_description_column(h) or _is_ignored_column(h):
            continue
        m = LOCALE_PREFIX_RE.match(h.strip())
        if not m:
            continue
        loc = m.group(1)  # e.g. en_GB (keep case for consistency; JSON filenames use it)
        if loc not in locale_to_cols:
            locale_to_cols[loc] = []
        locale_to_cols[loc].append(h)
    # Prefer columns whose name contains "NEW VERSION" or "NEW" when taking first non-empty
    for loc in locale_to_cols:
        cols = locale_to_cols[loc]
        cols.sort(key=lambda c: (0 if ("new version" in c.lower() or " new " in c.lower()) else 1, c))
    return key_col, locale_to_cols


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
                f"Key collision: '{dotted_key}' wants object at '{p}', "
                f"but found non-object."
            )
        cur = existing

    leaf = parts[-1]
    if leaf in cur and isinstance(cur[leaf], dict):
        raise ValueError(
            f"Key collision: '{dotted_key}' wants a value at '{leaf}', "
            f"but found an object."
        )
    cur[leaf] = value


def _placeholders(s: str) -> List[str]:
    # Return sorted unique placeholders for deterministic comparisons
    return sorted(set(PLACEHOLDER_RE.findall(s)))


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--input", required=True, help="Path or URL to CSV")
    ap.add_argument(
        "--output-dir",
        required=True,
        help="Directory to write <locale>.json files into",
    )
    ap.add_argument(
        "--strict",
        action="store_true",
        help="Fail on missing/blank translations and placeholder mismatches",
    )
    ap.add_argument(
        "--reference-locale",
        default="en_GB",
        help="Locale column used as the key/placeholder reference (default: en_GB)",
    )
    args = ap.parse_args()

    csv_bytes = _read_input_bytes(args.input)
    headers, rows = _iter_rows(csv_bytes)
    key_col, locale_to_cols = _locale_columns(headers)
    locales = sorted(locale_to_cols.keys())
    if not locales:
        raise SystemExit("No locale columns found in CSV header.")
    if args.reference_locale not in locale_to_cols:
        raise SystemExit(
            f"Reference locale '{args.reference_locale}' is not present. "
            f"Found locales: {', '.join(locales)}"
        )

    def _value_for_locale(row: Dict[str, str], loc: str) -> str:
        """First non-empty value from the columns that map to this locale."""
        for col in locale_to_cols[loc]:
            raw = row.get(col, "") or ""
            val = raw.strip()
            if val:
                return val
        return ""

    per_locale: Dict[str, Dict[str, Any]] = {loc: {} for loc in locales}
    ref_flat: Dict[str, str] = {}
    seen_keys: set[str] = set()

    row_num = 1  # header is row 1 in spreadsheet terms
    for row in rows:
        row_num += 1
        key = row.get(key_col, "").strip()
        if not key:
            # allow blank lines
            continue
        if key in seen_keys:
            raise SystemExit(f"Duplicate key '{key}' on CSV row {row_num}.")
        seen_keys.add(key)

        # Collect reference string early for placeholder validation (first non-empty for ref locale)
        ref_val_str = _value_for_locale(row, args.reference_locale)
        ref_val_str = _unescape_common_sequences(ref_val_str)

        if args.strict and ref_val_str == "":
            raise SystemExit(
                f"Missing {args.reference_locale} value for key '{key}' on row {row_num}."
            )
        if ref_val_str != "":
            ref_flat[key] = ref_val_str

        ref_ph = _placeholders(ref_val_str) if ref_val_str else []

        for loc in locales:
            val = _value_for_locale(row, loc)
            val = _unescape_common_sequences(val)

            if args.strict and val == "":
                raise SystemExit(
                    f"Missing {loc} value for key '{key}' on row {row_num}."
                )

            if args.strict and ref_ph:
                ph = _placeholders(val)
                if ph != ref_ph:
                    raise SystemExit(
                        f"Placeholder mismatch for key '{key}' ({loc}) on row {row_num}:\n"
                        f"  expected: {ref_ph}\n"
                        f"  got:      {ph}"
                    )

            _set_nested(per_locale[loc], key, val)

    os.makedirs(args.output_dir, exist_ok=True)
    for loc, data in per_locale.items():
        out_path = os.path.join(args.output_dir, f"{loc}.json")
        with open(out_path, "w", encoding="utf-8") as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
            f.write("\n")
        print(f"Wrote {out_path}")

    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except KeyboardInterrupt:
        raise SystemExit(130)

