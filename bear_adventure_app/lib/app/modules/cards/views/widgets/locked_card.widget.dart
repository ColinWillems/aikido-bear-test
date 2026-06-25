import 'package:bear_necessities/bear_necessities.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_app_utils/firebase_app_utils.dart';
import 'package:flutter/material.dart' hide Card;

class LockedCard extends StatelessWidget {
  const LockedCard({super.key, required this.card, required this.baseUrl});
  final Card card;
  final String baseUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: (card.lockedImagePath.isEmpty)
          ? Opacity(
              opacity: 0.5,
              child: Container(
                constraints: const BoxConstraints.expand(),
                color: Colors.grey,
              ))
          : CachedNetworkImage(
              cacheManager: FirebaseCacheManager(),
              imageUrl: "$baseUrl${card.lockedImagePath}",
              fit: BoxFit.contain,
              placeholder: (context, url) => Opacity(
                opacity: 0.3,
                child: Container(
                  constraints: const BoxConstraints.expand(),
                  color: Colors.grey,
                ),
              ),
              errorWidget: (context, url, error) => Opacity(
                opacity: 0.5,
                child: Container(
                  constraints: const BoxConstraints.expand(),
                  color: Colors.red,
                ),
              ),
            ),
    );
  }
}
