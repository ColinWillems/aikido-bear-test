import 'dart:ui';

import 'package:bear_adventure_app/app/modules/cards/controllers/card_showdown.controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide Card, BackButton;
import 'package:bear_necessities/bear_necessities.dart';
import 'package:get/get.dart' hide GetNumUtils;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:firebase_app_utils/firebase_app_utils.dart';
import 'package:tinycolor2/tinycolor2.dart';
import 'package:decorated_text/decorated_text.dart';

class CardShowdownView extends GetWidget<CardShowdownController> {
  const CardShowdownView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double padding = AppThemes.appLayout.padding.sm.left;

    final FlutterView window = View.of(context);
    final double bottomSafeArea =
        window.viewPadding.bottom / window.devicePixelRatio;

    return Obx(
      () {
        final CardCollection cardCollection = controller.cardCollection();
        final Card card = controller.card();
        final List<Card> opponents = controller.opponents();
        final Card opponentCard = controller.opponentCard();
        final Card winningCard = controller.winningCard();
        final bool showResult = controller.showResult();

        final String baseUrl = controller.imageBaseUrl;

        Widget showdownTitle = Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Text(
              "showdown!",
              textAlign: TextAlign.center,
              style: textTheme.headlineMedium,
            ),
          ),
        );

        Widget showdownWinsText = Center(
          child: Text(
            "WINS",
            textAlign: TextAlign.center,
            style: textTheme.headlineLarge,
          ),
        );

        Widget showdownButton = AppStandardButton(
          text: (!showResult) ? "Enter The Showdown" : "Back To The Showdown",
          onPressed: (!opponentCard.unlocked)
              ? null
              : () {
                  (!showResult)
                      ? controller.showdown()
                      : controller.returnToShowdown();
                },
        ).animate().shake(
              delay: 600.ms,
              duration: 300.ms,
              hz: 7,
            );

        Widget cardDisplay = Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: CachedNetworkImage(
            cacheManager: FirebaseCacheManager(),
            imageUrl: "$baseUrl${card.showdownImagePath}",
            fit: BoxFit.contain,
          ),
        );
        Widget vsText = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: DecoratedText(
            "VS",
            borderColor: BearColors.bearBrown.darken(10),
            borderWidth: 3,
            fillGradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.1, 0.4, 0.7, 0.86],
              colors: [
                TinyColor.fromString("DC5D03").toColor(),
                TinyColor.fromString("F9E52B").toColor(),
                TinyColor.fromString("F1B664").toColor(),
                TinyColor.fromString("F8E499").toColor(),
              ],
            ),
            style: textTheme.headlineSmall!.decoratedText.s35,
          ),
        );
        Widget noCard = AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: BearColors.bearCream.withOpacity(0.25),
              border: Border.all(color: BearColors.bearActionButton, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: Text(
              "?",
              style: textTheme.labelLarge!.ursa.s92.yellowColor,
            ),
          ),
        );
        Widget opponentCardDisplay = Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: CachedNetworkImage(
            cacheManager: FirebaseCacheManager(),
            imageUrl: "$baseUrl${opponentCard.showdownImagePath}",
            fit: BoxFit.contain,
            errorWidget: (context, url, error) => noCard,
          ),
        );
        List<Widget> matchupContents = <Widget>[];
        Widget matchupContainer = Container(
          margin: showResult
              ? const EdgeInsets.only(bottom: 20)
              : const EdgeInsets.symmetric(vertical: 10),
          padding:
              showResult ? const EdgeInsets.all(40) : const EdgeInsets.all(10),
          width: double.infinity,
          height: showResult ? 400 : null,
          decoration: BoxDecoration(
            color: BearColors.bearBrown.darken(10),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Flex(
            direction: showResult ? Axis.vertical : Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: showResult ? MainAxisSize.min : MainAxisSize.max,
            children: matchupContents,
          ),
        );

        List<Widget> showdownContents = <Widget>[
          matchupContainer,
          showdownButton,
        ];
        Widget showdownContainer = Container(
          padding:
              showResult ? const EdgeInsets.all(25) : const EdgeInsets.all(15),
          width: double.infinity,
          decoration: BoxDecoration(
            color: TinyColor.fromString("DD5E04").toColor(),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: showdownContents,
          ),
        );
        Widget opponentsCarousel = (opponents.isNotEmpty)
            ? Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double maxCardHeight = constraints.maxHeight;
                      final double maxCardWidth =
                          maxCardHeight * cardCollection.cardRatio;
                      return ScrollSnapList(
                        initialIndex:
                            opponents.indexOf(opponentCard).toDouble(),
                        onItemFocus: (selectedIndex) =>
                            controller.selectOpponent(opponents[selectedIndex]),
                        itemSize: maxCardWidth,
                        dynamicItemOpacity: 0.5,
                        itemBuilder: (context, index) {
                          final Card opponent = opponents[index];
                          return CachedNetworkImage(
                            cacheManager: FirebaseCacheManager(),
                            imageUrl: "$baseUrl${opponent.frontImagePath}",
                            fit: BoxFit.contain,
                          );
                        },
                        itemCount: opponents.length,
                        dynamicItemSize: true,
                      );
                    },
                  ),
                ),
              )
            : Container(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    Center(
                      child: Text(
                        "To showdown with this card you have to unlock at least one ${controller.opponentSet().title} card first.",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Center(
                      child: AppStandardButton(
                        text: "Scan a card",
                        onPressed: () {
                          controller.navigation.captureCard();
                        },
                      ).animate().shake(
                            delay: 600.ms,
                            duration: 300.ms,
                            hz: 7,
                          ),
                    ),
                  ],
                ),
              );

        List<Widget> mainContent = <Widget>[showdownContainer];

        if (!showResult) {
          showdownContents.insert(0, showdownTitle);
          matchupContents.addAll([cardDisplay, vsText, opponentCardDisplay]);
          mainContent.add(opponentsCarousel);
        } else {
          final Widget winningCardDisplay =
              (winningCard.id == card.id) ? cardDisplay : opponentCardDisplay;
          matchupContents.addAll([winningCardDisplay, showdownWinsText]);
        }

        return Scaffold(
          backgroundColor: BearColors.bearGreen,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
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
          body: Container(
            padding: EdgeInsets.only(
                top: 8,
                right: padding,
                left: padding,
                bottom: 100 + bottomSafeArea),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: mainContent,
            ),
          ),
        );
      },
    );
  }
}
