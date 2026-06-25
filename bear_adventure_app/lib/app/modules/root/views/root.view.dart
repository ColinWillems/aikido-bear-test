import 'package:bear_adventure_app/app/modules/cards/views/widgets/card_counter.widget.dart';
import 'package:bear_adventure_app/app/modules/root/controllers/root.controller.dart';
import 'package:bear_adventure_app/app/modules/settings/views/widgets/active_profile.widget.dart';
import 'package:bear_adventure_app/app/modules/shared/responsive_view_container.widget.dart';
import 'package:bear_adventure_app/app/routes/app_pages.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RootView extends GetView<RootController> {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    // Force controller to initialise
    // ignore: unused_local_variable
    final double padding = AppThemes.appLayout.padding.scaledMinPadding;
    final controllerReady = controller.initialized;
    return ResponsiveViewContainer(
      child: RouterOutlet.builder(
        delegate: Get.nestedKey(null),
        builder: (context) {
          return Scaffold(
              extendBody: true,
              extendBodyBehindAppBar: true,
              backgroundColor: BearColors.bearGreen,
              body: Container(
                  constraints: const BoxConstraints(minHeight: 322),
                  child: GetRouterOutlet(
                    initialRoute: Routes.home,
                    delegate: Get.nestedKey(null),
                    anchorRoute: '/',
                    filterPages: (afterAnchor) {
                      var pages = afterAnchor.take(1);
                      String? screenName = pages.firstOrNull?.name;

                      if (screenName != null) {
                        controller.sendScreenViewToAnalytics(screenName);
                      }
                      return pages;
                    },
                  )),
              bottomNavigationBar: Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(left: padding, right: padding),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 6, right: 6, bottom: 0, top: 0),
                      color: BearColors.creamWhite,
                      child: SafeArea(
                          bottom: true,
                          top: false,
                          child: Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                icon: const ActiveProfile(width: 64),
                                onPressed: () {
                                  controller.navigation.goToProfiles();
                                },
                              ),
                              Container(
                                constraints: const BoxConstraints(
                                    maxWidth: 50, maxHeight: 62),
                                padding: const EdgeInsets.only(left: 2),
                                child: const CardCounter(),
                              ),
                              const Spacer(),
                              SizedBox(
                                width: 48,
                                height: 48,
                                child: IconButton(
                                  tooltip: "Home",
                                  padding: const EdgeInsets.all(4),
                                  onPressed: controller.navigation.goHome,
                                  icon: BearAssets.images.global.icons.homeIcon
                                      .image(package: BearApp.bearNecessities),
                                ),
                              ),
                              SizedBox(
                                width: 48,
                                height: 48,
                                child: IconButton(
                                  tooltip: "Trophy Cabinet",
                                  padding: const EdgeInsets.all(4),
                                  onPressed:
                                      controller.navigation.goToTrophyCabinet,
                                  icon: BearAssets
                                      .images.global.icons.trophyIcon
                                      .image(package: BearApp.bearNecessities),
                                ),
                              ),
                              SizedBox(
                                width: 48,
                                height: 48,
                                child: IconButton(
                                  tooltip: "Settings",
                                  padding: const EdgeInsets.all(4),
                                  onPressed: controller.navigation.goToSettings,
                                  icon: BearAssets
                                      .images.global.icons.settingsIcon
                                      .image(package: BearApp.bearNecessities),
                                ),
                              ),
                            ],
                          )),
                    ),
                  )));
        },
      ),
    );
  }
}
