import 'dart:ui';

import 'package:bear_adventure_app/app/modules/cards/controllers/card.controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide Card, BackButton;
import 'package:bear_necessities/bear_necessities.dart';
import 'package:get/get.dart' hide GetNumUtils;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_app_utils/firebase_app_utils.dart';
import 'package:tinycolor2/tinycolor2.dart';
import 'package:decorated_text/decorated_text.dart';

class CardView extends GetWidget<CardController> {
  const CardView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double padding = AppThemes.appLayout.padding.sm.left;

    final FlutterView window = View.of(context);
    final double bottomSafeArea =
        window.viewPadding.bottom / window.devicePixelRatio;

    return Obx(
      () {
        final CardCollection cardCollection = controller.cardCollection.value;
        final CardSet cardSet = controller.cardSet.value;
        final Card card = controller.card.value;
        final String baseUrl = controller.imageBaseUrl;
        CachedNetworkImage frontImage = CachedNetworkImage(
          cacheManager: FirebaseCacheManager(),
          // Detail page: gebruik de high-res unlock variant. De optimised
          // ({card_id}_front.png) wordt als thumbnail in de overzichten gebruikt.
          imageUrl: "$baseUrl${card.unlockImagePath}",
          fit: BoxFit.contain,
        );
        CachedNetworkImage reverseImage = CachedNetworkImage(
          cacheManager: FirebaseCacheManager(),
          imageUrl: "$baseUrl${card.reverseImagePath}",
          fit: BoxFit.contain,
        );
        GlobalKey<FlipZoomCardViewState> flipCardKey =
            GlobalKey<FlipZoomCardViewState>();

        List<Widget> cardActions = <Widget>[
          Container(
            constraints: const BoxConstraints(maxWidth: 54, maxHeight: 60),
            padding: const EdgeInsets.only(right: 10),
            child: RoundPushableButton(
              onPressed: () {
                flipCardKey.currentState?.flipCard();
              },
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 7, right: 9, bottom: 7, top: 9),
                child: BearAssets.images.global.icons.flipCardIcon
                    .image(package: BearApp.bearNecessities),
              ),
            ),
          ),
          Container(
            constraints: const BoxConstraints(maxWidth: 54, maxHeight: 60),
            padding: const EdgeInsets.only(left: 10),
            child: RoundPushableButton(
              onPressed: () {
                controller.navigation.viewCardFullscreen();
              },
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 7, right: 9, bottom: 7, top: 9),
                child: BearAssets.images.global.icons.fullscreenIcon
                    .image(package: BearApp.bearNecessities),
              ),
            ),
          ),
        ];
        Widget showdownButton = Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: RoundedRectanglePushableButton(
              color: TinyColor.fromString("DD5E04").toColor(),
              onPressed: () {
                controller.navigation.viewCardShowdown(card);
              },
              child: Center(
                child: DecoratedText(
                  "showdown!",
                  borderColor: BearColors.bearBrown.darken(10),
                  borderWidth: 2,
                  fillGradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.1, 0.40, 0.7, 0.86],
                    colors: [
                      TinyColor.fromString("DC5D03").toColor(),
                      TinyColor.fromString("F9E52B").toColor(),
                      TinyColor.fromString("F1B664").toColor(),
                      TinyColor.fromString("F8E499").toColor(),
                    ],
                  ),
                  style: textTheme.labelMedium!.decoratedButtonText,
                ),
              ),
            ),
          ),
        );
        if (cardCollection.hasShowdown) {
          cardActions.insert(1, showdownButton);
        }

        return Scaffold(
          backgroundColor: BearColors.bearGreen,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: const BackButton(),
            title: Container(
              constraints: const BoxConstraints.expand(height: 74, width: 130),
              child: MaterialButton(
                padding: const EdgeInsets.all(0),
                onPressed: (() {
                  controller.navigation.viewCardCollection(cardCollection);
                }),
                child: CachedNetworkImage(
                  cacheManager: FirebaseCacheManager(),
                  imageUrl: "$baseUrl${cardCollection.imagePath}",
                  fit: BoxFit.contain,
                ),
              ),
            ),
            actions: [
              Container(
                  constraints: const BoxConstraints(maxWidth: 52),
                  padding: const EdgeInsets.only(right: 10),
                  child: MaterialButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: (() {
                      controller.navigation.viewCardSet(cardSet);
                    }),
                    child: CachedNetworkImage(
                      cacheManager: FirebaseCacheManager(),
                      imageUrl: "$baseUrl${cardSet.imagePath}",
                      width: 52,
                      fit: BoxFit.cover,
                    ),
                  )),
            ],
          ),
          body: Container(
            width: double.infinity,
            padding: EdgeInsets.only(
                top: 8,
                right: padding,
                left: padding,
                bottom: 100 + bottomSafeArea),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(card.title,
                    textAlign: TextAlign.center,
                    style: textTheme.headlineMedium),
                const SizedBox(height: 20),
                Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: GestureDetector(
                        onDoubleTap: () {
                          controller.navigation.viewCardFullscreen();
                        },
                        child: FlipZoomCardView(
                          key: flipCardKey,
                          frontImage: frontImage,
                          reverseImage: reverseImage,
                        ).animate(delay: 0.2.seconds).shimmer())),
                Container(
                  padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: cardActions.animate(interval: 200.ms).shake(
                          delay: 600.ms,
                          duration: 300.ms,
                          hz: 7,
                        ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
