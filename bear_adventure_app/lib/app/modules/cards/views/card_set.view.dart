import 'package:bear_adventure_app/app/modules/cards/controllers/card_set.controller.dart';
import 'package:bear_adventure_app/app/modules/cards/views/widgets/locked_card.widget.dart';
import 'package:bear_adventure_app/app/modules/cards/views/widgets/set_progress_bar.widget.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide Card, BackButton;
import 'package:get/get.dart' hide GetNumUtils;
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_app_utils/firebase_app_utils.dart';

class CardSetView extends GetView<CardSetController> {
  const CardSetView({super.key});

  /// Aspect ratio (width / height) of the delivered set header artwork
  /// (~3090 × 4504 ≈ 0.686). The header is sized so the image takes the full
  /// screen width while keeping this native aspect ratio (no cropping, no
  /// stretching, no coloured bars on the sides).
  static const double _headerImageAspectRatio = 3092 / 4509;

  @override
  Widget build(BuildContext context) {
    final double padding = AppThemes.appLayout.padding.sm.left;

    return Obx(() {
      CardCollection cardCollection = controller.cardCollection();
      CardSet cardSet = controller.cardSet();
      List<Card> cards = controller.cards();
      String baseUrl = controller.imageBaseUrl;

      return Container(
        padding: EdgeInsets.zero,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            scrolledUnderElevation: 0,
            leading: const BackButton(),
            title: Container(
                constraints:
                    const BoxConstraints.expand(height: 74, width: 130),
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
                )),
          ),
          body: CustomScrollView(
            key: UniqueKey(),
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(37),
                    bottomRight: Radius.circular(37),
                  ),
                  child: ColoredBox(
                    color: cardSet.color,
                    child: AspectRatio(
                      aspectRatio: _headerImageAspectRatio,
                      child: Stack(
                          fit: StackFit.expand,
                          alignment: Alignment.center,
                          children: [
                            IntroductionScreen(
                              key: controller.stepsKey,
                              initialPage: controller.currentSetIndex(),
                              onChange: controller.onSetChange,
                              showSkipButton: false,
                              showBackButton: false,
                              showDoneButton: false,
                              showNextButton: false,
                              dotsFlex: 0,
                              controlsPosition:
                                  const Position(bottom: 10, left: 0, right: 0),
                              dotsDecorator: DotsDecorator(
                                spacing: const EdgeInsets.all(2),
                                color: BearColors.creamWhite.withOpacity(0.25),
                                activeColor: BearColors.creamWhite,
                                size: const Size(14, 14),
                                activeSize: const Size(14, 14),
                                shape: BearFoot(
                                    size: 14,
                                    color: BearColors.creamWhite
                                        .withOpacity(0.25)),
                                activeShape: const BearFoot(
                                    size: 14, color: BearColors.creamWhite),
                              ),
                              globalBackgroundColor: Colors.transparent,
                              rawPages:
                                  cardCollection.sets.map<Widget>((currentSet) {
                                return CachedNetworkImage(
                                  cacheManager: FirebaseCacheManager(),
                                  imageUrl:
                                      "$baseUrl${currentSet.headerImagePath}",
                                  fit: BoxFit.cover,
                                );
                              }).toList(),
                            ),
                            Positioned(
                              bottom: 60,
                              width: 320,
                              height: 48,
                              child: SetProgressBar(
                                current: cardSet.cards.length,
                                total: cardSet.numCards,
                                color: Colors.white,
                                backgroundColor: Colors.white.withOpacity(0.5),
                              ),
                            ),
                            Positioned(
                              height: 50,
                              left: 0,
                              child: (controller.isFirstSet())
                                  ? Container()
                                  : MaterialButton(
                                      padding: const EdgeInsets.all(8),
                                      onPressed: controller.previousSet,
                                      child: BearAssets
                                          .images.global.icons.backIcon
                                          .image(
                                        package: BearApp.bearNecessities,
                                      ),
                                    ).animate(delay: 200.ms).fade().shake(
                                        duration: 300.ms,
                                        hz: 7,
                                      ),
                            ),
                            Positioned(
                              height: 50,
                              right: 0,
                              child: (controller.isLastSet())
                                  ? Container()
                                  : MaterialButton(
                                      padding: const EdgeInsets.all(8),
                                      onPressed: controller.nextSet,
                                      child: Transform.scale(
                                        scaleX: -1,
                                        child: BearAssets
                                            .images.global.icons.backIcon
                                            .image(
                                          package: BearApp.bearNecessities,
                                        ),
                                      ),
                                    ).animate(delay: 200.ms).fade().shake(
                                        duration: 300.ms,
                                        hz: 7,
                                      ),
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.only(
                    top: 32, right: padding, left: padding, bottom: 120),
                sliver: SliverGrid.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: cardSet.effectiveCardRatio.toDouble(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: cards.length,
                  itemBuilder: (context, i) {
                    Card card = cards[i];
                    final CardSet? cardCardSet = card.set;
                    // Defensief tegen null-set tijdens snelle navigatie.
                    if (cardCardSet == null) {
                      return const SizedBox.shrink();
                    }
                    LockedCard lockedCard = LockedCard(card: card, baseUrl: baseUrl);
                    CachedNetworkImage cardFront = CachedNetworkImage(
                      cacheManager: FirebaseCacheManager(),
                      imageUrl: "$baseUrl${card.frontImagePath}",
                      fit: BoxFit.contain,
                    );
                    Widget image = (card.frontImagePath.isNotEmpty)
                        ? cardFront
                        : lockedCard;

                    return MaterialButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: (() {
                        controller.navigation.viewCard(card);
                      }),
                      child: Hero(tag: card.id, child: image),
                    ).animate().shimmer(delay: (0.2 + (i % 12 * 0.1)).seconds);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
