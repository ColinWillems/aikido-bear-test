import 'package:cached_network_image/cached_network_image.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FlipZoomCardView extends StatefulWidget {
  final CachedNetworkImage frontImage;
  final CachedNetworkImage reverseImage;
  final bool enableZoom;
  const FlipZoomCardView(
      {super.key,
      required this.frontImage,
      required this.reverseImage,
      this.enableZoom = false});

  @override
  FlipZoomCardViewState createState() => FlipZoomCardViewState();
}

class FlipZoomCardViewState extends State<FlipZoomCardView>
    with SingleTickerProviderStateMixin {
  late FlipCardController _flipCardController;
  late PhotoViewController _photoViewController;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();

    _flipCardController = FlipCardController();
    _photoViewController = PhotoViewController();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
            onPointerMove: (details) {
              final double xDelta = details.delta.dx.abs();
              final double yDelta = details.delta.dy.abs();
              if (xDelta > 0 && xDelta > yDelta) {
                if (_photoViewController.position.distance ==
                    _photoViewController.initial.position.distance) {
                  flipCard();
                }
              }
            },
            child: FlipCard(
              controller: _flipCardController,
              flipOnTouch: true,
              onFlip: () {
                _photoViewController.reset();
                if (_animationController != null) {
                  _animationController!.forward(from: 0);
                }
              },
              fill: Fill
                  .fillBack, // Fill the back side of the card to make in the same size as the front.
              direction: FlipDirection.HORIZONTAL, // default
              front: widget.enableZoom
                  ? PhotoView(
                      backgroundDecoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      controller: _photoViewController,
                      enableRotation: false,
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered * 2.0,
                      initialScale: PhotoViewComputedScale.contained,
                      basePosition: Alignment.center,
                      imageProvider: CachedNetworkImageProvider(
                          widget.frontImage.imageUrl,
                          cacheKey: widget.frontImage.cacheKey,
                          cacheManager: widget.frontImage.cacheManager),
                    )
                  : widget.frontImage,
              back: widget.enableZoom
                  ? PhotoView(
                      backgroundDecoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      controller: _photoViewController,
                      enableRotation: false,
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered * 2.0,
                      initialScale: PhotoViewComputedScale.contained,
                      basePosition: Alignment.center,
                      imageProvider: CachedNetworkImageProvider(
                          widget.reverseImage.imageUrl,
                          cacheKey: widget.reverseImage.cacheKey,
                          cacheManager: widget.reverseImage.cacheManager),
                    )
                  : widget.reverseImage,
            ))
        .animate(
            onPlay: ((controller) => _animationController = controller),
            delay: 0.2.seconds)
        .shimmer();
  }

  void flipCard() {
    _flipCardController.toggleCard();
  }
}
