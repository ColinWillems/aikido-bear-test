import 'package:bear_adventure_app/app/modules/trophy_cabinet/controllers/navigation/trophy_cabinet_navigation.dart';
import 'package:get/get.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:url_launcher/url_launcher.dart';

class RewardPartVideoController extends GetxController {
  RewardPartVideoController({
    required this.service,
    required this.urlService,
    required this.profilesService,
    required this.permissionsService,
  });

  final TrophyCabinetService service;
  final UrlService urlService;
  final ProfilesService profilesService;
  final PermissionsService permissionsService;

  late final TrophyCabinetNavigation navigation;

  Rxn<BearReward> reward = Rxn<BearReward>();
  Rxn<BearRewardPart> rewardPart = Rxn<BearRewardPart>();

  final RxBool hasAttachedPhoto = false.obs;
  final RxBool showAttachPhotoButtons = false.obs;

  final String imageBaseUrl = "/";

  late final Profile profile;

  @override
  Future<void> onInit() async {
    navigation =
        TrophyCabinetNavigation(service: service, urlService: urlService);
    reward = service.selectedBearReward;
    rewardPart = service.selectedBearRewardPart;
    profile = profilesService.activeProfile();

    super.onInit();
  }

  @override
  Future<void> onReady() async {
    launchVideo();
    super.onReady();
  }

  void launchVideo() {
    final BearRewardPart? part = rewardPart();
    if (part != null) {
      String videoUrl = part.externalUrl;

      LaunchMode launchMode = LaunchMode.externalApplication;
      launchUrl(
        Uri.parse(videoUrl),
        mode: launchMode,
      );
    }
  }
}
