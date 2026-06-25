import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:bear_adventure_app/app/routes/app_pages.dart';
import 'package:bear_adventure_app/app/utils/common.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class CardsNavigation {
  const CardsNavigation(
      {required this.service,
      required this.urlService,
      required this.permissionsService});
  final CardsService service;
  final UrlService urlService;
  final PermissionsService permissionsService;

  static Route? captureRoute;

  void viewCardCollections() {
    Common.navigateTo(Routes.home, urlService, Routes.cards,
        parameters: {"tab": "2"});
  }

  void viewCardCollection(CardCollection cardCollection) {
    if (cardCollection.id == Cards.scanACardCategory) {
      captureCard();
    } else if (cardCollection.isEmpty) {
      Dialogs.showDialog(
          title: "Coming Soon!",
          message: "The ${cardCollection.title} collection is coming soon.",
          path:
              "${Routes.cards}/${_convertIdToUrlPathSegment(cardCollection.id)}/coming-soon");
    } else {
      service.selectCollection(cardCollection);

      Common.navigateTo(Routes.collection, urlService,
          "${Routes.cards}/${_convertIdToUrlPathSegment(cardCollection.id)}");
    }
  }

  void viewCardSet(CardSet cardSet) {
    service.selectSet(cardSet);

    Common.navigateTo(Routes.set, urlService,
        "${Routes.cards}/${_convertIdToUrlPathSegment(cardSet.collection?.id)}/${_convertIdToUrlPathSegment(cardSet.id)}");
  }

  void viewCardShowdown(Card card) {
    service.selectCard(card);

    final analytics = FirebaseAnalytics.instance;
    analytics.logEvent(name: "view_card_showdown", parameters: {
      "id": card.id,
      "title": card.title,
      "set": card.set?.title ?? "",
      "collection": card.set?.collection?.title ?? ""
    });
    analytics.logViewItem(items: [
      AnalyticsEventItem(
        itemName: card.title,
        itemId: card.id,
        itemVariant: card.set?.title,
        itemCategory: card.set?.collection?.title,
        itemListName: "Showdown",
      )
    ]);

    Common.navigateTo(Routes.showdown, urlService,
        "${Routes.cards}/${_convertIdToUrlPathSegment(card.set?.collection?.id)}/${_convertIdToUrlPathSegment(card.set?.id)}/${_convertTitleToUrlPathSegment(card.title)}-${card.id}${Routes.showdown}");
  }

  void viewCard(Card card, [bool preventDuplicates = true]) async {
    if (card.unlocked) {
      final analytics = FirebaseAnalytics.instance;
      analytics.logEvent(name: "view_card", parameters: {
        "id": card.id,
        "title": card.title,
        "set": card.set?.title ?? "",
        "collection": card.set?.collection?.title ?? ""
      });
      analytics.logViewItem(items: [
        AnalyticsEventItem(
          itemName: card.title,
          itemId: card.id,
          itemVariant: card.set?.title,
          itemCategory: card.set?.collection?.title,
        )
      ]);

      service.selectCard(card);

      Common.navigateTo(Routes.card, urlService,
          "${Routes.cards}/${_convertIdToUrlPathSegment(card.set?.collection?.id)}/${_convertIdToUrlPathSegment(card.set?.id)}/${_convertTitleToUrlPathSegment(card.title)}-${card.id}",
          preventDuplicates: preventDuplicates);
    } else {
      OkCancelResult? result = await Dialogs.showActionDialog<OkCancelResult>(
        title: "Card is locked",
        message: "Scan new cards to unlock them.",
        actions: [
          AlertDialogAction(
            label: MaterialLocalizations.of(Get.context!).cancelButtonLabel,
            key: OkCancelResult.cancel,
            isDefaultAction: false,
          ),
          const AlertDialogAction(
            label: "Scan a card",
            key: OkCancelResult.ok,
            isDefaultAction: true,
          ),
        ],
        path:
            "${Routes.cards}/${_convertIdToUrlPathSegment(card.set?.collection?.id)}/${_convertIdToUrlPathSegment(card.set?.id)}/${_convertTitleToUrlPathSegment(card.title)}-${card.id}/card-locked",
      );
      if (result != null) {
        switch (result) {
          case OkCancelResult.ok:
            captureCard();
            break;
          case OkCancelResult.cancel:
          default:
            break;
        }
      }
    }
  }

  void viewCardFullscreen() {
    final Card card = service.selectedCard();

    Common.showFullScreenDialog(Routes.full, urlService,
        "${Routes.cards}/${_convertIdToUrlPathSegment(card.set?.collection?.id)}/${_convertIdToUrlPathSegment(card.set?.id)}/${_convertTitleToUrlPathSegment(card.title)}-${card.id}${Routes.full}");
  }

  void viewPermissions() {
    Common.showFullScreenDialog(Routes.permissions, urlService,
        "${Routes.settings}${Routes.permissions}");
  }

  Future<void> captureCard() async {
    if (permissionsService.cameraPermission().isGranted) {
      Common.showFullScreenDialog(Routes.captureCard, urlService,
          "${Routes.cards}${Routes.captureCard}", true);
    } else {
      viewPermissions();
    }
  }

  void viewCardShowdownCountdown() {
    Common.showFullScreenDialog(Routes.showdownCountdown, urlService,
        "${Routes.cards}${Routes.showdownCountdown}", true);
  }

  void unlockCard(Card card) {
    service.selectCard(card);
    Common.showFullScreenDialog(Routes.unlockCard, urlService,
        "${Routes.cards}${Routes.unlockCard}", true);
  }

  void viewGreatJobDialog() {
    Common.showFullScreenDialog(Routes.greatJob, urlService,
        "${Routes.trophyCabinet}${Routes.greatJob}", true);
  }

  void viewSetCompletedDialog() {
    Common.showFullScreenDialog(
      Routes.setCompleted,
      urlService,
      "${Routes.cards}${Routes.setCompleted}",
      true,
    );
  }

  void viewCollectionCompletedDialog() {
    Common.showFullScreenDialog(
      Routes.collectionCompleted,
      urlService,
      "${Routes.cards}${Routes.collectionCompleted}",
      true,
    );
  }

  String _convertIdToUrlPathSegment(String? id) {
    final String pathSegment =
        (id ?? "unknown").replaceAll("_", "-").toLowerCase();
    return pathSegment;
  }

  String _convertTitleToUrlPathSegment(String title) {
    final String pathSegment = title.replaceAll(" ", "-").toLowerCase();
    return pathSegment;
  }
}
