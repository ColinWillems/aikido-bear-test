import 'package:flutter_app_utils/utils/cache_manager/app_file_system.dart';
import 'package:flutter_app_utils/utils/cache_manager/resource_file_service.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Use [ResourceCacheManager] if you want to download files from firebase storage
/// and store them in your local cache.
class ResourceCacheManager extends CacheManager {
  static const key = 'resourceCache';

  static final ResourceCacheManager _instance = ResourceCacheManager._();

  factory ResourceCacheManager() {
    return _instance;
  }

  ResourceCacheManager._()
      : super(Config(key,
            maxNrOfCacheObjects: 1000,
            fileSystem: AppFileSystem(key),
            fileService: ResourceFileService()));
}
