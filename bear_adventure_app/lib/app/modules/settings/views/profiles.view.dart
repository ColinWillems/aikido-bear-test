import 'package:bear_adventure_app/app/modules/settings/controllers/profiles.controller.dart';
import 'package:bear_adventure_app/app/modules/settings/views/widgets/profile_avatar.widget.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:get/get.dart' hide GetNumUtils;
import 'package:flutter_animate/flutter_animate.dart';

class ProfilesView extends GetView<ProfilesController> {
  const ProfilesView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double padding = AppThemes.appLayout.padding.sm.left;
    return Obx(
      () {
        final List<Profile> profiles = controller.profiles.value;
        final Profile selectedProfile = controller.activeProfile.value;

        final int numProfiles = profiles.length;
        final int numDisplayItems =
            numProfiles < 4 ? numProfiles + 1 : numProfiles;

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: const BackButton(),
          ),
          body: Container(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.only(
                  top: 18, right: 40 + padding, left: 40 + padding, bottom: 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      Text(
                        LocaleKeys.settings_profiles_selection_title.tr,
                        textAlign: TextAlign.center,
                        style: textTheme.headlineMedium,
                      ),
                      Text(
                        LocaleKeys.settings_profiles_selection_content.tr,
                        textAlign: TextAlign.center,
                        style: textTheme.bodyLarge?.s22,
                      ),
                    ],
                  ),
                  Flexible(
                      flex: 1,
                      fit: FlexFit.loose,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        padding: const EdgeInsets.only(top: 18, bottom: 0),
                        itemCount: numDisplayItems,
                        itemBuilder: (context, i) {
                          Profile? profile =
                              (i < numProfiles) ? profiles[i] : null;
                          Color? color = profile?.color;
                          String id = profile?.id ?? "";
                          String name = profile?.name ?? "";
                          List<ProfileDecoration>? decorations =
                              profile?.decorations;
                          bool isActive = profile == selectedProfile;

                          return LayoutBuilder(builder: (context, constraints) {
                            return Hero(
                              tag: id,
                              child: (profile != null)
                                  ? IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () {
                                        controller.chooseProfileAction(profile);
                                      },
                                      icon: ProfileAvatar(
                                          active: isActive,
                                          width: constraints.maxWidth,
                                          name: name,
                                          displayName: true,
                                          color: color!,
                                          decorations: decorations!))
                                  : GestureDetector(
                                      onTap: () => controller.addProfile(),
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: SizedBox(
                                          width: constraints.maxWidth,
                                          height: constraints.maxWidth,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.25),
                                                  offset: const Offset(5, 5),
                                                  spreadRadius: 0,
                                                  blurRadius: 4,
                                                  blurStyle: BlurStyle.normal,
                                                ),
                                              ],
                                            ),
                                            child: BearAssets
                                                .images
                                                .settings
                                                .profile
                                                .addProfile
                                                .image(
                                                  package:
                                                      BearApp.bearNecessities,
                                                  fit: BoxFit.contain,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ).animate(delay: 500.ms).shake(duration: 500.ms);
                          });
                        },
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      LocaleKeys
                          .settings_profiles_selection_usage_instructions.tr,
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.s16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget profileItemBuilder(BuildContext context, int index) {
    return Stack();
  }
}
