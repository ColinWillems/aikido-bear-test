import 'package:bear_adventure_app/app/modules/settings/controllers/profile.controller.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart' hide GetNumUtils;
import 'package:avoid_keyboard/avoid_keyboard.dart';

class ProfileNameView extends GetView<ProfileController> {
  const ProfileNameView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double padding = AppThemes.appLayout.padding.sm.left;
    return Obx(
      () {
        final bool firstView = controller.firstView();
        final bool isNew = controller.isNew();

        final bool isValid = controller.nameIsValid();

        final String title = isNew
            ? LocaleKeys.settings_profiles_name_add_title.tr
            : LocaleKeys.settings_profiles_name_edit_title.tr;

        final String content = isNew
            ? LocaleKeys.settings_profiles_name_add_content.tr
            : LocaleKeys.settings_profiles_name_edit_content.tr;

        final formKey = controller.formKey;

        return WillPopScope(
          onWillPop: () async {
            if (firstView) {
              controller.goBack();
              return false;
            }
            return true;
          },
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: firstView
                  ? BackButton(onPressed: controller.goBack)
                  : const BackButton(),
            ),
            body: Container(
              alignment: Alignment.center,
              child: SafeArea(
                top: false,
                child: Container(
                  padding: EdgeInsets.only(
                      top: 18, right: padding, left: padding, bottom: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      (firstView) ? const Spacer() : const SizedBox.shrink(),
                      Wrap(
                        alignment: WrapAlignment.center,
                        direction: Axis.horizontal,
                        runSpacing: 12,
                        children: [
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: textTheme.headlineMedium,
                          ),
                          Text(
                            content,
                            textAlign: TextAlign.center,
                            style: textTheme.bodyLarge?.s22,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: AvoidKeyboard(
                              spacing: 40,
                              child: Form(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                key: formKey,
                                child: AppTextFormField(
                                  decoration: InputDecoration(
                                      border: const OutlineInputBorder(
                                          borderSide: BorderSide(width: 0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      filled: true,
                                      fillColor: Colors.black.withOpacity(0.25),
                                      hintText: "Type name...",
                                      hintStyle: textTheme.displayMedium?.s27
                                          .transparentWhiteColor,
                                      errorStyle:
                                          textTheme.labelSmall?.errorColor),
                                  style: textTheme.displayMedium?.s27,
                                  keyboardType: TextInputType.name,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (value) {
                                    if (isValid) {
                                      controller.updateProfileName();
                                      controller.navigation.editProfileAvatar();
                                    }
                                  },
                                  controller: controller.textEditingController,
                                  validator: controller.nameValidator,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      (firstView) ? const Spacer() : const SizedBox.shrink(),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 24, left: 54, right: 54),
                        child: Wrap(
                          direction: Axis.horizontal,
                          runSpacing: 10,
                          children: [
                            AppStandardButton(
                              text: LocaleKeys.settings_profiles_name_button.tr,
                              color: const Color(0xFFF47C66),
                              onPressed: (isValid)
                                  ? () {
                                      controller.updateProfileName();
                                      controller.navigation.editProfileAvatar();
                                    }
                                  : null,
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
