import 'package:bear_necessities/generated/colors.gen.dart';
import 'package:flutter/material.dart';

/// Bear-paw shape based on the SVG icon (viewBox 0 0 17.77 25).
///
/// The SVG path is mapped 1-to-1 to a Flutter [Path]. Inside [paint] /
/// [getOuterPath] the path is scaled to fit the supplied [Rect] while
/// keeping the original aspect ratio (width/height = 17.77/25), and
/// horizontally centered so the visual weight matches the previous
/// implementation in dot decorators.
class BearFoot extends ShapeBorder {
  const BearFoot({this.size = 14, this.color = BearColors.bearBrown});

  final double size;
  final Color color;

  // ViewBox of the source SVG.
  static const double _svgWidth = 17.77;
  static const double _svgHeight = 25.0;

  Path _buildSvgPath() {
    // Direct port of the SVG `d` attribute. The first `m`/`c`/`l`/`h`
    // are relative; we keep an explicit cursor (cx, cy) so we can
    // express each segment as an absolute call on [Path].
    final Path path = Path();

    double cx = 8.88;
    double cy = 25.0;
    path.moveTo(cx, cy);

    void rCubic(double x1, double y1, double x2, double y2, double x, double y) {
      path.cubicTo(cx + x1, cy + y1, cx + x2, cy + y2, cx + x, cy + y);
      cx += x;
      cy += y;
    }

    void rLine(double dx, double dy) {
      path.relativeLineTo(dx, dy);
      cx += dx;
      cy += dy;
    }

    void rHorizontal(double dx) {
      path.relativeLineTo(dx, 0);
      cx += dx;
    }

    rCubic(2.6, -1, 4.45, -4.76, 4.76, -5.57);
    rCubic(0.31, -0.8, -0.31, -1.36, -1.23, -2.85);
    rCubic(-0.48, -0.76, -0.61, -1.35, -0.61, -1.8);
    rCubic(0, -0.45, 0.28, -1.2, 0.62, -1.23);
    rCubic(0.15, 0, 0.33, 0.22, 0.61, 0.83);
    rCubic(1.32, 2.97, 3.66, 2.47, 3.66, 2.47);
    rCubic(0, 0, 0.84, -1.66, 1.06, -4.17);
    rCubic(0.1, -1.19, -0.32, -1.93, -0.85, -2.4);
    rCubic(-0.58, -0.52, -2.39, -0.82, -2.41, -1.48);
    rCubic(0, -0.24, 0.18, -0.48, 1.01, -0.67);
    rCubic(2.03, -0.46, 1.98, -1.95, 1.1, -3.06);
    rCubic(-0.86, -1.09, -2.13, -1.46, -3.36, -1.48);
    rCubic(-2.25, -0.04, -3.46, 1.4, -4.11, 2.06);
    rLine(0.3, -5.65);
    rHorizontal(-1.11);
    rLine(0.3, 5.65);
    rCubic(-0.64, -0.67, -1.86, -2.1, -4.11, -2.06);
    rCubic(-1.22, 0.02, -2.5, 0.38, -3.36, 1.48);
    rCubic(-0.89, 1.11, -0.93, 2.6, 1.1, 3.06);
    rCubic(0.83, 0.18, 1.01, 0.43, 1.01, 0.67);
    rCubic(-0.02, 0.66, -1.83, 0.96, -2.41, 1.48);
    rCubic(-0.52, 0.47, -0.95, 1.21, -0.84, 2.4);
    rCubic(0.22, 2.51, 1.06, 4.17, 1.06, 4.17);
    rCubic(0, 0, 2.34, 0.51, 3.66, -2.47);
    rCubic(0.27, -0.61, 0.46, -0.83, 0.61, -0.83);
    rCubic(0.34, 0.03, 0.62, 0.78, 0.62, 1.23);
    rCubic(0, 0.45, -0.14, 1.04, -0.6, 1.8);
    rCubic(-0.93, 1.49, -1.55, 2.05, -1.24, 2.85);
    rCubic(0.31, 0.81, 2.17, 4.57, 4.77, 5.57);

    path.close();
    return path;
  }

  /// Returns the SVG path scaled & centered into [rect] while keeping
  /// the original viewBox aspect ratio.
  Path _getPath(Rect rect) {
    final Path basePath = _buildSvgPath();

    // Compute the largest axis-preserving scale that fits the path
    // within the available rect.
    final double scale = (rect.width / _svgWidth) < (rect.height / _svgHeight)
        ? rect.width / _svgWidth
        : rect.height / _svgHeight;

    final double drawnWidth = _svgWidth * scale;
    final double drawnHeight = _svgHeight * scale;
    final double dx = rect.left + (rect.width - drawnWidth) / 2;
    final double dy = rect.top + (rect.height - drawnHeight) / 2;

    final Matrix4 transform = Matrix4.identity()
      ..translateByDouble(dx, dy, 0, 1)
      ..scaleByDouble(scale, scale, 1, 1);

    return basePath.transform(transform.storage);
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(size);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      _getPath(rect);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      _getPath(rect);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final Path path = _getPath(rect);
    final Paint fill = Paint()
      ..style = PaintingStyle.fill
      ..color = color;
    canvas.drawPath(path, fill);
  }

  @override
  ShapeBorder scale(double t) => BearFoot(size: size * t, color: color);
}
