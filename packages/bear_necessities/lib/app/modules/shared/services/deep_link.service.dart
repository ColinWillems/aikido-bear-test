import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:get/get.dart';

class DeepLinkService extends GetxService {
  DeepLinkService({this.initialLink});
  final Uri? initialLink;

  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _deepLinkSubscription;

  final Rxn<Uri> deepLink = Rxn<Uri>();

  @override
  Future<void> onInit() async {
    _appLinks = AppLinks();

    if (initialLink != null) {
      deepLink(initialLink);
    }

    _deepLinkSubscription = _appLinks.uriLinkStream.listen((Uri uri) {
      deepLink(uri);
    }, onError: (error) {
      // Handle errors - do nothing for now
    });

    super.onInit();
  }

  @override
  void onClose() {
    _deepLinkSubscription?.cancel();
    super.onClose();
  }
}
