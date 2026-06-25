import 'package:bear_adventure_app/app/modules/splash/controllers/splash.controller.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: BearColors.bearGreen,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: BearColors.bearGreen,
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Container(
            decoration: const BoxDecoration(color: BearColors.bearGreen),
            margin: const EdgeInsets.only(bottom: 0),
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.antiAlias,
            child: Lottie.asset(
              BearAssets.images.splash.splashScreenJson.path,
              package: BearApp.bearNecessities,
              controller: controller.animationController,
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animate: false,
              repeat: false,
              onLoaded: (comp) {
                controller.animationController.stop();
                controller.animationController
                  ..duration = comp.duration
                  ..forward();
              },
              errorBuilder: (context, error, stackTrace) {
                // Defer navigation to avoid mutating navigation state during
                // the build phase (which would otherwise be a no-op or crash).
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  controller.closeSplash();
                });
                return const SizedBox.shrink();
              },
            )).animate().fade(duration: 200.ms),
      ),
    );
  }
}
