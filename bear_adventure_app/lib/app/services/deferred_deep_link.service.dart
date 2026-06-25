import 'dart:io';

import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:play_install_referrer/play_install_referrer.dart';

class DeferredDeepLinkService extends GetxService {
  /// Decoded card ID extracted from the deferred deeplink payload (or null
  /// if no valid deferred deeplink was found). The raw payload from the
  /// landing page is a [CardIdObfuscator]-encoded 16-char base32 code
  /// (e.g. `YBNW5ZAA9G3GHZ3Q`); we store the plaintext id (e.g. `TODO_GG_07`)
  /// so the rest of the app deals in the same currency as the QR scanner.
  final Rxn<String> deferredPath = Rxn<String>();
  final Rxn<String> lastClipboardContent = Rxn<String>();

  Future<DeferredDeepLinkService> init() async {
    return this;
  }

  /// Retrieves the deferred deeplink path from the Play Install Referrer (Android).
  ///
  /// The landing page (`bear_adventure_landing_page/app/page.tsx`)
  /// forwards the obfuscated card code as `referrer=<code>` to Play Store.
  /// Play returns it on first launch; we decode it via [CardIdObfuscator].
  Future<String?> getAndroidDeferredDeepLink() async {
    if (!Platform.isAndroid) return null;

    try {
      final referrerDetails = await PlayInstallReferrer.installReferrer;
      final String? referrer = referrerDetails.installReferrer;

      final String? cardId = _decodeDeferredPayload(referrer);
      if (cardId != null) {
        deferredPath(cardId);
        return cardId;
      }
    } catch (e) {
      // Silently fail - referrer not available
    }
    return null;
  }

  /// Retrieves the deferred deeplink path from the Pasteboard (iOS).
  ///
  /// The landing page copies the obfuscated card code to the clipboard
  /// before redirecting to TestFlight / the App Store. We read it on first
  /// launch and decode it via [CardIdObfuscator].
  Future<String?> getIOSDeferredDeepLink() async {
    if (!Platform.isIOS) return null;

    try {
      final ClipboardData? clipboardData =
          await Clipboard.getData(Clipboard.kTextPlain);

      if (clipboardData == null || clipboardData.text == null) {
        lastClipboardContent('<no data returned — access likely denied>');
      } else if (clipboardData.text!.isEmpty) {
        lastClipboardContent('<empty clipboard>');
      } else {
        lastClipboardContent(clipboardData.text);
      }

      if (clipboardData != null && clipboardData.text != null) {
        final String text = clipboardData.text!;

        final String? cardId = _decodeDeferredPayload(text);
        if (cardId != null) {
          deferredPath(cardId);
          // Clear the clipboard after a successful read so subsequent app
          // launches don't re-trigger card unlock.
          await Clipboard.setData(const ClipboardData(text: ''));
          return cardId;
        }
      }
    } catch (e) {
      lastClipboardContent('<error: $e>');
    }
    return null;
  }

  /// Retrieves the deferred deeplink based on the current platform
  Future<String?> getDeferredDeepLink() async {
    if (Platform.isAndroid) {
      return getAndroidDeferredDeepLink();
    } else if (Platform.isIOS) {
      return getIOSDeferredDeepLink();
    }
    return null;
  }

  /// Validate and decode a deferred deeplink payload as written by the
  /// landing page. Returns the plaintext card id on success, null otherwise.
  ///
  /// The payload is a [CardIdObfuscator]-encoded 16-char base32 code. We
  /// trim whitespace and tolerate URL-encoded input (Play Store has been
  /// observed to occasionally forward the referrer URL-encoded).
  @visibleForTesting
  static String? decodeDeferredPayload(String? raw) => _decodeDeferredPayload(raw);

  static String? _decodeDeferredPayload(String? raw) {
    if (raw == null) return null;
    var trimmed = raw.trim();
    if (trimmed.isEmpty) return null;
    // Be defensive about URL-encoding from Play Store.
    if (trimmed.contains('%')) {
      try {
        trimmed = Uri.decodeComponent(trimmed).trim();
      } catch (_) {
        // Leave as-is; tryDecode will reject it below.
      }
    }
    return CardIdObfuscator.tryDecode(trimmed);
  }
}
