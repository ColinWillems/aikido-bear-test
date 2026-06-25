import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends GetxController {
  HomeController({required this.profilesService});
  final ProfilesService profilesService;
  Rx<Profile> activeProfile = Profile().obs;

  final GlobalKey<ScrollSnapListState> scrollSnapKey = GlobalKey();

  @override
  void onInit() {
    activeProfile = profilesService.activeProfile;

    super.onInit();
  }

  void goToBannerLink() {
    LaunchMode launchMode = GetPlatform.isAndroid
        ? LaunchMode.externalApplication
        : LaunchMode.platformDefault;
    launchUrl(
      Uri.parse("https://www.bearsnacks.co.uk/card-creators/card-creations"),
      mode: launchMode,
    );
  }
}
