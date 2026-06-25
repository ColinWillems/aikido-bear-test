import 'dart:ui';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:bear_adventure_app/app/modules/cards/controllers/card_collection.controller.dart';
import 'package:bear_adventure_app/app/modules/cards/views/card_collection_cards.view.dart';
import 'package:bear_adventure_app/app/modules/cards/views/card_collection_sets.view.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide Card, BackButton;
import 'package:get/get.dart';
import 'package:firebase_app_utils/firebase_app_utils.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:tinycolor2/tinycolor2.dart';

class CardCollectionView extends GetView<CardCollectionController> {
  const CardCollectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double minPadding = AppThemes.appLayout.padding.scaledMinPadding;
    final double padding = AppThemes.appLayout.padding.sm.left;

    final FlutterView window = View.of(context);
    final double bottomSafeArea =
        window.viewPadding.bottom / window.devicePixelRatio;

    return Obx(() {
      CardCollection cardCollection = controller.cardCollection.value;
      final String baseUrl = controller.imageBaseUrl;

      return Container(
          padding: EdgeInsets.zero,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: BackButton(onPressed: () {
                controller.navigation.viewCardCollections();
              }),
              title: Hero(
                  tag: cardCollection.id,
                  child: Container(
                      constraints:
                          const BoxConstraints.expand(height: 74, width: 130),
                      child: CachedNetworkImage(
                        cacheManager: FirebaseCacheManager(),
                        imageUrl: "$baseUrl${cardCollection.imagePath}",
                        fit: BoxFit.contain,
                      ))),
              actions: [
                Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: minPadding),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.loose(const Size.fromWidth(80)),
                    child: AnimatedToggleSwitch.dual(
                      current: controller.collectionView(),
                      first: CardCollectionViewType.sets,
                      second: CardCollectionViewType.cards,
                      onChanged: (type) => controller.collectionView(type),
                      style: ToggleStyle(
                        backgroundColor: BearColors.bearBrown.darken(10),
                        borderColor: Colors.transparent,
                        indicatorBorder: Border.all(
                            color: BearColors.creamWhite.withOpacity(0.7),
                            width: 2),
                        indicatorColor: controller.collectionView() ==
                                CardCollectionViewType.sets
                            ? BearColors.bearGreen
                            : BearColors.bearRed,
                      ),
                      fittingMode: FittingMode.none,
                      indicatorSize: const Size(45, 45),
                      height: 45,
                      spacing: -20,
                      iconBuilder: (value) {
                        return Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Text(
                              value == CardCollectionViewType.sets
                                  ? LocaleKeys.cards_sets.tr
                                  : LocaleKeys.home_cards.tr,
                              style: textTheme.labelSmall,
                            ));
                      },
                    ),
                  ),
                ),
              ],
            ),
            body: IntroductionScreen(
              key: controller.stepsKey,
              initialPage:
                  controller.collectionView() == CardCollectionViewType.sets
                      ? 0
                      : 1,
              showSkipButton: false,
              showBackButton: false,
              showDoneButton: false,
              showNextButton: false,
              showBottomPart: false,
              freeze: true,
              dotsFlex: 0,
              bodyPadding: EdgeInsets.only(bottom: 40 + bottomSafeArea, top: 8),
              dotsDecorator: DotsDecorator(
                spacing: const EdgeInsets.all(2),
                color: BearColors.creamWhite.withOpacity(0.25),
                activeColor: BearColors.creamWhite,
                size: const Size(14, 14),
                activeSize: const Size(14, 14),
                shape: BearFoot(
                    size: 14,
                    color: BearColors.creamWhite.withOpacity(0.25)),
                activeShape: const BearFoot(
                    size: 14, color: BearColors.creamWhite),
              ),
              globalBackgroundColor: Colors.transparent,
              rawPages: const [
                CardCollectionSetsView(),
                CardCollectionCardsView(),
              ],
            ),
          ));
    });
  }
}
