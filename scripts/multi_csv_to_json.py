#!/usr/bin/env python3
"""
Convert multiple per-locale CSV files (e.g. one Google Sheets tab per locale)
into per-locale nested JSON files compatible with this repo's GetX locale JSON structure.

This supports the "separate sheet per translation" workflow:

Example:
python3 scripts/i18n/multi_csv_to_json.py \
  --sheet en_GB=path/to/en_GB.csv \
  --sheet nl_NL=path/to/nl_NL.csv \
  --output-dir packages/bear_necessities/assets/locales \
  --strict

Expected per-locale CSV columns:
- key (dot-separated path, e.g. home.banner.title)
- description (optional; ignored)
- value (preferred) OR a column named like the locale (e.g. en_GB)

Notes:
- '\\n' in cells is converted to a real newline in JSON.
- Placeholder parity is enforced (e.g. %character_name% must match the reference locale).
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


KEY_COL = "key"
DESC_COL = "description"
VALUE_COL = "value"

PLACEHOLDER_RE = re.compile(r"%[A-Za-z0-9_]+%")


def _unescape_common_sequences(s: str) -> str:
    # Spreadsheet-friendly escape for newlines.
    return s.replace("\\n", "\n")


def _read_input_bytes(input_value: str) -> bytes:
    if input_value.startswith("http://") or input_value.startswith("https://"):
        with urllib.request.urlopen(input_value) as resp:
            return resp.read()
    with open(input_value, "rb") as f:
        return f.read()


def _iter_rows(csv_bytes: bytes) -> Tuple[List[str], Iterable[Dict[str, str]]]:
    text = csv_bytes.decode("utf-8-sig")
    reader = csv.DictReader(io.StringIO(text))
    if reader.fieldnames is None:
        raise ValueError("CSV has no header row.")
    headers = [h.strip() for h in reader.fieldnames if h is not None]

    def _rows() -> Iterable[Dict[str, str]]:
        for raw in reader:
            row: Dict[str, str] = {}
            for k, v in raw.items():
                if k is None:
                    continue
                row[k.strip()] = (v if v is not None else "")
            yield row

    return headers, _rows()


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


def _placeholders(s: str) -> List[str]:
    return sorted(set(PLACEHOLDER_RE.findall(s)))


def _pick_value_column(headers: List[str], locale: str) -> str:
    # Prefer explicit 'value', else the locale column, else fail.
    if VALUE_COL in headers:
        return VALUE_COL
    if locale in headers:
        return locale
    raise ValueError(
        f"CSV for {locale} must contain '{VALUE_COL}' or '{locale}' column. Found: {headers}"
    )


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument(
        "--sheet",
        action="append",
        default=[],
        help="Locale mapping in the form <locale>=<path-or-url>. Repeatable.",
    )
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
        help="Locale used as the key/placeholder reference (default: en_GB)",
    )
    args = ap.parse_args()

    if not args.sheet:
        raise SystemExit("Provide at least one --sheet <locale>=<csv> argument.")

    locale_to_input: Dict[str, str] = {}
    for item in args.sheet:
        if "=" not in item:
            raise SystemExit(
                f"Invalid --sheet value '{item}'. Expected <locale>=<path-or-url>."
            )
        loc, inp = item.split("=", 1)
        loc = loc.strip()
        inp = inp.strip()
        if not loc or not inp:
            raise SystemExit(f"Invalid --sheet value '{item}'.")
        if loc in locale_to_input:
            raise SystemExit(f"Duplicate locale '{loc}' in --sheet arguments.")
        locale_to_input[loc] = inp

    if args.reference_locale not in locale_to_input:
        raise SystemExit(
            f"Reference locale '{args.reference_locale}' must be provided as a --sheet. "
            f"Found: {', '.join(sorted(locale_to_input.keys()))}"
        )

    # First pass: load all locale flats
    locale_to_flat: Dict[str, Dict[str, str]] = {}
    for loc, inp in sorted(locale_to_input.items()):
        csv_bytes = _read_input_bytes(inp)
        headers, rows = _iter_rows(csv_bytes)
        if KEY_COL not in headers:
            raise SystemExit(f"CSV for {loc} is missing '{KEY_COL}' column.")
        value_col = _pick_value_column(headers, loc)

        flat: Dict[str, str] = {}
        row_num = 1
        for row in rows:
            row_num += 1
            key = row.get(KEY_COL, "").strip()
            if not key:
                continue
            if key in flat:
                raise SystemExit(f"Duplicate key '{key}' in {loc} CSV on row {row_num}.")
            val = (row.get(value_col, "") or "").strip()
            val = _unescape_common_sequences(val)
            if args.strict and val == "":
                raise SystemExit(f"Missing {loc} value for key '{key}' on row {row_num}.")
            flat[key] = val
        locale_to_flat[loc] = flat

    reference_flat = locale_to_flat[args.reference_locale]
    ref_keys = set(reference_flat.keys())

    # Validate: all locales have same keys, and placeholders match reference.
    for loc, flat in locale_to_flat.items():
        keys = set(flat.keys())
        missing = sorted(ref_keys - keys)
        extra = sorted(keys - ref_keys)
        if missing or extra:
            msg = [f"Key mismatch for locale {loc}:"]
            if missing:
                msg.append(f"  Missing ({len(missing)}): {', '.join(missing)}")
            if extra:
                msg.append(f"  Extra ({len(extra)}): {', '.join(extra)}")
            raise SystemExit("\n".join(msg))

        for k in ref_keys:
            ref_val = reference_flat.get(k, "")
            val = flat.get(k, "")
            ref_ph = _placeholders(ref_val)
            if args.strict and ref_ph:
                ph = _placeholders(val)
                if ph != ref_ph:
                    raise SystemExit(
                        f"Placeholder mismatch for key '{k}' ({loc}):\n"
                        f"  expected: {ref_ph}\n"
                        f"  got:      {ph}"
                    )

    # Build nested JSON per locale.
    os.makedirs(args.output_dir, exist_ok=True)
    for loc, flat in sorted(locale_to_flat.items()):
        nested: Dict[str, Any] = {}
        for k in sorted(flat.keys()):
            _set_nested(nested, k, flat[k])
        out_path = os.path.join(args.output_dir, f"{loc}.json")
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

