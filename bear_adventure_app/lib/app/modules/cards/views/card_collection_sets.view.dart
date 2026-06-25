import 'package:bear_adventure_app/app/modules/cards/controllers/card_collection.controller.dart';
import 'package:bear_adventure_app/app/modules/cards/views/widgets/set_progress_bar.widget.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide Card, BackButton;
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart'
    hide NumDurationExtensions;
import 'package:firebase_app_utils/firebase_app_utils.dart';

class CardCollectionSetsView extends GetView<CardCollectionController> {
  const CardCollectionSetsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      CardCollection cardCollection = controller.cardCollection.value;
      List<CardSet> cardSets = controller.cardSets.value;
      final double padding = AppThemes.appLayout.padding.scaledMinPadding;

      const double bottomOffset = 108;
      const double spacing = 10;
      final String baseUrl = controller.imageBaseUrl;

      final double totalHeight =
          context.height - (padding * 2) - (bottomOffset * 2);
      final double setWidth = (context.width -
              spacing * (cardCollection.columns - 1) -
              (padding * 2)) /
          cardCollection.columns;
      // Bepaal de ratio: gebruik de cardRatio van de collectie zodat lange
      // (xtreme) kaartjes niet gecropped worden. Bij fullHeight nemen we de
      // volledige beschikbare hoogte. Fallback naar 0.7 voor standaard sets.
      final double cardRatio = cardCollection.cardRatio.toDouble();
      final double ratio = !cardCollection.fullHeight
          ? (cardRatio > 0 ? cardRatio : 0.7)
          : setWidth / totalHeight;
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cardCollection.columns,
          childAspectRatio: ratio,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
        ),
        padding: EdgeInsets.only(
            top: padding,
            right: padding,
            left: padding,
            bottom: padding + bottomOffset),
        itemCount: cardSets.length,
        itemBuilder: (context, i) {
          CardSet cardSet = cardSets[i];
          CachedNetworkImage image = CachedNetworkImage(
            cacheManager: FirebaseCacheManager(),
            imageUrl: "$baseUrl${cardSet.imagePath}",
            fit: BoxFit.contain,
          );
          Widget setDisplay = Stack(
            fit: StackFit.expand,
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: image,
              ),
              Positioned(
                  bottom: cardCollection.fullHeight ? 20 : 5,
                  right: 10,
                  left: 10,
                  height: 24,
                  child: SetProgressBar(
                    current: cardSet.cards.length,
                    total: cardSet.numCards,
                  )),
            ],
          );

          return MaterialButton(
            padding: const EdgeInsets.all(0),
            onPressed: (() {
              controller.navigation.viewCardSet(cardSet);
            }),
            child: Hero(tag: cardSet.id, child: setDisplay),
          ).animate(delay: (0.2 + (i * 0.1)).seconds).fade().shimmer();
        },
      );
    });
  }
}
