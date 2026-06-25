import 'package:bear_adventure_app/app/modules/settings/controllers/profiles.controller.dart';
import 'package:bear_adventure_app/app/modules/settings/views/widgets/profile_avatar.widget.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActiveProfile extends StatelessWidget {
  const ActiveProfile({super.key, this.width = 64});
  final double width;
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final ProfilesController controller = Get.find<ProfilesController>();
      final Profile profile = controller.activeProfile();

      return Tooltip(
          message: profile.name,
          child: ProfileAvatar(
            color: profile.color,
            width: width,
            decorations: profile.decorations,
          ));
    });
  }
}
