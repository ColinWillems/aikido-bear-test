import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class MessageDialog extends StatelessWidget {
  const MessageDialog({
    super.key,
    required this.title,
    required this.message,
    this.primaryButtonText = "OK",
    this.primaryButtonAction,
    this.secondaryButtonText = "Cancel",
    this.secondaryButtonAction,
    this.showSecondaryButton = false,
  });
  final String title;
  final String message;
  final String primaryButtonText;
  final Function? primaryButtonAction;
  final String secondaryButtonText;
  final Function? secondaryButtonAction;
  final bool showSecondaryButton;

  @override
  Widget build(BuildContext context) {
    final List<Widget> buttons = [];
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Container(
        padding:
            const EdgeInsets.only(top: 18, right: 52, left: 52, bottom: 18),
        child: Center(
          child: Wrap(
            direction: Axis.horizontal,
            runSpacing: 10,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
                child: Wrap(
                  direction: Axis.horizontal,
                  runSpacing: 10,
                  children: (buttons).animate(interval: 200.ms).shake(
                        delay: 100.ms,
                        duration: 300.ms,
                        hz: 7,
                      ),
                ),
              ),
              Center(
                  child: SizedBox(
                      width: 200,
                      child: BearAssets.images.global.camera
                          .image(package: BearApp.bearNecessities))),
            ],
          ),
        ),
      ),
    );
  }
}
