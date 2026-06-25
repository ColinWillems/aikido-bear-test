import 'package:flutter/material.dart';

class FeatureBackground extends Decoration {
  final BoxPainter _painter;

  FeatureBackground({required Color color, required double radius})
      : _painter = DrawFeature(color);

  @override
  BoxPainter createBoxPainter([void onChanged]) => _painter;
}

class DrawFeature extends BoxPainter {
  late Paint _paint;

  DrawFeature(Color color) {
    _paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    if (configuration.size == null) {
      return;
    }

    const double leftIndent = 25;
    const double rightIndent = 30;

    final Offset leftOffset =
        offset + Offset(leftIndent, configuration.size!.height / 2);
    final Offset rightOffset = offset +
        Offset(configuration.size!.width - rightIndent,
            configuration.size!.height / 2);
    var path = Path();

    path.moveTo(offset.dx, offset.dy);
    path.lineTo(offset.dx + configuration.size!.width, offset.dy);
    path.lineTo(rightOffset.dx, rightOffset.dy);
    path.lineTo(offset.dx + configuration.size!.width,
        offset.dy + configuration.size!.height);
    path.lineTo(offset.dx, offset.dy + configuration.size!.height);
    path.lineTo(leftOffset.dx, leftOffset.dy);

    path.close();
    canvas.drawPath(path, _paint);
  }
}
