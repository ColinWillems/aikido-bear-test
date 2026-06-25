import 'package:bear_adventure_app/app/modules/trophy_cabinet/controllers/great_job.controller.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart' hide GetNumUtils;

class GreatJobView extends GetWidget<GreatJobController> {
  const GreatJobView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double padding = AppThemes.appLayout.padding.sm.left;
    final String baseUrl = controller.imageBaseUrl;

    return Scaffold(
      extendBody: true,
      backgroundColor: BearColors.bearGreen,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.transparent,
        leading: const BackButton(),
        actions: const [
          SizedBox(width: 54),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(
            top: 8, right: padding + 18, left: padding + 18, bottom: 0),
        child: Column(
          children: [
            Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                runAlignment: WrapAlignment.center,
                direction: Axis.horizontal,
                runSpacing: 20,
                spacing: 20,
                children: [
                  BearAssets.images.dialogs.greatJobBearCub
                      .image(package: BearApp.bearNecessities),
                  Center(
                    child: AppStandardButton(
                      text: "check my rewards",
                      onPressed: () {
                        Get.close();
                        controller.navigation.viewTrophyCabinet();
                      },
                      color: BearColors.bearActionButton,
                    ),
                  ).animate().shake(
                        duration: 300.ms,
                        hz: 7,
                      ),
                ]),
          ],
        ),
      ),
    );
  }
}
