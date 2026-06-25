import 'dart:ui';

import 'package:bear_adventure_app/app/modules/settings/controllers/profile.controller.dart';
import 'package:bear_adventure_app/app/modules/settings/views/widgets/profile_avatar.widget.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:get/get.dart' hide GetNumUtils;
import 'package:flutter_animate/flutter_animate.dart';

class ProfileAvatarView extends GetWidget<ProfileController> {
  const ProfileAvatarView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double padding = AppThemes.appLayout.padding.sm.left;
    final FlutterView window = View.of(context);
    final double topSafeArea = window.viewPadding.top / window.devicePixelRatio;

    return Obx(
      () {
        final Profile profile = controller.selectedProfile.value;

        final bool isNew = controller.isNew();

        final String subtitle = isNew
            ? LocaleKeys.settings_profiles_avatar_add_subtitle.tr
            : LocaleKeys.settings_profiles_avatar_edit_subtitle.tr;

        final String content = isNew
            ? LocaleKeys.settings_profiles_avatar_add_content.tr
            : LocaleKeys.settings_profiles_avatar_edit_content.tr;

        final List<ProfileDecoration> hats = ProfileDecoration.values
            .where((decoration) => decoration.type == ProfileDecorationType.hat)
            .toList();
        final List<ProfileDecoration> accessories = ProfileDecoration.values
            .where((decoration) =>
                decoration.type == ProfileDecorationType.accessory)
            .toList();
        const List<ProfileColour> colours = ProfileColour.values;

        final List<List<dynamic>> customisations = [hats, accessories, colours];

        const double customisationSize = 62;

        return WillPopScope(
          onWillPop: () async => !controller.firstView(),
          child: Scaffold(
            extendBodyBehindAppBar: true,
            extendBody: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: const BackButton(),
            ),
            body: Container(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              child: SafeArea(
                top: false,
                child: Container(
                  padding: EdgeInsets.only(
                      top: 18 + topSafeArea,
                      right: padding,
                      left: padding,
                      bottom: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.center,
                        direction: Axis.horizontal,
                        runSpacing: 12,
                        children: [
                          Center(
                            child: Text(
                              subtitle,
                              textWidthBasis: TextWidthBasis.parent,
                              textAlign: TextAlign.center,
                              style: textTheme.headlineSmall?.s20,
                            ),
                          ),
                          Center(
                            child: Text(
                              LocaleKeys.settings_profiles_avatar_title.tr
                                  .replaceFirst(RegExp(r'%character_name%'),
                                      profile.name),
                              textWidthBasis: TextWidthBasis.parent,
                              textAlign: TextAlign.center,
                              style: textTheme.headlineMedium,
                            ),
                          ),
                          Center(
                            child: Text(
                              content,
                              textWidthBasis: TextWidthBasis.parent,
                              textAlign: TextAlign.center,
                              style: textTheme.bodyLarge?.s22,
                            ),
                          ),
                        ],
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: DragTarget<ProfileDecoration>(
                            hitTestBehavior: HitTestBehavior.opaque,
                            builder: (context, candidateData, rejectedData) {
                              return ProfileAvatar(
                                width: 160,
                                color: profile.color,
                                decorations: profile.decorations,
                              );
                            },
                            onAcceptWithDetails: ((details) {
                              ProfileDecoration decoration = details.data;
                              if (!profile.decorations.contains(decoration)) {
                                controller.addProfileDecoration(decoration);
                              }
                            }),
                          ),
                        ),
                      ),
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(0),
                        shrinkWrap: true,
                        itemCount: customisations.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                mainAxisExtent: customisationSize,
                                mainAxisSpacing: 25),
                        itemBuilder: (BuildContext context, int index) {
                          const List<Color> labelColors = [
                            Color(0xFFD6324E),
                            Color(0xFFA56DC3),
                            Color(0xFFEA85C9),
                          ];
                          final Color labelColor =
                              labelColors[index % labelColors.length];
                          Widget label = Flexible(
                              fit: FlexFit.tight,
                              child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 3, left: 3, right: 3, bottom: 0),
                                  decoration: BoxDecoration(
                                      color: labelColor,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(4.5)),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: const Offset(5, 5),
                                            blurRadius: 4,
                                            color:
                                                Colors.black.withOpacity(0.25))
                                      ]),
                                  alignment: Alignment.center,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      LocaleKeys
                                          .settings_profiles_avatar_choose_label
                                          .tr,
                                      maxLines: 1,
                                      style: textTheme.displayMedium?.w900.s20,
                                    ),
                                  )));
                          var customisationWidgets = customisations[index]
                              .map<Widget>((customisation) {
                            final Color color = customisation is ProfileColour
                                ? customisation.toColor()
                                : BearColors.creamWhite;
                            final bool selected = customisation
                                    is ProfileDecoration
                                ? profile.decorations.contains(customisation)
                                : customisation is ProfileColour
                                    ? profile.color.value == color.value
                                    : false;
                            final Color borderColor = selected
                                ? BearColors.bearRed
                                : BearColors.creamWhite;
                            final Widget child =
                                customisation is ProfileDecoration
                                    ? customisation.toImage()
                                    : const SizedBox.shrink();

                            return Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: IconButton(
                                    onPressed: () {
                                      if (!selected) {
                                        if (customisation is ProfileColour) {
                                          controller.changeProfileColour(
                                              customisation);
                                        } else if (customisation
                                            is ProfileDecoration) {
                                          controller.addProfileDecoration(
                                              customisation);
                                        }
                                      }
                                    },
                                    padding: EdgeInsets.zero,
                                    iconSize: customisationSize,
                                    isSelected: selected,
                                    color: Colors.pink,
                                    icon: LongPressDraggable<
                                            ProfileCustomisation>(
                                        data: customisation,
                                        dragAnchorStrategy:
                                            pointerDragAnchorStrategy,
                                        feedback: SizedBox(
                                            height: customisationSize,
                                            width: customisationSize,
                                            child: Stack(
                                                fit: StackFit.passthrough,
                                                clipBehavior: Clip.none,
                                                alignment: Alignment.topLeft,
                                                children: [
                                                  Positioned(
                                                      top: -120,
                                                      left: -90,
                                                      width:
                                                          customisationSize * 2,
                                                      height:
                                                          customisationSize * 2,
                                                      child: child)
                                                ])),
                                        childWhenDragging: Container(
                                          width: customisationSize,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: color,
                                              border: Border.all(
                                                  color: borderColor, width: 4),
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: const Offset(5, 5),
                                                    blurRadius: 4,
                                                    color: Colors.black
                                                        .withOpacity(0.25))
                                              ]),
                                          child: const SizedBox.shrink(),
                                        ),
                                        feedbackOffset: const Offset(0, 0),
                                        child: Container(
                                          width: customisationSize,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: color,
                                              border: Border.all(
                                                  color: borderColor, width: 4),
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: const Offset(5, 5),
                                                    blurRadius: 4,
                                                    color: Colors.black
                                                        .withOpacity(0.25))
                                              ]),
                                          child: child,
                                        ))));
                          }).toList();
                          customisationWidgets.insert(0, label);
                          return Row(
                            children: customisationWidgets
                                .animate(interval: 200.ms)
                                .shake(duration: 500.ms, hz: 5),
                          );
                        },
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 24, left: 54, right: 54),
                        child: Wrap(
                          direction: Axis.horizontal,
                          runSpacing: 10,
                          children: [
                            AppStandardButton(
                              text:
                                  LocaleKeys.settings_profiles_avatar_button.tr,
                              color: const Color(0xFFF47C66),
                              onPressed: () => controller.completeProfile(),
                            ).animate().shake(duration: 300.ms, hz: 7),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
