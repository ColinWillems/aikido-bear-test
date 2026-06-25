/// Deterministic card-ID obfuscation shared between the Flutter app and the
/// QR / Excel generator scripts.
///
/// MUST stay byte-for-byte identical to
/// ``scripts/card_id_obfuscator.py``. See that file for the rationale.
///
/// Properties of the encoding:
/// * Deterministic, bijective 1:1 mapping between plaintext card IDs
///   (``TODO_GG_07``, ``TODO_GGX_15``, ...) and 4-character codes such as
///   ``AZJJ`` / ``BXHE``.
/// * Strong avalanche — neighbouring IDs produce completely unrelated codes.
/// * Codes use an unambiguous base32 alphabet (no ``0/O``, ``1/I``) and are
///   URL-safe.
///
/// Decoding is case-insensitive so deep links remain robust against
/// well-meaning URL normalisation.
library;

class CardIdObfuscator {
  CardIdObfuscator._();

  // --------------------------------------------------------------------
  // Tunables — MUST match scripts/card_id_obfuscator.py byte-for-byte.
  // --------------------------------------------------------------------

  /// Four 40-bit round keys for the Feistel cipher. Changing any of these
  /// invalidates every QR code currently in the wild — DO NOT change.
  static const List<int> _masterKey = <int>[
    0xA5C3F19E72,
    0x3F1C5A92B4,
    0x9E724B1F8C,
    0xC73E5A91F4,
  ];

  /// 32-symbol base32 alphabet without visually ambiguous characters
  /// (no ``0/O``, no ``1/I``).
  static const String _alphabet = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";

  /// Fixed code length in base32 chars. 16 chars × 5 bits/char = 80 bits,
  /// exactly the Feistel block size so every cipher output fits with no
  /// leading padding.
  static const int _codeLen = 16;

  // Feistel block geometry. 40-bit halves with all shift counts <= 13 keep
  // every pre-mask intermediate below 2**53, which is Flutter Web's safe
  // integer ceiling.
  static const int _halfBits = 40;
  static const int _halfMask = (1 << _halfBits) - 1; // 0xFFFFFFFFFF

  // ID-space partitioning. Keep in sync with the Python module.
  static const String _prefixGg = "TODO_GG_";
  static const String _prefixGgx = "TODO_GGX_";
  static const int _ggxOffset = 100;

  // --------------------------------------------------------------------
  // Public API
  // --------------------------------------------------------------------

  /// Encode a plaintext card ID into its obfuscated 16-char code.
  ///
  /// Throws [ArgumentError] for unknown card IDs.
  static String encode(String cardId) {
    final int n = _idToInt(cardId);
    // The plaintext lives in the low 40 bits; the high half is zero.
    final List<int> halves = _encrypt((n >> _halfBits) & _halfMask, n & _halfMask);
    return _halfToBase32(halves[0]) + _halfToBase32(halves[1]);
  }

  /// Decode an obfuscated code back into its plaintext card ID.
  ///
  /// Returns ``null`` for malformed codes or codes that do not correspond
  /// to a known card. Case-insensitive.
  static String? tryDecode(String code) {
    if (code.length != _codeLen) return null;
    final int? leftCipher = _halfFromBase32(code.substring(0, _halfCodeLen));
    final int? rightCipher = _halfFromBase32(code.substring(_halfCodeLen));
    if (leftCipher == null || rightCipher == null) return null;
    final List<int> plain = _decrypt(leftCipher, rightCipher);
    // Slot must fit in 40 bits — anything in the high half means bogus input.
    if (plain[0] != 0) return null;
    return _tryIntToId(plain[1]);
  }

  /// Whether [value] looks like an obfuscated code (right length and only
  /// alphabet chars). Does not verify that it decodes to a known card.
  static bool looksLikeCode(String value) {
    if (value.length != _codeLen) return false;
    final upper = value.toUpperCase();
    for (int i = 0; i < upper.length; i++) {
      if (!_alphabet.contains(upper[i])) return false;
    }
    return true;
  }

  // --------------------------------------------------------------------
  // 80-bit Feistel cipher (two 40-bit halves)
  //
  // Uses only XOR / add / shift / rotate so the Python port mirrors it
  // verbatim. Every shift count is <=13 so the worst-case pre-mask
  // intermediate is ``(2^40 - 1) * 2^13 < 2^53`` — safe on Flutter Web's
  // JS-number integers.
  // --------------------------------------------------------------------

  /// Rotate a 40-bit value left by [n] bits. The mask + cap on [n] guarantee
  /// the result fits in 40 bits and the pre-mask intermediate fits in 53.
  static int _rotl40(int x, int n) {
    n %= _halfBits;
    if (n == 0) return x & _halfMask;
    final int left = (x << n) & _halfMask;
    final int right = x >> (_halfBits - n);
    return (left | right) & _halfMask;
  }

  static int _f(int half, int k) {
    int x = (half + k) & _halfMask;
    x ^= _rotl40(x, 13);
    x = (x + ((x << 7) & _halfMask)) & _halfMask;
    x ^= _rotl40(x, 11);
    x = (x + ((x << 5) & _halfMask)) & _halfMask;
    x ^= _rotl40(x, 9);
    return x & _halfMask;
  }

  /// Forward Feistel network. Inputs and outputs are two 40-bit halves so
  /// the result fits in Dart's 64-bit int (the combined 80-bit value would
  /// not). Returned as ``[left, right]``.
  static List<int> _encrypt(int left, int right) {
    left &= _halfMask;
    right &= _halfMask;
    for (final k in _masterKey) {
      final int newRight = (left ^ _f(right, k)) & _halfMask;
      left = right;
      right = newRight;
    }
    return <int>[left, right];
  }

  /// Inverse of [_encrypt]. Returns ``[left, right]``.
  static List<int> _decrypt(int left, int right) {
    left &= _halfMask;
    right &= _halfMask;
    for (int i = _masterKey.length - 1; i >= 0; i--) {
      final int k = _masterKey[i];
      // Undo (L,R) -> (R, L XOR F(R,k))
      final int prevRight = left;
      final int prevLeft = (right ^ _f(left, k)) & _halfMask;
      left = prevLeft;
      right = prevRight;
    }
    return <int>[left, right];
  }

  // --------------------------------------------------------------------
  // Base32 helpers
  //
  // Each 40-bit Feistel half encodes to exactly 8 base32 chars; the two
  // halves are concatenated (high half first) to form the 16-char code.
  // --------------------------------------------------------------------

  static const int _halfCodeLen = _halfBits ~/ 5; // = 8

  /// Encode a 40-bit unsigned int as exactly 8 base32 chars (big-endian).
  static String _halfToBase32(int n) {
    assert(n >= 0 && n <= _halfMask);
    final chars = List<String>.filled(_halfCodeLen, "");
    for (int i = _halfCodeLen - 1; i >= 0; i--) {
      chars[i] = _alphabet[n & 31];
      n >>= 5;
    }
    return chars.join();
  }

  /// Decode an 8-char base32 chunk into a 40-bit int, or ``null`` if any
  /// character is invalid. Case-insensitive.
  static int? _halfFromBase32(String code) {
    int n = 0;
    final upper = code.toUpperCase();
    for (int i = 0; i < upper.length; i++) {
      final int idx = _alphabet.indexOf(upper[i]);
      if (idx < 0) return null;
      n = (n << 5) | idx;
    }
    return n & _halfMask;
  }

  // --------------------------------------------------------------------
  // ID <-> integer mapping
  // --------------------------------------------------------------------

  static int _idToInt(String cardId) {
    if (cardId.startsWith(_prefixGgx)) {
      final suffix = cardId.substring(_prefixGgx.length);
      final idx = int.tryParse(suffix);
      if (idx == null || idx < 1 || idx > 30) {
        throw ArgumentError.value(cardId, "cardId", "GGX index out of range");
      }
      return _ggxOffset + idx;
    }
    if (cardId.startsWith(_prefixGg)) {
      final suffix = cardId.substring(_prefixGg.length);
      final idx = int.tryParse(suffix);
      if (idx == null || idx < 1 || idx > 60) {
        throw ArgumentError.value(cardId, "cardId", "GG index out of range");
      }
      return idx;
    }
    throw ArgumentError.value(cardId, "cardId", "unknown card-ID shape");
  }

  static String? _tryIntToId(int n) {
    if (n >= 1 && n <= 60) {
      return "$_prefixGg${n.toString().padLeft(2, '0')}";
    }
    if (n >= _ggxOffset + 1 && n <= _ggxOffset + 30) {
      final idx = n - _ggxOffset;
      return "$_prefixGgx${idx.toString().padLeft(2, '0')}";
    }
    return null;
  }
}
