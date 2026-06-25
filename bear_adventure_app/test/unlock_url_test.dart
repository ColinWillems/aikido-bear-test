// Verifies that the deep-link extractor only accepts obfuscated QR codes
// produced by [CardIdObfuscator] and rejects the legacy plaintext shapes
// (which never made it into the wild).
//
// Mirrors the logic in CardsService.unlockCard / CardCaptureController.

import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final allCards = <Card>[
    for (final collection in MockCardRepository.cardCollections)
      for (final set in collection.sets) ...set.cards,
  ];

  test('every obfuscated unlock URL maps to a known card', () {
    // Reference vectors from card_id_obfuscator.
    const testUrls = <String>[
      'https://app.bearfruitsnacks.com/?path=YBNW5ZAA9G3GHZ3Q', // TODO_GG_07
      'https://app.bearfruitsnacks.com/?path=8ZQ2WKY2RS7GJMXU', // TODO_GG_15
      'https://app.bearfruitsnacks.com/?path=7RKC3CSLY76WN75C', // TODO_GGX_15
      // Lower-case URL normalisation must still decode.
      'https://app.bearfruitsnacks.com/?path=ybnw5zaa9g3ghz3q',
      // Legacy hosts must keep working as long as the payload is obfuscated.
      'https://client.bearadventure.app/?path=YBNW5ZAA9G3GHZ3Q',
      // Path-style variant + dash prefix still supported.
      'https://client.bearadventure.app/YBNW5ZAA9G3GHZ3Q',
      'https://client.bearadventure.app/card-YBNW5ZAA9G3GHZ3Q',
    ];

    for (final url in testUrls) {
      final uri = Uri.parse(url);
      final cardId = BearApp.tryExtractCardId(uri);
      expect(cardId, isNotNull,
          reason: 'tryExtractCardId returned null for $url');
      final found = allCards.where((c) => c.id == cardId).toList();
      expect(found, isNotEmpty,
          reason: 'No card found for cardId="$cardId" (extracted from $url)');
    }
  });

  test('legacy plaintext card IDs are rejected', () {
    // None of these are obfuscated codes — they must NOT decode.
    const legacyUrls = <String>[
      'https://app.bearfruitsnacks.com/?path=TODO_GG_07',
      'https://app.bearfruitsnacks.com/?path=TODO_GGX_15',
      'https://client.bearadventure.app/TODO_GG_39',
      'https://client.bearadventure.app/card-TODO_GG_39',
      'https://app.bearfruitsnacks.com/?path=ABC', // too short
      'https://app.bearfruitsnacks.com/?path=', // empty
    ];

    for (final url in legacyUrls) {
      final uri = Uri.parse(url);
      final cardId = BearApp.tryExtractCardId(uri);
      expect(cardId, isNull,
          reason: 'expected $url to be rejected, got cardId=$cardId');
    }
  });

  test('buildCardUnlockUrl roundtrips through tryExtractCardId', () {
    for (final card in allCards) {
      final url = BearApp.buildCardUnlockUrl(card.id);
      expect(url, contains('?path='),
          reason: 'expected ?path= query for $url');
      // The encoded code must NOT leak the plaintext id.
      expect(url, isNot(contains(card.id)),
          reason: 'plaintext id leaked into $url');

      final back = BearApp.tryExtractCardId(Uri.parse(url));
      expect(back, card.id,
          reason: 'roundtrip failed for ${card.id} via $url');
    }
  });

  test('debug custom-scheme links work with obfuscated codes', () {
    final url = BearApp.buildCardUnlockUrl('TODO_GG_07');
    final code = Uri.parse(url).queryParameters['path']!;
    final back = BearApp.tryExtractCardId(
      Uri.parse('bearadventure://card?path=$code'),
    );
    expect(back, 'TODO_GG_07');
  });
}
