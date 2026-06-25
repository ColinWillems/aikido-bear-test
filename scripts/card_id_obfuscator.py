"""Deterministic card-ID obfuscation shared between scripts and the app.

The Bear Adventure app accepts deep links of the form
``https://app.bearfruitsnacks.com/?path=<code>`` to unlock a card. The
plaintext card IDs (``TODO_GG_07``, ``TODO_GGX_15``, ...) follow a trivially
guessable pattern, so we obfuscate them into 16-character codes such as
``7NMDSYKYSH4TNEYF`` before printing them on a QR.

Properties of the encoding:

* **Deterministic & bijective.** Each ``card_id`` maps to exactly one
  ``code`` and back. Encoding the same ID twice always produces the same code.
* **Avalanche.** Consecutive IDs (``TODO_GG_07`` vs ``TODO_GG_08``) produce
  wildly different codes; you cannot infer one code from a neighbouring one.
* **Compact.** Codes are always 16 characters from an unambiguous base32
  alphabet (no ``0/O``, ``1/I``, etc.), making them URL-safe and easy to
  inspect manually.
* **Portable.** The algorithm is a 4-round Feistel cipher on an 80-bit block
  (two 40-bit halves) using only XOR / add / shift / rotate, so it ports
  cleanly to Flutter Web's 53-bit JS-number integers. The Dart port lives in
  ``packages/bear_necessities/lib/app/modules/shared/utils/card_id_obfuscator.dart``
  and MUST stay byte-for-byte identical to this file.

If you ever need to introduce new card-ID shapes, extend ``_id_to_int`` /
``_int_to_id`` in BOTH this file and the Dart port simultaneously, and add a
roundtrip test for the new shape.
"""

from __future__ import annotations

# ---------------------------------------------------------------------------
# Tunables — MUST match the Dart port byte-for-byte.
# ---------------------------------------------------------------------------

# Four 40-bit round keys for the Feistel cipher. Changing any of these
# invalidates every QR code currently in the wild — DO NOT change.
_MASTER_KEY: tuple[int, int, int, int] = (
    0xA5C3F19E72,
    0x3F1C5A92B4,
    0x9E724B1F8C,
    0xC73E5A91F4,
)

# 32-symbol base32 alphabet without visually ambiguous characters
# (no 0/O, no 1/I). Decoders accept lower-case input as well.
_ALPHABET = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
assert len(_ALPHABET) == 32

_INDEX: dict[str, int] = {c: i for i, c in enumerate(_ALPHABET)}

# How many base32 chars per code. 16 chars * 5 bits/char = 80 bits, which is
# exactly the Feistel block size so every cipher output fits with no leading
# padding (avoiding a recognizable "always-A" prefix).
_CODE_LEN = 16

# Feistel block geometry. 40-bit halves keep every intermediate value safely
# below 2**53 so the Dart port stays correct on Flutter Web's JS-number
# integers. The round function therefore avoids large multiplications and
# uses only XOR / add / shift / rotate.
_HALF_BITS = 40
_HALF_MASK = (1 << _HALF_BITS) - 1
_BLOCK_BITS = _HALF_BITS * 2

# ID-space partitioning. Each known card-ID prefix is mapped to a contiguous
# integer range; the integer is what the Feistel cipher operates on. Ranges
# must not overlap and must fit in the 80-bit block (trivially so).
_PREFIX_GG = "TODO_GG_"      # 1..60
_PREFIX_GGX = "TODO_GGX_"    # 1..30 -> stored as 100..130
_GGX_OFFSET = 100


# ---------------------------------------------------------------------------
# 80-bit Feistel cipher (two 40-bit halves)
# ---------------------------------------------------------------------------

def _rotl40(x: int, n: int) -> int:
    """Rotate a 40-bit value left by ``n`` bits.

    Implemented as ``(x << n) | (x >> (40 - n))`` but with every shift count
    capped at <=13 so the pre-mask intermediate stays below 2**53 (the safe
    integer range on Flutter Web).
    """
    n %= _HALF_BITS
    if n == 0:
        return x & _HALF_MASK
    # Worst case here: x ~ 2**40 - 1, n = 13 -> x << n ~ 2**53 - 2**13 < 2**53.
    left = ((x << n) & _HALF_MASK)
    right = x >> (_HALF_BITS - n)
    return (left | right) & _HALF_MASK


def _f(half: int, k: int) -> int:
    """Round function: 40-bit -> 40-bit, keyed by ``k``.

    xorshift-style mixer using only XOR, add, shift and rotate so the Dart
    port mirrors it verbatim. Every shift count is <=13 so the worst-case
    pre-mask intermediate is ``(2**40 - 1) * 2**13 < 2**53`` — safe on
    Flutter Web.
    """
    x = (half + k) & _HALF_MASK
    x ^= _rotl40(x, 13)
    x = (x + ((x << 7) & _HALF_MASK)) & _HALF_MASK
    x ^= _rotl40(x, 11)
    x = (x + ((x << 5) & _HALF_MASK)) & _HALF_MASK
    x ^= _rotl40(x, 9)
    return x & _HALF_MASK


def _encrypt(left: int, right: int) -> tuple[int, int]:
    """Apply the forward Feistel network. Inputs and outputs are two 40-bit
    halves so the result fits in Dart's 64-bit ``int`` (the combined 80-bit
    value would not)."""
    left &= _HALF_MASK
    right &= _HALF_MASK
    for k in _MASTER_KEY:
        left, right = right, (left ^ _f(right, k)) & _HALF_MASK
    return left, right


def _decrypt(left: int, right: int) -> tuple[int, int]:
    """Invert :func:`_encrypt`."""
    left &= _HALF_MASK
    right &= _HALF_MASK
    for k in reversed(_MASTER_KEY):
        # Undo (L,R) -> (R, L XOR F(R,k))
        prev_right = left
        prev_left = (right ^ _f(left, k)) & _HALF_MASK
        left, right = prev_left, prev_right
    return left, right


# ---------------------------------------------------------------------------
# Base32 helpers
# ---------------------------------------------------------------------------

# Each 40-bit half encodes to exactly 8 base32 chars; the two halves are
# concatenated (high half first) to form the final 16-char code.
_HALF_CODE_LEN = _HALF_BITS // 5  # = 8


def _half_to_base32(n: int) -> str:
    """Encode a 40-bit unsigned int as exactly 8 base32 chars (big-endian)."""
    if n < 0 or n > _HALF_MASK:
        raise ValueError(f"value {n} does not fit in {_HALF_BITS} bits")
    chars: list[str] = []
    for _ in range(_HALF_CODE_LEN):
        chars.append(_ALPHABET[n & 31])
        n >>= 5
    return "".join(reversed(chars))


def _half_from_base32(code: str) -> int:
    """Decode an 8-char base32 chunk back into a 40-bit int. Case-insensitive."""
    n = 0
    for ch in code.upper():
        idx = _INDEX.get(ch)
        if idx is None:
            raise ValueError(f"invalid base32 character: {ch!r}")
        n = (n << 5) | idx
    return n & _HALF_MASK


# ---------------------------------------------------------------------------
# ID <-> integer mapping
# ---------------------------------------------------------------------------

def _id_to_int(card_id: str) -> int:
    """Map a known plaintext card ID to its integer slot."""
    if card_id.startswith(_PREFIX_GGX):
        suffix = card_id[len(_PREFIX_GGX):]
        idx = int(suffix)
        if not 1 <= idx <= 30:
            raise ValueError(f"GGX index out of range: {card_id}")
        return _GGX_OFFSET + idx
    if card_id.startswith(_PREFIX_GG):
        suffix = card_id[len(_PREFIX_GG):]
        idx = int(suffix)
        if not 1 <= idx <= 60:
            raise ValueError(f"GG index out of range: {card_id}")
        return idx
    raise ValueError(f"unknown card-ID shape: {card_id!r}")


def _int_to_id(n: int) -> str:
    """Inverse of :func:`_id_to_int`. Returns the canonical card-ID string."""
    if 1 <= n <= 60:
        return f"{_PREFIX_GG}{n:02d}"
    if _GGX_OFFSET + 1 <= n <= _GGX_OFFSET + 30:
        return f"{_PREFIX_GGX}{n - _GGX_OFFSET:02d}"
    raise ValueError(f"integer slot does not map to a known card: {n}")


# ---------------------------------------------------------------------------
# Public API
# ---------------------------------------------------------------------------

def encode_card_id(card_id: str) -> str:
    """Encode a plaintext card ID into its obfuscated 16-char code."""
    n = _id_to_int(card_id)
    # The plaintext lives in the low 40 bits; the high 40-bit half is zero.
    left, right = _encrypt((n >> _HALF_BITS) & _HALF_MASK, n & _HALF_MASK)
    return _half_to_base32(left) + _half_to_base32(right)


def decode_card_id(code: str) -> str:
    """Decode an obfuscated code back into its plaintext card ID.

    Raises ``ValueError`` if the code is malformed or does not correspond to
    a known card.
    """
    if len(code) != _CODE_LEN:
        raise ValueError(f"code must be {_CODE_LEN} chars, got {len(code)}")
    left = _half_from_base32(code[:_HALF_CODE_LEN])
    right = _half_from_base32(code[_HALF_CODE_LEN:])
    plain_left, plain_right = _decrypt(left, right)
    n = (plain_left << _HALF_BITS) | plain_right
    return _int_to_id(n)


def try_decode_card_id(code: str) -> str | None:
    """Lenient counterpart to :func:`decode_card_id`. Returns ``None`` instead
    of raising for invalid input."""
    try:
        return decode_card_id(code)
    except (ValueError, KeyError):
        return None


def all_known_card_ids() -> list[str]:
    """Return every plaintext card ID currently in the obfuscation domain.

    Useful for generators (Excel, QR HTML) that want to enumerate the whole
    catalogue without depending on the Dart mock data.
    """
    return (
        [f"{_PREFIX_GG}{i:02d}" for i in range(1, 61)]
        + [f"{_PREFIX_GGX}{i:02d}" for i in range(1, 31)]
    )


if __name__ == "__main__":  # pragma: no cover - manual smoke test
    for cid in all_known_card_ids():
        code = encode_card_id(cid)
        back = decode_card_id(code)
        assert back == cid, (cid, code, back)
        print(f"{cid:<14s} -> {code}")
