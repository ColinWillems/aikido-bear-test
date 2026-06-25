import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:path_provider/path_provider.dart';

Future<String> path(CaptureMode captureMode,
    [SensorPosition? sensorPosition]) async {
  final Directory extDir = await getTemporaryDirectory();
  final Directory testDir =
      await Directory('${extDir.path}/test').create(recursive: true);
  final String sensorPrefix = sensorPosition == null
      ? ""
      : sensorPosition == SensorPosition.front
          ? 'front_'
          : "back_";
  final String fileExtension = captureMode == CaptureMode.photo ? 'jpg' : 'mp4';
  final String filePath =
      '${testDir.path}/$sensorPrefix${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
  return filePath;
}
