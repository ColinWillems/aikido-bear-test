import 'dart:math';

import 'package:bear_necessities/app/modules/shared/widgets/animation_controller.state.dart';
import 'package:flutter/material.dart';

class PushableButton extends StatefulWidget {
  const PushableButton({
    super.key,
    this.child,
    required this.color,
    this.height,
    this.elevation = defaultElevation,
    this.pressedElevation = defaultPressedElevation,
    this.selectedElevation = defaultSelectedElevation,
    this.selected = false,
    this.shadow,
    this.borderRadius,
    this.tooltip,
    this.onPressed,
  });

  static const double defaultElevation = 8;
  static const double defaultPressedElevation = 1;
  static const double defaultSelectedElevation = 4;

  /// child widget (normally a Text or Icon)
  final Widget? child;

  /// Color of the top layer
  /// The color of the bottom layer is derived by decreasing the luminosity by 0.15
  final Color color;

  /// height of the top layer
  final double? height;

  /// what portion of the button's height it should be elevated by (e.g 0.1 will be 10% of the buttons height)
  final double elevation;

  // the minimum elevation when the button is pushed
  final double pressedElevation;

  // the elevation when the button is selected
  final double selectedElevation;

  /// Whether the button is in the selected state
  final bool selected;

  /// An optional shadow to make the button look better
  /// This is added to the bottom layer only
  final BoxShadow? shadow;

  final double? borderRadius;

  final String? tooltip;

  /// button pressed callback
  final VoidCallback? onPressed;

  bool get enabled {
    return onPressed != null;
  }

  @override
  PushableButtonState createState() => PushableButtonState();
}

class PushableButtonState extends AnimationControllerState<PushableButton> {
  PushableButtonState() : super(const Duration(milliseconds: 100));

  final bool _isDragInProgress = false;

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null) {
      animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onPressed != null) {
      animationController.reverse();
      widget.onPressed?.call();
    }
  }

  void _handleTapCancel() {
    Future.delayed(super.animationDuration, () {
      if (!_isDragInProgress && mounted) {
        animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.height != null) {
      return _buildFixedHeight();
    }
    return _buildIntrinsicHeight();
  }

  Widget _buildFixedHeight() {
    final double totalHeight = widget.height! + widget.elevation;
    final double buttonHeight = widget.height!;
    final double radius = (widget.borderRadius != null)
        ? widget.borderRadius!
        : buttonHeight / 2;

    Widget container = SizedBox(
      height: totalHeight,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            final double opacity = widget.onPressed != null ? 1 : 0.5;
            final double top = widget.selected
                ? widget.elevation - widget.selectedElevation
                : min(animationController.value * widget.elevation,
                    widget.elevation - widget.pressedElevation);
            final hslColor = HSLColor.fromColor(widget.color);
            final bottomHslColor =
                hslColor.withLightness(hslColor.lightness - 0.15);
            return Opacity(
                opacity: opacity,
                child: Stack(
                  children: [
                    // Draw bottom layer first
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: totalHeight - top,
                        decoration: BoxDecoration(
                          color: bottomHslColor.toColor(),
                          boxShadow:
                              widget.shadow != null ? [widget.shadow!] : [],
                          borderRadius: BorderRadius.circular(radius),
                        ),
                      ),
                    ),
                    // Then top (pushable) layer
                    Positioned(
                      left: 0,
                      right: 0,
                      top: top,
                      child: Container(
                        height: buttonHeight,
                        decoration: BoxDecoration(
                          color: hslColor.toColor(),
                          borderRadius: BorderRadius.circular(radius),
                        ),
                        child: widget.child,
                      ),
                    ),
                  ],
                ));
          },
        ),
      ),
    );
    if (widget.tooltip != null) {
      container = Tooltip(message: widget.tooltip, child: container);
    }
    return container;
  }

  Widget _buildIntrinsicHeight() {
    Widget container = GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          final double opacity = widget.onPressed != null ? 1 : 0.5;
          final double top = widget.selected
              ? widget.elevation - widget.selectedElevation
              : min(animationController.value * widget.elevation,
                  widget.elevation - widget.pressedElevation);
          final hslColor = HSLColor.fromColor(widget.color);
          final bottomHslColor =
              hslColor.withLightness(hslColor.lightness - 0.15);
          final double radius = widget.borderRadius ?? 20;
          return Opacity(
            opacity: opacity,
            child: Padding(
              padding: EdgeInsets.only(top: top),
              child: Container(
                decoration: BoxDecoration(
                  color: bottomHslColor.toColor(),
                  boxShadow: widget.shadow != null ? [widget.shadow!] : [],
                  borderRadius: BorderRadius.circular(radius),
                ),
                padding: EdgeInsets.only(bottom: widget.elevation - top),
                child: Container(
                  decoration: BoxDecoration(
                    color: hslColor.toColor(),
                    borderRadius: BorderRadius.circular(radius),
                  ),
                  child: widget.child,
                ),
              ),
            ),
          );
        },
      ),
    );
    if (widget.tooltip != null) {
      container = Tooltip(message: widget.tooltip, child: container);
    }
    return container;
  }
}
