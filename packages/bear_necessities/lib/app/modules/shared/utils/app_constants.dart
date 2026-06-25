import 'package:bear_necessities/app/modules/shared/utils/card_id_obfuscator.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:get/get.dart';

abstract class BearApp {
  static const String bearAppName = "BEAR Adventure App";
  static const String bearHost = "bearfruitsnacks.com";
  static const String bearDomain = "app.$bearHost";
  static const String bearAppUrl = "https://$bearDomain/";
  static const String bearSupportName = "$bearAppName Support";
  static const String bearSupportEmail = "support@$bearHost";

  /// All hosts the app accepts for card-unlock deep links. Must stay in sync with:
  ///   - android/app/src/main/AndroidManifest.xml
  ///   - ios/Runner/Runner.entitlements
  ///   - bear_adventure_landing_page/public/.well-known/* (only on the active host)
  static const List<String> supportedDeepLinkHosts = <String>[
    bearDomain,                          // app.bearfruitsnacks.com (current)
    "client.bearadventure.app",          // legacy iO Digital domain
    "bearappqr.lotus.hosted-temp.com",   // temporary Lotus QA domain
  ];
  static const String bearCustomScheme = "bearadventure";
  static const String bearCustomSchemeHost = "card";

  /// Recognise any of our supported deep-link URLs and return the embedded
  /// card-id. Returns null when the URI isn't a card-unlock link, or when
  /// the embedded value isn't a valid obfuscated code.
  ///
  /// Accepted shapes (the ``<code>`` is always a 16-char obfuscated string
  /// produced by [CardIdObfuscator.encode] — raw ``TODO_GG_07``-style IDs
  /// are intentionally NOT accepted):
  ///   https://<host>/?path=<code>     (smart link, preferred)
  ///   https://<host>/<code>           (path variant)
  ///   https://<host>/<prefix>-<code>  (path variant with prefix)
  ///   bearadventure://card?path=<code> (debug scheme)
  static String? tryExtractCardId(Uri uri) {
    final isHttps = uri.scheme == "https" && supportedDeepLinkHosts.contains(uri.host);
    final isCustom = uri.scheme == bearCustomScheme && uri.host == bearCustomSchemeHost;
    if (!isHttps && !isCustom) return null;

    final pathParam = uri.queryParameters["path"];
    if (pathParam != null && pathParam.isNotEmpty) {
      return CardIdObfuscator.tryDecode(pathParam);
    }

    if (uri.pathSegments.isEmpty) return null;
    final segment = uri.pathSegments.last;
    if (segment.isEmpty) return null;
    return CardIdObfuscator.tryDecode(segment.split('-').last);
  }

  /// Build a QR-friendly deep link for [cardId]. The card ID is obfuscated
  /// via [CardIdObfuscator.encode] so the printed QR doesn't leak the
  /// underlying naming pattern.
  static String buildCardUnlockUrl(String cardId) =>
      "$bearAppUrl?path=${CardIdObfuscator.encode(cardId)}";

  static const String bearBucketId = "bear-app-11252";
  static const String bearAppStorageUrl = "gs://$bearBucketId/";
  static const String bearAppStorageFriendlyUrl =
      "https://firebasestorage.googleapis.com/v0/b/$bearBucketId/o/";
  static const String imagesPath = "images";
  static const String imageExtension = ".png";
  static const String animationExtension = ".lottie";
  static const String profileToken = "%profile_id%";

  static const String bearNecessities = "bear_necessities";

  static Future<bool> get isRealDevice async {
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

  static Future<String> get getDeviceInfo async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    String deviceDetails = "";

    if (GetPlatform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceDetails =
          "Device: ${androidInfo.manufacturer} ${androidInfo.brand} ${androidInfo.device} Android ${androidInfo.version.release}\n";
    } else if (GetPlatform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceDetails =
          "Device: ${iosInfo.model} ${iosInfo.systemName} ${iosInfo.systemVersion}\n";
    }

    return deviceDetails;
  }

  static Future<String> get getAppVersion async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    final String appName = packageInfo.appName;
    final String version = packageInfo.version;
    final String buildNumber = packageInfo.buildNumber;

    return "App: $appName $version+$buildNumber\n";
  }
}
