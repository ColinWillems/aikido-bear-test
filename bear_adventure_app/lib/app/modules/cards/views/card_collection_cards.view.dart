import 'package:bear_adventure_app/app/modules/cards/controllers/card_collection.controller.dart';
import 'package:bear_adventure_app/app/modules/cards/views/widgets/locked_card.widget.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide Card, BackButton;
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart'
    hide NumDurationExtensions;
import 'package:firebase_app_utils/firebase_app_utils.dart';

class CardCollectionCardsView extends GetView<CardCollectionController> {
  const CardCollectionCardsView({super.key});

  @override
  Widget build(BuildContext context) {
    final double padding = AppThemes.appLayout.padding.scaledMinPadding;

    return Obx(() {
      CardCollection cardCollection = controller.cardCollection.value;
      List<Card> cards = controller.cards.value;

      final String baseUrl = controller.imageBaseUrl;

      // Gebruik de laagste ratio over alle sets (= langste kaartje) zodat geen
      // enkel kaartje gecropped wordt. Fallback naar de collectie-ratio.
      final double gridRatio = cardCollection.sets.isNotEmpty
          ? cardCollection.sets
              .map((s) => s.effectiveCardRatio)
              .reduce((a, b) => a < b ? a : b)
              .toDouble()
          : cardCollection.cardRatio.toDouble();

      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: gridRatio,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        padding: EdgeInsets.only(
            top: padding, right: padding, left: padding, bottom: 120),
        itemCount: cards.length,
        itemBuilder: (context, i) {
          Card card = cards[i];
          final CardSet? cardSet = card.set;
          // Tijdens snelle navigatie tussen card collections kan een card
          // kortstondig nog geen set gekoppeld hebben. Skip die rij i.p.v.
          // crashen op `card.set!`.
          if (cardSet == null) {
            return const SizedBox.shrink();
          }
          LockedCard lockedCard = LockedCard(card: card, baseUrl: baseUrl);
          CachedNetworkImage cardFront = CachedNetworkImage(
            cacheManager: FirebaseCacheManager(),
            imageUrl: "$baseUrl${card.frontImagePath}",
            fit: BoxFit.contain,
          );
          Widget image =
              (card.frontImagePath.isNotEmpty) ? cardFront : lockedCard;

          return MaterialButton(
            padding: const EdgeInsets.all(0),
            onPressed: (() {
              controller.navigation.viewCard(card);
            }),
            child: Hero(tag: card.id, child: image),
          ).animate().shimmer(delay: (0.2 + (i % 12 * 0.1)).seconds);
        },
      );
    });
  }
}
