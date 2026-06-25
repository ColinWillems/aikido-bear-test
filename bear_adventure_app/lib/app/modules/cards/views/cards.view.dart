import 'package:bear_adventure_app/app/modules/cards/controllers/cards.controller.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide GetNumUtils;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_app_utils/firebase_app_utils.dart';
import 'package:tinycolor2/tinycolor2.dart';
import 'package:lottie/lottie.dart';

class CardsView extends GetView<CardsController> {
  const CardsView({super.key, required this.color, this.contentWidth});

  final Color color;
  final double? contentWidth;

  @override
  Widget build(BuildContext context) {
    final double hPadding = AppThemes.appLayout.padding.sm.left;

    final String baseUrl = controller.imageBaseUrl;
    return Container(
      color: color,
      child: Obx(() => GridView.builder(
            physics: const ClampingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.02,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            padding: EdgeInsets.only(
                top: 18, left: hPadding, right: hPadding, bottom: 120),
            itemCount: controller.cardCollections.value.length,
            itemBuilder: (context, i) {
              CardCollection cardCollection =
                  controller.cardCollections.value[i];
              const Color color = Color(0xFF4B692D);
              Widget image = (cardCollection.id == "scan_a_card")
                  ? BearAssets.images.cards.scanACard
                      .image(package: BearApp.bearNecessities, fit: BoxFit.cover)
                    : CachedNetworkImage(
                      cacheManager: FirebaseCacheManager(),
                      imageUrl: "$baseUrl${cardCollection.tileImagePath}",
                      fit: BoxFit.cover,
                    );
              image = (!cardCollection.useAnim)
                  ? image
                  : NetworkCachedDotLottieLoader.fromNetworkWithCache(
                      cardCollection.animationPath,
                      cacheManager: FirebaseCacheManager(),
                      frameBuilder: (ctx, dotlottie) {
                        if (dotlottie != null) {
                          return Lottie.memory(
                            dotlottie.animations.values.single,
                            imageProviderFactory: (asset) {
                              return MemoryImage(
                                  dotlottie.images[asset.fileName]!);
                            },
                            alignment: Alignment.center,
                            fit: BoxFit.contain,
                            animate: true,
                            repeat: true,
                            errorBuilder: (context, error, stackTrace) {
                              return image;
                            },
                          );
                        } else {
                          return image;
                        }
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return image;
                      },
                    );
              Widget collectionDisplay = (!cardCollection.unlocked)
                  ? image
                  : Stack(
                      fit: StackFit.passthrough,
                      children: [
                        image,
                        Positioned(
                            bottom: 6,
                            right: 6,
                            width: 20,
                            height: 20,
                            child: BearAssets
                                .images.global.icons.taskCompletionIcon
                                .image(package: BearApp.bearNecessities)),
                      ],
                    );

              return PushableButton(
                color: color.brighten(12),
                borderRadius: 16,
                elevation: 4,
                onPressed: (() {
                  controller.navigation.viewCardCollection(cardCollection);
                }),
                child: Hero(
                    tag: cardCollection.id,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: const [
                                    0,
                                    1,
                                  ],
                                  colors: [
                                    color.brighten(12),
                                    color.shade(20),
                                  ],
                                )),
                            child: collectionDisplay))),
              ).animate(delay: (i * 200).ms).shake(duration: 500.ms, hz: 7);
            },
          )),
    );
  }
}
