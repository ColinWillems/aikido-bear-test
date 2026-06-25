#!/usr/bin/env python3
"""Prepare delivered card images for Firebase Storage upload.

This script does three things:

  1. Trims surrounding fully-transparent pixels from every delivered PNG so the
     resulting image actually has the correct card aspect-ratio.
  2. Re-organises the trimmed images into the directory structure expected by
     the Dart models (see ``card.model.dart`` / ``card_set.model.dart`` /
     ``card_collection.model.dart``):

         images/cards/{collection_id}.png
         images/cards/{collection_id}_unlock.png            (campaign banner / bg)
         images/cards/{collection_id}/{set_id}.png          (category card, used as overview thumbnail)
         images/cards/{collection_id}/{set_id}_header.png   (borderless category card, used as set page header)
         images/cards/{collection_id}/{set_id}_unlock.png   (category icon)
         images/cards/{collection_id}/{set_id}/{card_id}_front.png   (optimised, used as thumbnail)
         images/cards/{collection_id}/{set_id}/{card_id}_unlock.png  (high-res, used on card detail)
         images/cards/{collection_id}/{set_id}/{card_id}_reverse.png

  3. Writes a ``mapping_review.md`` so a human can validate the
     sport->category and sport->cardId mapping before uploading.

Usage:

    python3 scripts/prepare_firebase_card_uploads.py \
        --input  bear_adventure_app/delivery \
        --output bear_adventure_app/delivery/_firebase_upload

Optional flags:
    --padding N         Keep N px of transparent padding around the trimmed
                        bbox (default 0).
    --skip-foc-unlock   Skip the high-res "FOC Unlocked" variant
                        ({card_id}_unlock.png). By default this variant is
                        generated and used on the card detail page; the
                        optimised variant ({card_id}_front.png) is used as
                        thumbnail in the overviews.
    --dry-run           Don't write anything, just log what would happen.
"""

from __future__ import annotations

import argparse
import dataclasses
import re
import shutil
import sys
from pathlib import Path
from typing import Iterable

try:
    from PIL import Image
except ImportError:  # pragma: no cover - tooling check
    sys.stderr.write(
        "ERROR: This script requires Pillow. Install with:\n"
        "    pip3 install --user Pillow\n"
    )
    sys.exit(2)


# ---------------------------------------------------------------------------
# Configuration: collection / set / card mapping.
#
# Two collections:
#   - "grrreatest_games"        => the Yoyos delivery (60 cards in total, but
#                                  only 30 sports were delivered to us, so
#                                  numCards=30 in the mockdata).
#   - "grrreatest_games_xtreme" => the Splits delivery (15 cards).
#
# Card IDs are TODO placeholders. They follow the pattern
#   TODO_<COLLECTION_ABBR>_<INDEX>
# and are used both as Card.id in the Dart mockdata AND as the filename in
# Firebase Storage (because Card.frontImagePath embeds card.id).
#
# When the real QR-code IDs are known both the mockdata and the storage
# filenames must be updated.
# ---------------------------------------------------------------------------

# Maps a normalized sport name (lowercased, single spaces) to (set_id, index).
# The index is the "of60" / "of30" number visible on the printed card; we keep
# it so users can cross-reference with the physical product.
YOYOS_SPORTS: dict[str, tuple[str, int]] = {
    # Winter Sports (01-12, salmon/pink locked cards)
    "ski jumping":          ("winter_sports", 2),
    "curling":              ("winter_sports", 3),
    "figure skating":       ("winter_sports", 4),
    "speed skating":        ("winter_sports", 6),
    "cross country ski":    ("winter_sports", 7),
    "luge":                 ("winter_sports", 9),
    # Water Sports (13-24, grey/beige locked cards)
    "surfing":              ("water_sports", 14),
    "diving":               ("water_sports", 15),
    "kayaking":             ("water_sports", 16),
    "wind surfing":         ("water_sports", 17),
    "sailing":              ("water_sports", 18),
    "water polo":           ("water_sports", 19),
    "waterpolo":            ("water_sports", 19),  # alt spelling in delivery
    # Ball & Team (25-36, olive/yellow locked cards)
    "baseball":             ("ball_team", 27),
    "basketball":           ("ball_team", 29),
    "lacrosse":             ("ball_team", 30),
    "rugby":                ("ball_team", 31),
    "beach volleyball":     ("ball_team", 32),
    "handball":             ("ball_team", 33),
    # Racket & Combat (37-45, 47-48, 50 — orange/red H=81)
    "judo":                 ("racket_combat", 39),
    "karate":               ("racket_combat", 40),
    "table tennis":         ("racket_combat", 41),
    "badminton":            ("racket_combat", 43),
    "pickleball":           ("racket_combat", 47),
    "golf":                 ("racket_combat", 50),
    # Athletics & Gym (46, 49, 51-60 — gold/yellow H=24)
    "hurdles":              ("athletics_gym", 46),
    "weightlifting":        ("athletics_gym", 51),
    "bouldering":           ("athletics_gym", 52),
    "marathon":             ("athletics_gym", 54),
    "long jump":            ("athletics_gym", 56),
    "gymnastics":           ("athletics_gym", 59),
}

# Locked-only cards: index -> set_id (based on colour group boundaries).
YOYOS_LOCKED_ONLY: dict[int, str] = {
    # Winter Sports (01-12)
    1:  "winter_sports",
    5:  "winter_sports",
    8:  "winter_sports",
    10: "winter_sports",
    11: "winter_sports",
    12: "winter_sports",
    # Water Sports (13-24)
    13: "water_sports",
    20: "water_sports",
    21: "water_sports",
    22: "water_sports",
    23: "water_sports",
    24: "water_sports",
    # Ball & Team (25-36)
    25: "ball_team",
    26: "ball_team",
    28: "ball_team",
    34: "ball_team",
    35: "ball_team",
    36: "ball_team",
    # Racket & Combat (37-45, 47-48, 50)
    37: "racket_combat",
    38: "racket_combat",
    42: "racket_combat",
    44: "racket_combat",
    45: "racket_combat",
    48: "racket_combat",
    50: "racket_combat",
    # Athletics & Gym (46, 49, 51-60)
    46: "athletics_gym",  # note: Hurdles FOC exists but locked card is yellow
    49: "athletics_gym",
    53: "athletics_gym",
    55: "athletics_gym",
    57: "athletics_gym",
    58: "athletics_gym",
    60: "athletics_gym",
}

SPLITS_SPORTS: dict[str, tuple[str, int]] = {
    # Power & Precision (01-10)
    "skateboarding":        ("power_precision", 2),
    "mountain biking":      ("power_precision", 3),
    "breakdancing":         ("power_precision", 7),
    "soapbox racing":       ("power_precision", 8),
    "unicycling":           ("power_precision", 10),
    # Wild Water (11-20)
    "wakeboarding":         ("wild_water", 11),
    "water skiing":         ("wild_water", 12),
    "whitewater rafting":   ("wild_water", 15),
    "jet skiing":           ("wild_water", 16),
    "hydro flight":         ("wild_water", 17),
    # Extreme Heights (21-30)
    "snowboarding":         ("extreme_heights", 21),
    "sandboarding":         ("extreme_heights", 22),
    "rock climbing":        ("extreme_heights", 24),
    "sky diving":           ("extreme_heights", 26),
    "bungee jumping":       ("extreme_heights", 27),
}

# Locked-only cards for Splits (index -> set_id).
SPLITS_LOCKED_ONLY: dict[int, str] = {
    # Power & Precision (01-10)
    1:  "power_precision",
    4:  "power_precision",
    5:  "power_precision",
    6:  "power_precision",
    9:  "power_precision",
    # Wild Water (11-20)
    13: "wild_water",
    14: "wild_water",
    18: "wild_water",
    19: "wild_water",
    20: "wild_water",
    # Extreme Heights (21-30)
    23: "extreme_heights",
    25: "extreme_heights",
    28: "extreme_heights",
    29: "extreme_heights",
    30: "extreme_heights",
}

# Display titles per sport (used in mapping_review.md).
SPORT_TITLES: dict[str, str] = {
    "water polo": "Water Polo",
    "waterpolo":  "Water Polo",
    # Everything else is title-cased automatically.
}

# Set titles
SET_TITLES: dict[str, str] = {
    "winter_sports":   "Winter Sports",
    "water_sports":    "Water Sports",
    "ball_team":       "Ball & Team",
    "racket_combat":   "Racket & Combat",
    "athletics_gym":   "Athletics & Gym",
    "power_precision": "Power & Precision",
    "wild_water":      "Wild Water",
    "extreme_heights": "Extreme Heights",
}

# Maps a delivery-folder label to the category "icon" filename used in
# the Icons folder (filenames there use these category names verbatim).
ICON_LABEL_TO_SET_ID: dict[str, str] = {
    "athletics & gym":   "athletics_gym",
    "ball & team":       "ball_team",
    "racket & combat":   "racket_combat",
    "water sports":      "water_sports",
    "winter sports":     "winter_sports",
    "extreme heights":   "extreme_heights",
    "power & precision": "power_precision",
    "wild water":        "wild_water",
}

# Two collections.
COLLECTIONS: dict[str, dict] = {
    "grrreatest_games": {
        "title":   "GRRReatest Games",
        "abbr":    "GG",          # used in TODO ids
        "delivery_dir": "Yoyos",
        "sports":  YOYOS_SPORTS,
        "locked_only": YOYOS_LOCKED_ONLY,
        "denominator": 60,        # 'XXof60'
    },
    "grrreatest_games_xtreme": {
        "title":   "GRRReatest Games Xtreme",
        "abbr":    "GGX",
        "delivery_dir": "Splits",
        "sports":  SPLITS_SPORTS,
        "locked_only": SPLITS_LOCKED_ONLY,
        "denominator": 30,
    },
}


# ---------------------------------------------------------------------------
# Image helpers
# ---------------------------------------------------------------------------

def trim_transparent(src: Path, dst: Path, padding: int = 0) -> tuple[tuple[int, int], tuple[int, int]]:
    """Trim transparent border around the image and save to dst.

    Returns (original_size, trimmed_size).
    """
    with Image.open(src) as im:
        if im.mode != "RGBA":
            im = im.convert("RGBA")
        original_size = im.size
        # Compute bbox based on the alpha channel: pixels with alpha > 0.
        alpha = im.getchannel("A")
        bbox = alpha.getbbox()
        if bbox is None:
            # Fully transparent? Just copy.
            dst.parent.mkdir(parents=True, exist_ok=True)
            im.save(dst, format="PNG", optimize=True)
            return original_size, original_size

        if padding > 0:
            x0, y0, x1, y1 = bbox
            x0 = max(0, x0 - padding)
            y0 = max(0, y0 - padding)
            x1 = min(im.width, x1 + padding)
            y1 = min(im.height, y1 + padding)
            bbox = (x0, y0, x1, y1)

        trimmed = im.crop(bbox)
        dst.parent.mkdir(parents=True, exist_ok=True)
        trimmed.save(dst, format="PNG", optimize=True)
        return original_size, trimmed.size


# ---------------------------------------------------------------------------
# Filename parsing
# ---------------------------------------------------------------------------

# Matches a "<sport name> <NN>of<DD>" tail (with possible doubled extensions
# like ".png.png" and stray dots / underscores before the extension).
SPORT_INDEX_RE = re.compile(
    r"(?P<sport>[A-Za-z][A-Za-z &]*?)\s*(?P<index>\d{1,2})of(?P<denom>\d{2,3})[._\s]*\.png(?:\.png)?$",
    re.IGNORECASE,
)

# Matches a locked-card filename: "..._Locked Cards_NNof60.png"
LOCKED_CARD_RE = re.compile(
    r"Locked\s*Cards[_\s]+(?P<index>\d{1,2})of(?P<denom>\d{2,3})\.+png$",
    re.IGNORECASE,
)


def normalize_sport(raw: str) -> str:
    """Lowercase and collapse whitespace."""
    return " ".join(raw.lower().strip().split())


def display_sport(name: str) -> str:
    """Return a human-friendly title for a sport."""
    if name in SPORT_TITLES:
        return SPORT_TITLES[name]
    return " ".join(part.capitalize() for part in name.split())


# ---------------------------------------------------------------------------
# Cardid generation
# ---------------------------------------------------------------------------

def todo_card_id(abbr: str, index: int) -> str:
    """Return the TODO placeholder card id, e.g. 'TODO_GG_02'."""
    return f"TODO_{abbr}_{index:02d}"


# ---------------------------------------------------------------------------
# Main processing
# ---------------------------------------------------------------------------

@dataclasses.dataclass
class ProcessResult:
    written: list[str] = dataclasses.field(default_factory=list)
    skipped: list[tuple[str, str]] = dataclasses.field(default_factory=list)  # (path, reason)
    warnings: list[str] = dataclasses.field(default_factory=list)
    sports_seen: dict[str, dict[tuple[str, int], dict]] = dataclasses.field(default_factory=dict)
    # sports_seen[collection_id][(set_id, index)] = {
    #     "front": bool, "reverse": bool, "set_id": str, "index": int, "card_id": str,
    # }


def _ensure_sport_record(result: ProcessResult, collection_id: str, sport: str,
                         set_id: str, index: int, card_id: str) -> dict:
    bucket = result.sports_seen.setdefault(collection_id, {})
    key = (set_id, index)
    if key not in bucket:
        bucket[key] = {
            "front": False,
            "reverse": False,
            "set_id": set_id,
            "index": index,
            "card_id": card_id,
        }
    return bucket[key]


def process_card_titles(input_dir: Path, output_dir: Path,
                         padding: int, dry_run: bool, result: ProcessResult) -> None:
    """Card Title -> images/cards/{collection_id}.png"""
    for collection_id, conf in COLLECTIONS.items():
        title_dir = input_dir / conf["delivery_dir"] / "Card Title"
        if not title_dir.is_dir():
            result.warnings.append(f"Missing 'Card Title' folder: {title_dir}")
            continue
        pngs = sorted(p for p in title_dir.iterdir() if p.suffix.lower() == ".png")
        if not pngs:
            result.warnings.append(f"No PNGs in {title_dir}")
            continue
        if len(pngs) > 1:
            result.warnings.append(
                f"Multiple Card Title images in {title_dir}, using {pngs[0].name}"
            )
        src = pngs[0]
        dst = output_dir / "images" / "cards" / f"{collection_id}.png"
        if dry_run:
            result.written.append(str(dst))
        else:
            trim_transparent(src, dst, padding=padding)
            result.written.append(str(dst))


def process_category_cards(input_dir: Path, output_dir: Path,
                            padding: int, dry_run: bool, result: ProcessResult) -> None:
    """Category Cards -> images/cards/{collection_id}/{set_id}.png

    Some deliveries also include a borderless variant of each category card
    (filename ends with ``_Without border`` or ``_Without Border``). These are
    used as the header image on the set page and are written as
    ``{set_id}_header.png``.

    The borderless variants may live next to the bordered ones (Splits) or in
    a subfolder such as ``New header/`` (Yoyos), so we walk the tree
    recursively.
    """
    for collection_id, conf in COLLECTIONS.items():
        cat_dir = input_dir / conf["delivery_dir"] / "Category Cards"
        if not cat_dir.is_dir():
            result.warnings.append(f"Missing 'Category Cards' folder: {cat_dir}")
            continue
        for src in sorted(p for p in cat_dir.rglob("*.png")):
            stem = src.stem
            is_header = stem.lower().endswith("_without border")
            label_source = stem[: -len("_without border")] if is_header else stem
            label = _extract_category_label(label_source + ".png")
            if not label:
                result.skipped.append((str(src), "could not parse category label"))
                continue
            set_id = ICON_LABEL_TO_SET_ID.get(label)
            if not set_id:
                result.skipped.append((str(src), f"unknown category label '{label}'"))
                continue
            target_name = f"{set_id}_header.png" if is_header else f"{set_id}.png"
            dst = output_dir / "images" / "cards" / collection_id / target_name
            if dry_run:
                result.written.append(str(dst))
            else:
                trim_transparent(src, dst, padding=padding)
                result.written.append(str(dst))


def process_icons(input_dir: Path, output_dir: Path,
                   padding: int, dry_run: bool, result: ProcessResult) -> None:
    """Icons -> images/cards/{collection_id}/{set_id}_unlock.png"""
    for collection_id, conf in COLLECTIONS.items():
        icon_dir = input_dir / conf["delivery_dir"] / "Icons"
        if not icon_dir.is_dir():
            result.warnings.append(f"Missing 'Icons' folder: {icon_dir}")
            continue
        for src in sorted(p for p in icon_dir.iterdir() if p.suffix.lower() == ".png"):
            label = _extract_category_label(src.name)
            if not label:
                result.skipped.append((str(src), "could not parse icon label"))
                continue
            set_id = ICON_LABEL_TO_SET_ID.get(label)
            if not set_id:
                result.skipped.append((str(src), f"unknown icon label '{label}'"))
                continue
            dst = output_dir / "images" / "cards" / collection_id / f"{set_id}_unlock.png"
            if dry_run:
                result.written.append(str(dst))
            else:
                trim_transparent(src, dst, padding=padding)
                result.written.append(str(dst))


def _extract_category_label(filename: str) -> str | None:
    """Extract the category label (e.g. 'Water Sports') from a filename.

    Filenames look like:
      BEAR_EComm_App_Cards_Icons_Yoyo_Water Sports.png
      BEAR_EComm_App_Cards_Icons_Yoyo_Yoyo_Winter Sports.png   (typo, double Yoyo)
      BEAR_CARD_App_GRRREATEST GAMES_Yoyo_Category Cards_Athletics & Gym.png
      BEAR_CARD_App_Category Cards_GRRREATEST GAMES XTREME_Splits_Wild Water.png
      BEAR_App_Cards_Icons_GRRREATEST GAMES XTREME_Splits_Wild Water.png

    The category name is always the last token before .png. We just take
    the substring after the final underscore.
    """
    stem = filename.rsplit(".", 1)[0]
    # Take everything after the last underscore.
    if "_" not in stem:
        return None
    label = stem.rsplit("_", 1)[1]
    return normalize_sport(label)


def process_card_fronts(input_dir: Path, output_dir: Path,
                         padding: int, dry_run: bool, result: ProcessResult) -> None:
    """FOC Unlocked Optimised -> {collection_id}/{set_id}/{card_id}_front.png.

    The optimised (smaller) variant is used as the thumbnail in the collection
    and set overviews. The high-res variant ({card_id}_unlock.png) is used on
    the card detail page (see ``process_foc_unlock``).

    If the delivery does not include a separate ``FOC Unlocked Optimised``
    folder, we fall back to the regular ``FOC Unlocked`` folder so the
    thumbnail is at least correct (just larger than necessary).
    """
    for collection_id, conf in COLLECTIONS.items():
        foc_dir = input_dir / conf["delivery_dir"] / "FOC Unlocked Optimised"
        if not foc_dir.is_dir():
            fallback = input_dir / conf["delivery_dir"] / "FOC Unlocked"
            if fallback.is_dir():
                result.warnings.append(
                    f"[{collection_id}] No 'FOC Unlocked Optimised' folder; "
                    f"falling back to 'FOC Unlocked' for {{card_id}}_front.png"
                )
                foc_dir = fallback
            else:
                result.warnings.append(f"Missing 'FOC Unlocked Optimised' folder: {foc_dir}")
                continue
        for src in sorted(p for p in foc_dir.iterdir() if p.suffix.lower() == ".png"):
            sport, idx, denom = _parse_sport_index(src.name)
            if not sport:
                result.skipped.append((str(src), "could not parse sport name + index"))
                continue
            sport_norm = normalize_sport(sport)
            mapping = conf["sports"].get(sport_norm)
            if not mapping:
                result.warnings.append(
                    f"[{collection_id}] Unmapped sport in FOC Unlocked Optimised: "
                    f"'{sport}' (file: {src.name})"
                )
                result.skipped.append((str(src), f"unmapped sport '{sport_norm}'"))
                continue
            set_id, expected_idx = mapping
            if idx != expected_idx:
                result.warnings.append(
                    f"[{collection_id}] Index mismatch for '{sport_norm}': "
                    f"file says {idx}, mapping says {expected_idx} (file: {src.name})"
                )
            card_id = todo_card_id(conf["abbr"], expected_idx)
            dst = (output_dir / "images" / "cards" / collection_id / set_id /
                   f"{card_id}_front.png")
            if dry_run:
                result.written.append(str(dst))
            else:
                trim_transparent(src, dst, padding=padding)
                result.written.append(str(dst))
            rec = _ensure_sport_record(result, collection_id, sport_norm,
                                        set_id, expected_idx, card_id)
            rec["front"] = True


def process_card_reverses(input_dir: Path, output_dir: Path,
                           padding: int, dry_run: bool, result: ProcessResult) -> None:
    """BOC Answers_Puzzles -> {collection_id}/{set_id}/{card_id}_reverse.png"""
    for collection_id, conf in COLLECTIONS.items():
        boc_dir = input_dir / conf["delivery_dir"] / "BOC Answers_Puzzles"
        if not boc_dir.is_dir():
            result.warnings.append(f"Missing 'BOC Answers_Puzzles' folder: {boc_dir}")
            continue
        for src in sorted(p for p in boc_dir.iterdir() if p.suffix.lower() == ".png"):
            sport, idx, denom = _parse_sport_index(src.name)
            if not sport:
                result.skipped.append((str(src), "could not parse sport name + index"))
                continue
            sport_norm = normalize_sport(sport)
            mapping = conf["sports"].get(sport_norm)
            if not mapping:
                result.warnings.append(
                    f"[{collection_id}] Unmapped sport in BOC: '{sport}' (file: {src.name})"
                )
                result.skipped.append((str(src), f"unmapped sport '{sport_norm}'"))
                continue
            set_id, expected_idx = mapping
            if idx != expected_idx:
                result.warnings.append(
                    f"[{collection_id}] BOC index mismatch for '{sport_norm}': "
                    f"file says {idx}, mapping says {expected_idx} (file: {src.name})"
                )
            card_id = todo_card_id(conf["abbr"], expected_idx)
            dst = (output_dir / "images" / "cards" / collection_id / set_id /
                   f"{card_id}_reverse.png")
            if dry_run:
                result.written.append(str(dst))
            else:
                trim_transparent(src, dst, padding=padding)
                result.written.append(str(dst))
            rec = _ensure_sport_record(result, collection_id, sport_norm,
                                        set_id, expected_idx, card_id)
            rec["reverse"] = True


def process_foc_unlock(input_dir: Path, output_dir: Path,
                        padding: int, dry_run: bool, result: ProcessResult) -> None:
    """FOC Unlocked (high-res) -> {card_id}_unlock.png.

    The high-res variant is used on the card detail page so that the user
    sees a sharp image when zoomed. The optimised variant ({card_id}_front.png)
    is used as thumbnail in the collection / set overviews.
    """
    for collection_id, conf in COLLECTIONS.items():
        foc_dir = input_dir / conf["delivery_dir"] / "FOC Unlocked"
        if not foc_dir.is_dir():
            result.warnings.append(f"Missing 'FOC Unlocked' folder: {foc_dir}")
            continue
        for src in sorted(p for p in foc_dir.iterdir() if p.suffix.lower() == ".png"):
            sport, idx, denom = _parse_sport_index(src.name)
            if not sport:
                result.skipped.append((str(src), "could not parse FOC unlock filename"))
                continue
            sport_norm = normalize_sport(sport)
            mapping = conf["sports"].get(sport_norm)
            if not mapping:
                result.warnings.append(
                    f"[{collection_id}] Unmapped sport in FOC Unlocked: '{sport}'"
                )
                result.skipped.append((str(src), f"unmapped sport '{sport_norm}'"))
                continue
            set_id, expected_idx = mapping
            card_id = todo_card_id(conf["abbr"], expected_idx)
            dst = (output_dir / "images" / "cards" / collection_id / set_id /
                   f"{card_id}_unlock.png")
            if dry_run:
                result.written.append(str(dst))
            else:
                trim_transparent(src, dst, padding=padding)
                result.written.append(str(dst))


def _parse_sport_index(filename: str) -> tuple[str | None, int | None, int | None]:
    """Parse '... <Sport Name> NNof60.png' / '... NNof30.png.png' (etc.).

    Returns (sport, index, denominator) or (None, None, None).
    """
    match = SPORT_INDEX_RE.search(filename)
    if not match:
        return None, None, None
    sport = match.group("sport").strip()
    # The regex is greedy on letters/spaces; strip any trailing connector words
    # that snuck in (e.g. "Optimised_Long Jump" already lost the underscore so
    # the sport is "Long Jump"). Filenames sometimes have leading underscores
    # that the [A-Za-z] anchor already handles.
    return sport, int(match.group("index")), int(match.group("denom"))


def process_locked_cards(input_dir: Path, output_dir: Path,
                          padding: int, dry_run: bool, result: ProcessResult) -> None:
    """Locked Cards -> {collection_id}/{set_id}/{card_id}_locked.png

    Locked cards are the placeholder images shown when a card has not yet been
    unlocked. Every index in the delivery gets a locked image; the ones that
    also have a FOC/BOC image are the "fully delivered" cards, the rest are
    locked-only cards that will be unlocked in a later delivery.
    """
    for collection_id, conf in COLLECTIONS.items():
        locked_dir = input_dir / conf["delivery_dir"] / "Locked Cards"
        if not locked_dir.is_dir():
            result.warnings.append(f"Missing 'Locked Cards' folder: {locked_dir}")
            continue
        for src in sorted(p for p in locked_dir.iterdir() if p.suffix.lower() == ".png"):
            match = LOCKED_CARD_RE.search(src.name)
            if not match:
                result.skipped.append((str(src), "could not parse locked card index"))
                continue
            index = int(match.group("index"))
            # Determine set_id: first check sport mapping, then locked_only mapping.
            set_id: str | None = None
            for sport_norm, (sid, idx) in conf["sports"].items():
                if idx == index:
                    set_id = sid
                    break
            if set_id is None:
                set_id = conf.get("locked_only", {}).get(index)
            if set_id is None:
                result.warnings.append(
                    f"[{collection_id}] No set mapping for locked card index {index} "
                    f"(file: {src.name})"
                )
                result.skipped.append((str(src), f"no set mapping for index {index}"))
                continue
            card_id = todo_card_id(conf["abbr"], index)
            dst = (output_dir / "images" / "cards" / collection_id / set_id /
                   f"{card_id}_locked.png")
            if dry_run:
                result.written.append(str(dst))
            else:
                trim_transparent(src, dst, padding=padding)
                result.written.append(str(dst))


# ---------------------------------------------------------------------------
# Reporting
# ---------------------------------------------------------------------------

def write_mapping_review(output_dir: Path, result: ProcessResult) -> None:
    lines: list[str] = []
    lines.append("# Card mapping review")
    lines.append("")
    lines.append("Generated by `scripts/prepare_firebase_card_uploads.py`.")
    lines.append("")
    lines.append("Each row shows what file ends up at which Firebase Storage path.")
    lines.append("")
    lines.append("> ⚠️ Card IDs are TODO placeholders. They will need to be replaced "
                 "with the real QR-code IDs (and the Storage filenames renamed accordingly).")
    lines.append("")

    for collection_id, conf in COLLECTIONS.items():
        lines.append(f"## `{collection_id}` — {conf['title']}")
        lines.append("")
        sports = conf["sports"]
        locked_only = conf.get("locked_only", {})
        # Group by set_id.
        by_set: dict[str, list[tuple[str, int]]] = {}
        for sport_norm, (set_id, idx) in sports.items():
            existing = by_set.setdefault(set_id, [])
            if any(idx == other_idx for _, other_idx in existing):
                continue
            existing.append((sport_norm, idx))
        # Add locked-only entries (no sport name known yet).
        for idx, set_id in locked_only.items():
            existing = by_set.setdefault(set_id, [])
            existing.append(("(locked only)", idx))

        seen = result.sports_seen.get(collection_id, {})

        for set_id in sorted(by_set):
            lines.append(f"### Set `{set_id}` — {SET_TITLES.get(set_id, set_id)}")
            lines.append("")
            lines.append("| Sport | Card index | Card ID (TODO) | front? | reverse? |")
            lines.append("|---|---|---|---|---|")
            for sport_norm, idx in sorted(by_set[set_id], key=lambda t: t[1]):
                card_id = todo_card_id(conf["abbr"], idx)
                rec = seen.get((set_id, idx), {})
                lines.append(
                    f"| {display_sport(sport_norm)} | "
                    f"{idx:02d}of{conf['denominator']} | "
                    f"`{card_id}` | "
                    f"{'✅' if rec.get('front') else '❌'} | "
                    f"{'✅' if rec.get('reverse') else '❌'} |"
                )
            lines.append("")
        sports = conf["sports"]
        # Group by set_id.
        by_set: dict[str, list[tuple[str, int]]] = {}
        for sport_norm, (set_id, idx) in sports.items():
            # Skip aliases that map to an existing canonical entry.
            existing = by_set.setdefault(set_id, [])
            # Avoid double-listing aliases (water polo / waterpolo).
            if any(idx == other_idx for _, other_idx in existing):
                continue
            existing.append((sport_norm, idx))

        seen = result.sports_seen.get(collection_id, {})

        for set_id in sorted(by_set):
            lines.append(f"### Set `{set_id}` — {SET_TITLES.get(set_id, set_id)}")
            lines.append("")
            lines.append("| Sport | Card index | Card ID (TODO) | front? | reverse? |")
            lines.append("|---|---|---|---|---|")
            for sport_norm, idx in sorted(by_set[set_id], key=lambda t: t[1]):
                card_id = todo_card_id(conf["abbr"], idx)
                rec = seen.get((set_id, idx), {})
                lines.append(
                    f"| {display_sport(sport_norm)} | "
                    f"{idx:02d}of{conf['denominator']} | "
                    f"`{card_id}` | "
                    f"{'✅' if rec.get('front') else '❌'} | "
                    f"{'✅' if rec.get('reverse') else '❌'} |"
                )
            lines.append("")

    if result.warnings:
        lines.append("## ⚠️ Warnings")
        lines.append("")
        for w in result.warnings:
            lines.append(f"- {w}")
        lines.append("")

    if result.skipped:
        lines.append("## ⏭️ Skipped files")
        lines.append("")
        for path, reason in result.skipped:
            lines.append(f"- `{path}` — {reason}")
        lines.append("")

    output_dir.mkdir(parents=True, exist_ok=True)
    (output_dir / "mapping_review.md").write_text("\n".join(lines), encoding="utf-8")


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

def main(argv: Iterable[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                      formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--input", required=True, type=Path,
                        help="Path to the delivery folder.")
    parser.add_argument("--output", required=True, type=Path,
                        help="Where to place the prepared upload directory.")
    parser.add_argument("--padding", type=int, default=0,
                        help="Pixels of transparent padding to keep around the trimmed bbox.")
    parser.add_argument("--skip-foc-unlock", action="store_true",
                        help="Skip the high-res 'FOC Unlocked' variant. "
                             "By default this is generated as "
                             "{card_id}_unlock.png and used on the card "
                             "detail page.")
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--clean", action="store_true",
                        help="Remove the output directory first.")
    args = parser.parse_args(argv)

    input_dir: Path = args.input.resolve()
    output_dir: Path = args.output.resolve()

    if not input_dir.is_dir():
        sys.stderr.write(f"ERROR: input directory not found: {input_dir}\n")
        return 2

    if args.clean and output_dir.exists() and not args.dry_run:
        # Safety: only clean if it's our own _firebase_upload directory.
        if output_dir.name == "_firebase_upload":
            shutil.rmtree(output_dir)
        else:
            sys.stderr.write(
                f"Refusing to --clean a directory not named '_firebase_upload': {output_dir}\n"
            )
            return 2

    result = ProcessResult()

    process_card_titles(input_dir, output_dir, args.padding, args.dry_run, result)
    process_category_cards(input_dir, output_dir, args.padding, args.dry_run, result)
    process_icons(input_dir, output_dir, args.padding, args.dry_run, result)
    process_card_fronts(input_dir, output_dir, args.padding, args.dry_run, result)
    process_card_reverses(input_dir, output_dir, args.padding, args.dry_run, result)
    if not args.skip_foc_unlock:
        process_foc_unlock(input_dir, output_dir, args.padding, args.dry_run, result)
    process_locked_cards(input_dir, output_dir, args.padding, args.dry_run, result)

    write_mapping_review(output_dir, result)

    print(f"Wrote {len(result.written)} file(s) to {output_dir}")
    if result.warnings:
        print(f"  ⚠️  {len(result.warnings)} warning(s) — see mapping_review.md")
    if result.skipped:
        print(f"  ⏭️  {len(result.skipped)} skipped file(s) — see mapping_review.md")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
