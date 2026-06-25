import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:bear_adventure_app/app/modules/cards/controllers/navigation/cards_navigation.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:get/get.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class CardCaptureController extends GetxController {
  CardCaptureController({
    required this.service,
    required this.urlService,
    required this.permissionsService,
  });
  final CardsService service;
  final UrlService urlService;
  final PermissionsService permissionsService;

  late final CardsNavigation navigation;

  final Rx<FlashMode> torchMode = FlashMode.none.obs;

  final RxBool isRealDevice = true.obs;

  final RxBool isUnlockingCard = false.obs;

  late final TextEditingController textEditingController;

  @override
  Future<void> onInit() async {
    navigation = CardsNavigation(
      service: service,
      urlService: urlService,
      permissionsService: permissionsService,
    );
    isRealDevice(await isPhysicalDevice);
    textEditingController = TextEditingController(text: "");

    Dialogs.showSnackbar(
        message: LocaleKeys.cards_info_card_capture_instructions.tr);
    super.onInit();
  }

  Future<bool> get isPhysicalDevice async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (GetPlatform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.isPhysicalDevice;
    } else if (GetPlatform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.isPhysicalDevice;
    }

    return true;
  }

  void closeDialog({bool delay = false}) {
    if (!delay) {
      Get.close();
    } else {
      Timer(3.seconds, () {
        isUnlockingCard(true);
      });
    }
  }

  void unlockCard(Card card) {
    closeDialog(delay: true);
    navigation.unlockCard(card);
  }

  Future<void> captureCardFromQRCode(Barcode barcode) async {
    String errorMessage = "";
    Card? card;
    try {
      final url = _getUrlFromBarcode(barcode);
      card = await _getCardFromUrl(url);
    } on ArgumentError catch (error) {
      errorMessage = error.message;
    } on FormatException catch (error) {
      errorMessage = error.message;
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      if (errorMessage.isNotEmpty) {
        OkCancelResult result = await Dialogs.showErrorDialog(errorMessage);
        closeDialog();
      } else if (card != null) {
        unlockCard(card);
      } else {
        // Geen exception en geen card: kan voorkomen als de view tijdens
        // het scannen al gesloten werd. Stil falen i.p.v. crashen op `card!`.
        closeDialog();
      }
    }
  }

  Future<void> captureCardFromUrl(String url) async {
    String errorMessage = "";
    Card? card;
    try {
      card = await _getCardFromUrl(url);
    } on ArgumentError catch (error) {
      errorMessage = error.message;
    } on FormatException catch (error) {
      errorMessage = error.message;
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      if (errorMessage.isNotEmpty) {
        OkCancelResult result = await Dialogs.showErrorDialog(errorMessage);
        closeDialog();
      } else if (card != null) {
        unlockCard(card);
      } else {
        closeDialog();
      }
    }
  }

  String _getUrlFromBarcode(Barcode barcode) {
    String errorMessage = "";
    if (barcode.type != BarcodeType.url) {
      errorMessage = "QR Code is not a URL";
      throw ArgumentError(errorMessage, "barcode");
    }
    final BarcodeUrl barcodeUrl = barcode.value as BarcodeUrl;
    final String? url = barcodeUrl.url;
    if (url == null) {
      errorMessage = "QR Code does not contain a valid URL";
      throw ArgumentError(errorMessage, "barcode");
    }
    return url;
  }

  Future<Card?> _getCardFromUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      throw ArgumentError("Unable to parse URL", "url");
    }
    final cardId = BearApp.tryExtractCardId(uri);
    if (cardId == null) {
      throw ArgumentError(
        "This card with domain: ${uri.host} is not supported",
        "url",
      );
    }
    return await service.unlockCard(cardId);
  }

  Future<void> setTorchMode(FlashMode mode) async {}

  Future<void> showScannerError(String errorMessage) async {
    OkCancelResult result = await Dialogs.showErrorDialog(errorMessage);
    closeDialog();
  }
}
