import 'dart:async';

import 'package:camerawesome/pigeon.dart';
import 'package:get/get.dart';

import '../../../../utils/camera/file_utils.dart';
import '../../../../utils/camera/mlkit_utils.dart';
import 'barcode_preview_overlay.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class CodeScanner extends StatefulWidget {
  const CodeScanner({super.key, this.onScan, this.onError, this.once = true});
  final void Function(Object error)? onError;
  final void Function(Barcode barcode)? onScan;
  final bool once;

  @override
  State<CodeScanner> createState() => _CodeScannerState();
}

class _CodeScannerState extends State<CodeScanner> {
  final _barcodeScanner = BarcodeScanner(formats: [BarcodeFormat.all]);
  List<Barcode> _barcodes = [];
  AnalysisImage? _image;
  String? found;
  bool scanned = false;
  Timer? timeout;

  @override
  void dispose() {
    // Belangrijk: een nog niet gevuurde Timer (geschedule na een
    // succesvolle detectie maar de gebruiker tikt back voor de tick)
    // moet gecanceld worden. Anders vuurt de callback later op een
    // gedisposed widget/controller en levert dat een "Null check
    // operator used on null value" op in release builds.
    timeout?.cancel();
    timeout = null;
    found = null;
    scanned = false;
    _barcodeScanner.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: CameraAwesomeBuilder.awesome(
          saveConfig: SaveConfig.photoAndVideo(
            initialCaptureMode: CaptureMode.preview,
            photoPathBuilder: (sensors) async {
              if (sensors.length == 1) {
                return SingleCaptureRequest(
                    await path(CaptureMode.photo), sensors.first);
              } else {
                // Separate pictures taken with front and back camera
                return MultipleCaptureRequest(
                  {
                    for (final sensor in sensors)
                      sensor: await path(CaptureMode.photo, sensor.position),
                  },
                );
              }
            },
            videoPathBuilder: (sensors) async {
              if (sensors.length == 1) {
                return SingleCaptureRequest(
                    await path(CaptureMode.video), sensors.first);
              } else {
                // Separate pictures taken with front and back camera
                return MultipleCaptureRequest(
                  {
                    for (final sensor in sensors)
                      sensor: await path(CaptureMode.video, sensor.position),
                  },
                );
              }
            },
            videoOptions: VideoOptions(
              enableAudio: false,
              ios: CupertinoVideoOptions(
                fps: 10,
              ),
              android: AndroidVideoOptions(
                bitrate: 6000000,
                fallbackStrategy: QualityFallbackStrategy.lower,
              ),
            ),
            exifPreferences: ExifPreferences(saveGPSLocation: true),
          ),
          previewFit: CameraPreviewFit.cover,
          previewDecoratorBuilder: (state, preview) {
            return BarcodePreviewOverlay(
              state: state,
              preview: preview,
              barcodes: _barcodes,
              analysisImage: _image,
            );
          },
          topActionsBuilder: (state) {
            return AwesomeTopActions(
              state: state,
              children: [
                AwesomeFlashButton(state: state),
                AwesomeSensorTypeSelector(state: state),
                AwesomeCameraSwitchButton(state: state),
              ],
            );
          },
          middleContentBuilder: (state) {
            return const SizedBox.shrink();
          },
          bottomActionsBuilder: (state) {
            return const SizedBox.shrink();
          },
          onImageForAnalysis: (img) => _processImageBarcode(img),
          imageAnalysisConfig: AnalysisConfig(
            androidOptions: const AndroidAnalysisOptions.nv21(
              width: 1024,
            ),
            maxFramesPerSecond: 5,
          ),
        ),
      ),
    );
  }

  Future _processImageBarcode(AnalysisImage img) async {
    if (!widget.once || !scanned) {
      try {
        var recognizedBarCodes =
            await _barcodeScanner.processImage(img.toInputImage());
        // Widget kan tijdens de await zijn gedisposed (gebruiker tikte
        // back). Niet meer setState aanroepen of een Timer schedulen.
        if (!mounted) return;
        setState(() {
          _barcodes = recognizedBarCodes;
          var onScan = widget.onScan;
          if (onScan != null && _barcodes.isNotEmpty) {
            Barcode barcode = _barcodes.first;
            scanned = true;
            timeout ??= Timer.periodic(1.seconds, (Timer timer) {
              timer.cancel();
              timeout = null;
              // Tweede mounted-check: tussen het schedulen en vuren van
              // de timer kan de widget alsnog zijn gedisposed.
              if (!mounted) return;
              if (!widget.once || (found != barcode.rawValue)) {
                // ignore: unnecessary_null_comparison
                if (onScan != null) {
                  // Double check onScan exists based on timer running
                  onScan(barcode);
                }
                found = barcode.rawValue;
              }
            });
          }
          _image = img;
        });
      } catch (error) {
        if (!mounted) return;
        if (widget.onError != null) {
          widget.onError!(error);
        }
      }
    }
  }
}
