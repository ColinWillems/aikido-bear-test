import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:clock/clock.dart';

/// [ResourceFileService] is another common file service which parses a
/// resource path.
class ResourceFileService extends HttpFileService {
  @override
  Future<FileServiceResponse> get(String url,
      {Map<String, String>? headers}) async {
    String fileExtension = "";
    ByteData data = ByteData(0);

    if (url.isNotEmpty) {
      Uri uri = Uri.parse(url);
      String path = uri.path;
      fileExtension = ".${uri.pathSegments.last.split(".").last}";

      data = await rootBundle.load("assets$path");
    }

    final ResourceLoadResponse response =
        ResourceLoadResponse(data, fileExtension);

    return response;
  }
}

class ResourceLoadResponse implements FileServiceResponse {
  ResourceLoadResponse(this._response, this._fileExtension);

  final DateTime _receivedTime = clock.now();

  final String _fileExtension;

  final ByteData _response;

  @override
  int get statusCode => 200;

  String? _header(String name) {
    return null;
  }

  @override
  Stream<List<int>> get content {
    Uint8List bytes = _response.buffer
        .asUint8List(_response.offsetInBytes, _response.lengthInBytes);
    return Stream.value(List<int>.from(bytes));
  }

  @override
  int? get contentLength => _response.lengthInBytes;

  @override
  String? get eTag => null;

  @override
  DateTime get validTill {
    // Without a cache-control header we keep the file for a week
    var ageDuration = const Duration(days: 7);
    final controlHeader = _header(HttpHeaders.cacheControlHeader);
    if (controlHeader != null) {
      final controlSettings = controlHeader.split(',');
      for (final setting in controlSettings) {
        final sanitizedSetting = setting.trim().toLowerCase();
        if (sanitizedSetting == 'no-cache') {
          ageDuration = const Duration();
        }
        if (sanitizedSetting.startsWith('max-age=')) {
          var validSeconds = int.tryParse(sanitizedSetting.split('=')[1]) ?? 0;
          if (validSeconds > 0) {
            ageDuration = Duration(seconds: validSeconds);
          }
        }
      }
    }

    return _receivedTime.add(ageDuration);
  }

  @override
  String get fileExtension {
    return _fileExtension;
  }
}
