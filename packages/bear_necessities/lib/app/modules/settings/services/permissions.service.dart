// ignore_for_file: invalid_use_of_protected_member

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsService extends GetxService {
  PermissionsService();

  @override
  Future<void> onInit() async {
    cameraPermission(await Permission.camera.status);

    cameraPermissionGranted(cameraPermission().isGranted);

    permissionsGranted(cameraPermissionGranted());

    super.onInit();
  }

  Future<PermissionStatus> checkCameraPermissions() async {
    cameraPermission(await Permission.camera.request());

    cameraPermissionGranted(cameraPermission().isGranted);
    permissionsGranted(cameraPermissionGranted());

    if (cameraPermission().isPermanentlyDenied) {
      await openAppSettings();
    }

    return cameraPermission();
  }

  final Rx<PermissionStatus> cameraPermission = PermissionStatus.denied.obs;

  final RxBool cameraPermissionGranted = false.obs;

  final RxBool permissionsGranted = false.obs;
}
