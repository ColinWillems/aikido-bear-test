"""Source-of-truth card catalogue shared by the QR HTML and Excel generators.

The structure mirrors ``mock_card.repository.dart`` for the cards that have a
front side (i.e. cards that can actually be unlocked from a QR — locked-only
slots without art are excluded). When the mock data changes, update this
file in tandem.

Per-set accent colours mirror ``mock_card_collection.repository.dart``.
"""

from __future__ import annotations

# Mapping: collection title -> list of (set label, list of (card_id, sport, global_index)).
CARDS: dict[str, list[tuple[str, list[tuple[str, str, int]]]]] = {
    "GRRReatest Games (Yoyos)": [
        ("Winter Sports", [
            ("TODO_GG_02", "Ski Jumping", 2),
            ("TODO_GG_03", "Curling", 3),
            ("TODO_GG_04", "Figure Skating", 4),
            ("TODO_GG_06", "Speed Skating", 6),
            ("TODO_GG_07", "Cross Country Ski", 7),
            ("TODO_GG_09", "Luge", 9),
        ]),
        ("Water Sports", [
            ("TODO_GG_14", "Surfing", 14),
            ("TODO_GG_15", "Diving", 15),
            ("TODO_GG_16", "Kayaking", 16),
            ("TODO_GG_17", "Wind Surfing", 17),
            ("TODO_GG_18", "Sailing", 18),
            ("TODO_GG_19", "Water Polo", 19),
        ]),
        ("Ball & Team", [
            ("TODO_GG_27", "Baseball", 27),
            ("TODO_GG_29", "Basketball", 29),
            ("TODO_GG_30", "Lacrosse", 30),
            ("TODO_GG_31", "Rugby", 31),
            ("TODO_GG_32", "Beach Volleyball", 32),
            ("TODO_GG_33", "Handball", 33),
        ]),
        ("Racket & Combat", [
            ("TODO_GG_39", "Judo", 39),
            ("TODO_GG_40", "Karate", 40),
            ("TODO_GG_41", "Table Tennis", 41),
            ("TODO_GG_43", "Badminton", 43),
            ("TODO_GG_47", "Pickleball", 47),
            ("TODO_GG_50", "Golf", 50),
        ]),
        ("Athletics & Gym", [
            ("TODO_GG_46", "Hurdles", 46),
            ("TODO_GG_51", "Weightlifting", 51),
            ("TODO_GG_52", "Bouldering", 52),
            ("TODO_GG_54", "Marathon", 54),
            ("TODO_GG_56", "Long Jump", 56),
            ("TODO_GG_59", "Gymnastics", 59),
        ]),
    ],
    "GRRReatest Games Xtreme (Splits)": [
        ("Power & Precision", [
            ("TODO_GGX_02", "Skateboarding", 2),
            ("TODO_GGX_03", "Mountain Biking", 3),
            ("TODO_GGX_07", "Breakdancing", 7),
            ("TODO_GGX_08", "Soapbox Racing", 8),
            ("TODO_GGX_10", "Unicycling", 10),
        ]),
        ("Wild Water", [
            ("TODO_GGX_11", "Wakeboarding", 11),
            ("TODO_GGX_12", "Water Skiing", 12),
            ("TODO_GGX_15", "Whitewater Rafting", 15),
            ("TODO_GGX_16", "Jet Skiing", 16),
            ("TODO_GGX_17", "Hydro Flight", 17),
        ]),
        ("Extreme Heights", [
            ("TODO_GGX_21", "Snowboarding", 21),
            ("TODO_GGX_22", "Sandboarding", 22),
            ("TODO_GGX_24", "Rock Climbing", 24),
            ("TODO_GGX_26", "Sky Diving", 26),
            ("TODO_GGX_27", "Bungee Jumping", 27),
        ]),
    ],
}

# Per-set accent colours (mirror mock_card_collection.repository.dart).
SET_COLORS: dict[str, str] = {
    "Winter Sports":     "#9060A8",
    "Water Sports":      "#60A8D8",
    "Ball & Team":       "#78C030",
    "Racket & Combat":   "#D83030",
    "Athletics & Gym":   "#F0D800",
    "Power & Precision": "#C0F000",
    "Wild Water":        "#00B8D8",
    "Extreme Heights":   "#D80078",
}

# Production deep-link host. Keep in sync with ``BearApp.bearAppUrl``.
BASE_URL = "https://app.bearfruitsnacks.com"
