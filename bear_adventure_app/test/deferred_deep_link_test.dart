// Verifies that DeferredDeepLinkService accepts only the obfuscated payloads
// the landing page writes (Play Install Referrer on Android, pasteboard on
// iOS) and rejects anything else. Regression test for the breakage that
// shipped when CardIdObfuscator landed and the validator was still comparing
// against legacy plaintext IDs.

import 'package:bear_adventure_app/app/services/deferred_deep_link.service.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final allCards = <Card>[
    for (final collection in MockCardRepository.cardCollections)
      for (final set in collection.sets) ...set.cards,
  ];

  test('decodes every obfuscated card code shipped from the landing page', () {
    for (final card in allCards) {
      final encoded = CardIdObfuscator.encode(card.id);
      final decoded = DeferredDeepLinkService.decodeDeferredPayload(encoded);
      expect(decoded, card.id,
          reason: 'expected $encoded to decode to ${card.id}');
    }
  });

  test('decodes lower-case codes (URL normalisation tolerance)', () {
    final encoded = CardIdObfuscator.encode('TODO_GG_07');
    expect(
      DeferredDeepLinkService.decodeDeferredPayload(encoded.toLowerCase()),
      'TODO_GG_07',
    );
  });

  test('decodes URL-encoded payloads (defensive against Play Store)', () {
    final encoded = CardIdObfuscator.encode('TODO_GG_07');
    // Force a %-encoded form by encoding then asking the service to decode.
    final percentEncoded = Uri.encodeComponent('  $encoded  '); // whitespace
    expect(
      DeferredDeepLinkService.decodeDeferredPayload(percentEncoded),
      'TODO_GG_07',
    );
  });

  group('rejects invalid payloads', () {
    final invalidPayloads = <String?>[
      null,
      '',
      '   ',
      'TODO_GG_07', // legacy plaintext id — must NOT decode
      'TODO_GGX_15',
      'ABC', // too short
      'AAAAAAAAAAAAAAAA', // right length, valid alphabet, but not a card
      'YBNW5ZAA9G3GHZ3', // 15 chars
      'YBNW5ZAA9G3GHZ3QX', // 17 chars
      '0000000000000000', // contains chars outside the base32 alphabet (0)
      'https://app.bearfruitsnacks.com/?path=YBNW5ZAA9G3GHZ3Q', // whole URL
    ];

    for (final payload in invalidPayloads) {
      test('payload: ${payload ?? '<null>'}', () {
        expect(
          DeferredDeepLinkService.decodeDeferredPayload(payload),
          isNull,
          reason: 'expected $payload to be rejected',
        );
      });
    }
  });
}
