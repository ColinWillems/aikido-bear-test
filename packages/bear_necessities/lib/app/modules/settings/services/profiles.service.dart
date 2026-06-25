// ignore_for_file: invalid_use_of_protected_member

import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart';
import 'package:gamification/gamification.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nanoid/non_secure.dart';

class ProfilesService extends GetxService {
  ProfilesService({required this.profilesRepository});
  static const String activeProfileKey = "activeProfileId";
  static Profile defaultProfile = Profile(
      id: nanoid(5),
      name: "Default",
      color: BearColors.bearAvatarPurple,
      index: 0,
      decorations: const [ProfileDecoration.baseballCap, ProfileDecoration.scarf]);

  final ProfilesRepository? profilesRepository;
  final Rx<Profile> activeProfile = defaultProfile.obs;
  final Rx<Profile> editingProfile = defaultProfile.obs;
  final RxList<Profile> profiles = <Profile>[].obs;

  RxBool isNew = false.obs;
  late final Gamification gamification;
  late final PersistenceManager persistenceManager;

  @override
  Future<void> onInit() async {
    gamification = Gamification(enablePersistence: true);

    editingProfile.listen((profile) {
      isNew(getProfileById(profile.id) == null);
    });

    activeProfile.listen((profile) async {
      gamification.profile = profile.id;
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(activeProfileKey, profile.id);
    });

    await _restoreProfiles();

    super.onInit();
  }

  Future<void> _restoreProfiles() async {
    persistenceManager = SharedPreferencesPersistenceManager();
    final prefs = await SharedPreferences.getInstance();
    final String? restoredActiveProfileId = prefs.getString(activeProfileKey);
    const Type profileType = Profile;
    final profileSerializer = Serializer<Profile>(
      deserialize: (Object? json) => Profile.profileFromJson(json),
      serialize: (dynamic profile) {
        return (profile as Profile).toJson();
      },
    );
    const Type colorType = Color;
    final colorSerializer = Serializer<Color>(
      deserialize: (Object? json) => ColorUtil.fromJson(json as String),
      serialize: (dynamic color) {
        return (color as Color).toJson();
      },
    );

    persistenceManager.serializers[profileType.toString()] = profileSerializer;
    persistenceManager.serializers[colorType.toString()] = colorSerializer;

    final List<Profile> restoredProfiles =
        await persistenceManager.restore<Profile, Profile>("");
    if (restoredProfiles.isNotEmpty) {
      profiles.assignAll(restoredProfiles);
      final Profile restoredActiveProfile = profiles.firstWhereOrNull(
              (profile) => profile.id == restoredActiveProfileId) ??
          profiles.first;
      activeProfile(restoredActiveProfile);
    }
  }

  Profile createProfile() {
    final profile = Profile(
      id: nanoid(5),
      index: profiles.length * 100,
    );
    editingProfile(profile);
    return profile;
  }

  Future<bool> addProfile(Profile profile, [bool makeActive = true]) async {
    if (!profiles.contains(profile)) {
      profiles.add(profile);
      if (makeActive) {
        activeProfile(profile);
      }
      profiles.refresh();
      isNew(false);
      await persistenceManager.save<Profile, Profile>("", profiles.toList());
      return true;
    }
    return false;
  }

  Future<bool> updateProfile(Profile profile, Profile newProfile) async {
    editingProfile(newProfile);

    final int index = profiles.indexOf(profile);
    if (index > -1) {
      if (newProfile.id == activeProfile().id) {
        activeProfile(newProfile);
      }
      profiles[index] = newProfile;
      profiles.refresh();
      await persistenceManager.save<Profile, Profile>("", profiles.toList());
      return true;
    }
    return false;
  }

  Future<bool> deleteProfile(Profile profile,
      [bool allowDefaultDeletion = false]) async {
    var success = false;
    if (allowDefaultDeletion || profiles.length > 1) {
      success = profiles.remove(profile);
      await persistenceManager.save<Profile, Profile>("", profiles.toList());
      gamification.clearAll(profile.id);
      if (profile.id == activeProfile().id) {
        final Profile profileToSelect = profiles.firstOrNull ?? defaultProfile;
        activeProfile(profileToSelect);
      }
    }
    return success;
  }

  Future<bool> deleteAllProfiles() async {
    bool output = true;

    for (var i = profiles.length - 1; i > -1; i--) {
      var profile = profiles[i];
      output &= await deleteProfile(profile, true);
    }

    return output;
  }

  Profile? getProfileById(String profileId) {
    return profiles.firstWhereOrNull((profile) => profile.id == profileId);
  }

  Future<void> addProfileDecoration(
      Profile profile, ProfileDecoration newDecoration) async {
    final List<ProfileDecoration> decorations = profile.decorations.toList();
    decorations
        .removeWhere((decoration) => decoration.type == newDecoration.type);
    decorations.add(newDecoration);

    final Profile updatedProfile = profile.copyWith(decorations: decorations);

    await updateProfile(profile, updatedProfile);
  }

  Future<void> changeProfileColour(
      Profile profile, ProfileColour colour) async {
    final Profile updatedProfile = profile.copyWith(color: colour.toColor());

    await updateProfile(profile, updatedProfile);
  }

  Future<void> changeProfileName(Profile profile, String name) async {
    final Profile updatedProfile = profile.copyWith(name: name);

    await updateProfile(profile, updatedProfile);
  }
}
