import 'package:firebase_app_utils/utils/cache_manager/firebase/firebase_http_file_service.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_app_utils/flutter_app_utils.dart';

/// Use [FirebaseCacheManager] if you want to download files from firebase storage
/// and store them in your local cache.
class FirebaseCacheManager extends CacheManager {
  static const key = 'firebaseCache';

  static final FirebaseCacheManager _instance = FirebaseCacheManager._();

  factory FirebaseCacheManager() {
    return _instance;
  }

  FirebaseCacheManager._()
      : super(Config(key,
            maxNrOfCacheObjects: 1000,
            fileSystem: AppFileSystem(key),
            fileService: FirebaseHttpFileService()));
}
