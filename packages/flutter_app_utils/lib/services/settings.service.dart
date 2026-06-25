import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app_utils/flutter_app_utils.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class SettingsService extends GetxService {
  Future<bool> deleteSharedPreferences() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    return await sharedPrefs.clear();
  }

  Future<void> deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  Future<void> deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();

    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }

  Future<void> clearImageCache() async {
    CacheManager cacheManager = ResourceCacheManager();
    cacheManager.emptyCache();
  }
}
