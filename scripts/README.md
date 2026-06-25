# Python setup (one-time)

All Python scripts in this folder share a single virtualenv at
`scripts/.venv/` (gitignored). Modern macOS/Homebrew Python refuses
`pip install` system-wide (PEP 668), so we keep dependencies isolated.

```bash
# from the repo root, one-time setup:
python3 -m venv scripts/.venv
scripts/.venv/bin/pip install -r scripts/requirements.txt
```

Then run any script with the venv's Python directly:

```bash
scripts/.venv/bin/python scripts/generate_unlock_qr_html.py
scripts/.venv/bin/python scripts/generate_card_unlock_excel.py
scripts/.venv/bin/python scripts/prepare_firebase_card_uploads.py ...
```

Or activate the venv for the shell session and use plain `python`:

```bash
source scripts/.venv/bin/activate
python scripts/generate_unlock_qr_html.py
deactivate    # when done
```

When new dependencies are needed, add them to `scripts/requirements.txt`
and re-run the `pip install -r` line above.

---

# Translations workflow (free, client-friendly)

This repo uses **GetX** translations (`.tr`) backed by locale JSON files in:

- `packages/bear_necessities/assets/locales/`

Those JSON files are then compiled into Dart code here:

- `packages/bear_necessities/lib/generated/locales.g.dart`

This folder contains small scripts to make it easy for a client to maintain translations in **Google Sheets** (free), while developers keep **JSON + generated Dart** in git.

## Recommended setup

### 1) Maintain strings in Google Sheets

Create a sheet with these columns:

- `key` (dot-separated path, e.g. `home.banner.title`)
- `description` (optional context for translators)
- one column per locale (examples: `en_GB`, `fr_FR`, `de_DE`)

Use `scripts/i18n/translations.template.csv` as the template.
To bootstrap a full template from the current English JSON, use:

```bash
python3 scripts/i18n/json_to_sheet_csv.py \
  --input-json packages/bear_necessities/assets/locales/en_GB.json \
  --locale en_GB \
  --output-csv scripts/i18n/translations.en_GB.template.csv
```

Notes:
- Put the **canonical English** in `en_GB` (it becomes the validation reference).
- Keep placeholders exactly the same across locales (example: `%character_name%`).

### 2) Export to CSV

From Google Sheets: **File → Download → Comma Separated Values (.csv)**.

## Developer commands

### A) Convert CSV → per-locale JSON files

This generates:
- `packages/bear_necessities/assets/locales/en_GB.json`
- `packages/bear_necessities/assets/locales/fr_FR.json`
- etc.

```bash
python3 scripts/i18n/sheet_to_json.py \
  --input path/to/translations.csv \
  --output-dir packages/bear_necessities/assets/locales \
  --strict
```

`--strict` will fail if:
- a locale is missing a key that exists in `en_GB`
- a translation is blank
- placeholders don’t match the `en_GB` string

Tip: In the spreadsheet you can type `\n` to represent a newline. The converter
will turn it into a real newline in the generated JSON.

## One-sheet-per-locale option (separate tabs)

If you prefer **one Google Sheets tab per locale**, create a separate tab for each
language (e.g. `en_GB`, `nl_NL`), and give each tab columns:

- `key`
- `description` (optional)
- `value` (the translation)

Export each tab as its own CSV and run:

```bash
python3 scripts/i18n/multi_csv_to_json.py \
  --sheet en_GB=path/to/en_GB.csv \
  --sheet nl_NL=path/to/nl_NL.csv \
  --output-dir packages/bear_necessities/assets/locales \
  --strict
```

## If you use an Excel file (.xlsx) instead of CSV

Because CSV can't contain multiple sheets/tabs, you can also keep all locales in
a single `.xlsx` file (one sheet per locale). Your sheets should have headers:

- `key`
- `description` (optional)
- `value` (recommended) OR a locale column like `en_GB` / `nl_NL`

Then run:

```bash
python3 scripts/i18n/xlsx_to_json.py \
  --input path/to/translations.xlsx \
  --output-dir packages/bear_necessities/assets/locales \
  --reference-locale en_GB \
  --strict
```

Tip: You can also pass a Google Sheets “export CSV” URL to `--input` (published or authenticated via your browser session is not supported by the script).

### B) Generate `locales.g.dart` from the JSON files

This updates:
- `packages/bear_necessities/lib/generated/locales.g.dart`

```bash
dart run scripts/i18n/generate_getx_locales.dart \
  --locales-dir packages/bear_necessities/assets/locales \
  --output packages/bear_necessities/lib/generated/locales.g.dart
```

## Key format rules

- Keys are **dot-separated** in the spreadsheet/CSV (easy to read): `settings.permissions.camera_access.title`
- In Dart, those become underscore keys (GetX style): `settings_permissions_camera_access_title`

---

# Card image delivery → Firebase Storage

The client ships card artwork as a folder of PNGs with surrounding transparent
pixels and inconsistent file names. Use
`scripts/prepare_firebase_card_uploads.py` to:

1. Trim transparent borders from every image (so the file's aspect-ratio
   matches the actual card artwork).
2. Re-organise the trimmed PNGs into the directory structure the Dart models
   expect (`images/cards/{collection}/{set}/{cardId}_front.png`, etc.).
3. Generate a `mapping_review.md` that documents which file ends up at which
   Storage path so the mapping can be reviewed before upload.

## Prerequisites

The shared `scripts/.venv/` (see top of this file). Pillow is included in
`scripts/requirements.txt`.

## Run

```bash
scripts/.venv/bin/python scripts/prepare_firebase_card_uploads.py \
  --input  bear_adventure_app/delivery \
  --output bear_adventure_app/delivery/_firebase_upload \
  --clean
```

Optional flags:

- `--padding N` — keep `N` px of transparent padding around the trimmed bbox.
- `--include-foc-unlock` — also process the high-res `FOC Unlocked/` folder
  (becomes `{cardId}_unlock.png`).
- `--dry-run` — log only, don't write files.

After the script finishes, **review** the generated
`bear_adventure_app/delivery/_firebase_upload/mapping_review.md` together with
the PO/client. The current sport→category mapping is hard-coded near the top
of `prepare_firebase_card_uploads.py` (look for `YOYOS_SPORTS` /
`SPLITS_SPORTS`); edit it there if the categorisation needs to change.

## Upload to Firebase Storage

The `_firebase_upload/images/cards/` directory mirrors the Storage layout
exactly. Use `gsutil` (or `gcloud storage`) to sync:

```bash
# Dry-run first (note the -n flag)
gsutil -m rsync -r -n \
  bear_adventure_app/delivery/_firebase_upload/images/cards \
  gs://<your-bucket>/images/cards

# Real upload
gsutil -m rsync -r \
  bear_adventure_app/delivery/_firebase_upload/images/cards \
  gs://<your-bucket>/images/cards
```

The bucket name is project-specific. Check `firebase_options.dart` or the
Firebase Console (Storage section) for the exact value.

## Card IDs are placeholders!

The mock data (`mock_card.repository.dart`) uses TODO placeholder IDs
(`TODO_GG_NN`, `TODO_GGX_NN`) that are also used as the filename in Firebase
Storage. Once the real QR-code IDs are known you must:

1. Replace the IDs in `mock_card.repository.dart`.
2. Rename / re-upload the matching files in Firebase Storage so
   `{cardId}_front.png` and `{cardId}_reverse.png` keep matching the path
   pattern in `card.model.dart`.

---

# Card-unlock QR codes & cheat sheet

The card catalogue printed on the QR HTML and the Excel cheat sheet lives
in `scripts/card_catalogue.py`. Update that file when the mock data changes
and re-run both generators.

## Obfuscation

The QR payload is **not** the raw card ID. It is a 16-character base32 code
produced by `scripts/card_id_obfuscator.py` (with a byte-for-byte port at
`packages/bear_necessities/lib/app/modules/shared/utils/card_id_obfuscator.dart`).

* Deterministic, 1:1, with strong avalanche so neighbouring IDs produce
  unrelated codes.
* Decoded by `BearApp.tryExtractCardId`. **Only obfuscated codes are
  accepted** — plaintext `?path=TODO_GG_07`-style links are rejected, so do
  not print QR codes with raw IDs.
* Algorithm: 4-round Feistel cipher on an 80-bit block (two 40-bit halves)
  using only XOR / add / shift / rotate, so it ports cleanly to Flutter
  Web's 53-bit safe-integer range.
* Dart and Python reference vectors are pinned in
  `bear_adventure_app/test/card_id_obfuscator_test.dart`. If you ever
  change the master key, regenerate every QR + reprint the cards.

## Generators

Both deps (`qrcode`, `openpyxl`) are in `scripts/requirements.txt`, so the
one-time venv setup at the top of this file covers everything.

```bash
# QR code gallery (HTML, no external deps at view-time)
scripts/.venv/bin/python scripts/generate_unlock_qr_html.py
# -> bear_adventure_app/delivery/_firebase_upload/unlock_qrcodes.html

# Excel cheat sheet (Set / Index / Sport / Card ID / Encoded ID / Deep Link)
scripts/.venv/bin/python scripts/generate_card_unlock_excel.py
# -> bear_adventure_app/delivery/_firebase_upload/unlock_cards.xlsx
```

Both scripts share the catalogue, so the encoded codes in the HTML and the
Excel are guaranteed to match.


