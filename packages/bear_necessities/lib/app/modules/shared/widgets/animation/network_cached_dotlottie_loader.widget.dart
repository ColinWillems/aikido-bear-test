import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

typedef DotLottieChildBuilder = Widget Function(
  BuildContext context,
  DotLottie? dotLottie,
);

typedef DotLottieErrorWidgetBuilder = Widget Function(
  BuildContext context,
  Object error,
  StackTrace? stackTrace,
);

/// A widget that loads a DotLottie file.
///
/// Several constructors are provided for the various ways that a DotLottie file
/// can be loaded:
///
///  * [NetworkCachedDotLottieLoader.fromAsset], for obtaining a DotLottie file from an [AssetBundle]
///    using a key.
///  * [NetworkCachedDotLottieLoader.fromNetwork], for obtaining a DotLottie file from a URL.
///  * [NetworkCachedDotLottieLoader.fromFile], for obtaining a DotLottie file from a [File].
///

class NetworkCachedDotLottieLoader extends StatefulWidget {
  @override
  State<NetworkCachedDotLottieLoader> createState() =>
      _NetworkCachedDotLottieLoaderState();

  final String url;
  final CacheManager cacheManager;
  final DotLottieChildBuilder? frameBuilder;
  final DotLottieErrorWidgetBuilder? errorBuilder;
  final Map<String, String>? headers;

  const NetworkCachedDotLottieLoader.fromNetworkWithCache(
    this.url, {
    super.key,
    this.headers,
    required this.cacheManager,
    required this.frameBuilder,
    this.errorBuilder,
  });
}

class _NetworkCachedDotLottieLoaderState
    extends State<NetworkCachedDotLottieLoader> {
  Future<File>? _loadingFuture;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(NetworkCachedDotLottieLoader oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.cacheManager != widget.cacheManager) {
      _load();
    }
  }

  void _load() {
    _loadingFuture =
        widget.cacheManager.getSingleFile(widget.url, headers: widget.headers);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
        future: _loadingFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            if (widget.errorBuilder != null) {
              return widget.errorBuilder!(
                  context, snapshot.error!, snapshot.stackTrace);
            } else if (kDebugMode) {
              return ErrorWidget(snapshot.error!);
            }
          }
          if (widget.frameBuilder != null && snapshot.data is File) {
            return DotLottieLoader.fromFile(
              snapshot.data!,
              frameBuilder: widget.frameBuilder,
              errorBuilder: widget.errorBuilder,
            );
          }

          return Container();
        });
  }
}
