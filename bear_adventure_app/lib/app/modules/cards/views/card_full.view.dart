import 'dart:ui';

import 'package:bear_adventure_app/app/modules/cards/controllers/card.controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide Card, BackButton;
import 'package:bear_necessities/bear_necessities.dart';
import 'package:get/get.dart';
import 'package:firebase_app_utils/firebase_app_utils.dart';

class CardFullView extends GetWidget<CardController> {
  const CardFullView({super.key});

  @override
  Widget build(BuildContext context) {
    final double padding = AppThemes.appLayout.padding.sm.left;
    final FlutterView window = View.of(context);
    final double topSafeArea = window.viewPadding.top / window.devicePixelRatio;
    final double bottomSafeArea =
        window.viewPadding.bottom / window.devicePixelRatio;
    controller.showFullscreenInstructions();
    return Obx(() {
      final Card card = controller.card.value;
      final String baseUrl = controller.imageBaseUrl;
      CachedNetworkImage frontImage = CachedNetworkImage(
        cacheManager: FirebaseCacheManager(),
        // Fullscreen detail: gebruik de high-res unlock variant.
        imageUrl: "$baseUrl${card.unlockImagePath}",
        fit: BoxFit.contain,
      );
      CachedNetworkImage reverseImage = CachedNetworkImage(
        cacheManager: FirebaseCacheManager(),
        imageUrl: "$baseUrl${card.reverseImagePath}",
        fit: BoxFit.contain,
      );

      return Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: const BackButton(),
        ),
        body: Container(
          padding: EdgeInsets.only(
              top: topSafeArea + 5,
              right: padding,
              left: padding,
              bottom: bottomSafeArea + 5),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: FlipZoomCardView(
                    frontImage: frontImage,
                    reverseImage: reverseImage,
                    enableZoom: true,
                  ),
                ),
              ]),
        ),
      );
    });
  }
}
