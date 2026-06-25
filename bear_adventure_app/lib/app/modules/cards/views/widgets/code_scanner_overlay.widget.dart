import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart';

class CodeScannerOverlay extends StatelessWidget {
  final double width;
  final double height;
  final double aspectRatio;

  static const double guideBoxSize = 0.8;

  const CodeScannerOverlay(this.width, this.height, this.aspectRatio,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            width: width * guideBoxSize,
            height: 0.8,
            color: Colors.redAccent.withOpacity(0.4),
          ),
        ),
        Center(
          child: Container(
            width: width * guideBoxSize,
            height: width * guideBoxSize * aspectRatio,
            decoration: BoxDecoration(
              border:
                  Border.all(color: Colors.black.withOpacity(0.3), width: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        ColorFiltered(
          colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.srcOut),
          child: Stack(fit: StackFit.expand, children: [
            Container(
                decoration: const BoxDecoration(
              color: Colors.black,
              backgroundBlendMode: BlendMode.dstIn,
            )),
            Center(
              child: Container(
                width: width * guideBoxSize,
                height: width * guideBoxSize * aspectRatio,
                decoration: BoxDecoration(
                  color: BearColors.creamWhite,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
