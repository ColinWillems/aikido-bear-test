import 'package:bear_adventure_app/app/modules/cards/controllers/cards.controller.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardCounter extends StatelessWidget {
  const CardCounter({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final CardsController controller = Get.find<CardsController>();
      final String collectedCards = controller.collectedCards();

      return MaterialButton(
        padding: const EdgeInsets.all(0),
        onPressed: () {},
        child: Container(
          padding: const EdgeInsets.only(left: 4, right: 4, top: 8, bottom: 8),
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fitHeight,
              image: BearAssets.images.global.navBar.cardCounterPng
                  .image(
                    package: BearApp.bearNecessities,
                    centerSlice: const Rect.fromLTRB(3, 3, 3, 10),
                    fit: BoxFit.contain,
                  )
                  .image,
            ),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                collectedCards,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 0.8,
                ),
              ),
              Flexible(
                child: BearAssets.images.global.icons.cardCountIcon.image(
                    package: BearApp.bearNecessities, fit: BoxFit.contain),
              ),
            ],
          ),
        ),
      );
    });
  }
}
