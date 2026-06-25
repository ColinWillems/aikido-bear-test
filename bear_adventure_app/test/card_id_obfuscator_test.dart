// Verifies the deterministic 16-bit Feistel + base32 obfuscation used to
// keep card-unlock QR codes from leaking the underlying ID pattern.
//
// MUST stay in sync with ``scripts/card_id_obfuscator.py``. If the two
// implementations diverge, every QR code in the wild silently breaks.

import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter_test/flutter_test.dart';

/// Every plaintext card ID currently in the obfuscation domain.
List<String> _allCardIds() => <String>[
      for (var i = 1; i <= 60; i++) 'TODO_GG_${i.toString().padLeft(2, '0')}',
      for (var i = 1; i <= 30; i++) 'TODO_GGX_${i.toString().padLeft(2, '0')}',
    ];

void main() {
  group('CardIdObfuscator', () {
    test('every known card ID roundtrips', () {
      for (final cardId in _allCardIds()) {
        final code = CardIdObfuscator.encode(cardId);
        expect(code.length, 16, reason: 'code should be 16 chars for $cardId');
        final back = CardIdObfuscator.tryDecode(code);
        expect(back, cardId, reason: 'roundtrip failed for $cardId -> $code');
      }
    });

    test('every encoded code is unique', () {
      final codes = <String>{};
      for (final cardId in _allCardIds()) {
        final code = CardIdObfuscator.encode(cardId);
        expect(codes.add(code), isTrue,
            reason: 'duplicate code $code for $cardId');
      }
    });

    test('decoding is case-insensitive', () {
      for (final cardId in _allCardIds().take(5)) {
        final code = CardIdObfuscator.encode(cardId);
        expect(CardIdObfuscator.tryDecode(code.toLowerCase()), cardId);
        expect(CardIdObfuscator.tryDecode(code.toUpperCase()), cardId);
      }
    });

    test('tryDecode returns null for garbage', () {
      expect(CardIdObfuscator.tryDecode(''), isNull);
      expect(CardIdObfuscator.tryDecode('ABC'), isNull); // wrong length
      expect(CardIdObfuscator.tryDecode('ABCDEFGHIJKLMNO'), isNull); // 15
      expect(CardIdObfuscator.tryDecode('ABCDEFGHIJKLMNOPQ'), isNull); // 17
      expect(CardIdObfuscator.tryDecode('1OI01OI01OI01OI0'), isNull); // ambiguous
      expect(CardIdObfuscator.tryDecode('----------------'), isNull);
      // Plaintext card IDs must NOT decode.
      expect(CardIdObfuscator.tryDecode('TODO_GG_07'), isNull);
      // 16 valid chars but the decrypted value isn't a known card slot.
      expect(CardIdObfuscator.tryDecode('AAAAAAAAAAAAAAAA'), isNull);
    });

    test('encoding matches the canonical Python reference vectors', () {
      // These vectors are produced by ``python3 scripts/card_id_obfuscator.py``.
      // If any of them changes, the Dart and Python ports have diverged.
      const vectors = <String, String>{
        'TODO_GG_01': '35A6D2366RJUFJ5N',
        'TODO_GG_07': 'YBNW5ZAA9G3GHZ3Q',
        'TODO_GG_15': '8ZQ2WKY2RS7GJMXU',
        'TODO_GG_60': '89CRZSK635ZG4H76',
        'TODO_GGX_01': 'MZBCZT4UNWJX4NYF',
        'TODO_GGX_15': '7RKC3CSLY76WN75C',
        'TODO_GGX_30': 'M8K7HPSKSDTKXUPC',
      };
      vectors.forEach((cardId, expected) {
        expect(CardIdObfuscator.encode(cardId), expected,
            reason: 'Python<->Dart divergence for $cardId');
      });
    });

    test('looksLikeCode catches obvious non-codes', () {
      expect(CardIdObfuscator.looksLikeCode('YBNW5ZAA9G3GHZ3Q'), isTrue);
      expect(CardIdObfuscator.looksLikeCode('ybnw5zaa9g3ghz3q'), isTrue);
      expect(CardIdObfuscator.looksLikeCode('TODO_GG_07'), isFalse);
      expect(CardIdObfuscator.looksLikeCode('ABCDEFGHIJKLMNO'), isFalse); // 15
      expect(CardIdObfuscator.looksLikeCode('ABCDEFGHIJKLMNOPQ'), isFalse); // 17
      expect(CardIdObfuscator.looksLikeCode('1OI01OI01OI01OI0'), isFalse);
    });
  });
}
