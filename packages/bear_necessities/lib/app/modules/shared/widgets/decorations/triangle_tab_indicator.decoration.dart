import 'package:flutter/material.dart';

class TriangleTabIndicator extends Decoration {
  final BoxPainter _painter;

  TriangleTabIndicator({required Color color, required double radius})
      : _painter = DrawTriangle(color);

  @override
  BoxPainter createBoxPainter([void onChanged]) => _painter;
}

class DrawTriangle extends BoxPainter {
  late Paint _paint;

  DrawTriangle(Color color) {
    _paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    if (configuration.size == null) {
      return;
    }

    final Offset triangleOffset = offset +
        Offset(configuration.size!.width / 2, configuration.size!.height - 14);
    var path = Path();

    path.moveTo(triangleOffset.dx, triangleOffset.dy);
    path.lineTo(triangleOffset.dx + 8, triangleOffset.dy + 14);
    path.lineTo(triangleOffset.dx - 8, triangleOffset.dy + 14);

    path.close();
    canvas.drawPath(path, _paint);
  }
}
