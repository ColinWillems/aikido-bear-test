// Sanity check for the new card mock data. Verifies that every Card / CardSet
// / CardCollection imagePath corresponds to an actual file in the prepared
// `_firebase_upload` directory, so we can be confident the mockdata
// references match what will be uploaded to Firebase Storage.

import 'dart:io';

import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Resolve the upload directory relative to the package root.
  // `flutter test` runs with cwd = package root.
  const uploadRoot = 'delivery/_firebase_upload';

  String pathFor(String storagePath) => '$uploadRoot/$storagePath';

  test('every card image path exists in _firebase_upload', () {
    final rootDir = Directory(uploadRoot);
    if (!rootDir.existsSync()) {
      // The delivery folder is gitignored (it contains large PNGs that are
      // shipped via Firebase Storage instead of git). When it's not present
      // (e.g. on CI), this check has nothing to verify.
      print('Skipping: $uploadRoot not present (delivery is gitignored)');
      return;
    }

    final missing = <String>[];

    for (final collection in MockCardRepository.cardCollections) {
      // Collection-level image (banner / card title)
      _expect(collection.imagePath, missing, pathFor);

      for (final set in collection.sets) {
        // Set-level cover image (Category Card)
        _expect(set.imagePath, missing, pathFor);
        // Set-level header image (borderless variant of the Category Card,
        // shown at the top of the set page).
        _expect(set.headerImagePath, missing, pathFor);
        // Set-level icon (delivered as the "Icons" folder file)
        _expect(set.unlockImagePath, missing, pathFor);

        for (final card in set.cards) {
          _expect(card.frontImagePath, missing, pathFor);
          _expect(card.reverseImagePath, missing, pathFor);
        }
      }
    }

    expect(
      missing,
      isEmpty,
      reason:
          'The following storage paths referenced by mockdata have no matching '
          'file in delivery/_firebase_upload:\n  ${missing.join("\n  ")}',
    );
  });

  test('every collection has a unique id and index', () {
    final ids = <String>{};
    final indexes = <int>{};
    for (final collection in MockCardRepository.cardCollections) {
      expect(ids.add(collection.id), isTrue,
          reason: 'duplicate collection id: ${collection.id}');
      expect(indexes.add(collection.index), isTrue,
          reason: 'duplicate collection index: ${collection.index}');
    }
  });

  test('every card has a unique id within the whole app', () {
    final seen = <String, String>{}; // id -> "collection/set"
    for (final collection in MockCardRepository.cardCollections) {
      for (final set in collection.sets) {
        for (final card in set.cards) {
          final key = '${collection.id}/${set.id}';
          expect(seen.containsKey(card.id), isFalse,
              reason: 'duplicate card id ${card.id} in $key '
                  '(also in ${seen[card.id]})');
          seen[card.id] = key;
        }
      }
    }
  });

  test('every set has numCards == cards.length and unique indexes', () {
    for (final collection in MockCardRepository.cardCollections) {
      for (final set in collection.sets) {
        expect(set.cards.length, set.numCards,
            reason:
                '${collection.id}/${set.id}: numCards=${set.numCards} but '
                'cards.length=${set.cards.length}');
        final idx = <int>{};
        for (final card in set.cards) {
          expect(idx.add(card.index), isTrue,
              reason:
                  'duplicate index ${card.index} in ${collection.id}/${set.id}');
        }
      }
    }
  });
}

void _expect(
  String storagePath,
  List<String> missing,
  String Function(String) resolve,
) {
  if (storagePath.isEmpty) return;
  final f = File(resolve(storagePath));
  if (!f.existsSync()) missing.add(storagePath);
}
