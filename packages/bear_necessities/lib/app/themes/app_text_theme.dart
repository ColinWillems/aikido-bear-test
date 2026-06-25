import 'package:bear_necessities/bear_necessities.dart';

import 'package:flutter/material.dart';
import 'package:tinycolor2/tinycolor2.dart';

class AppTextStyles {
  AppTextStyles._();
  static const TextStyle base = TextStyle(
    inherit: true,
    fontSize: 16,
    color: Color.fromRGBO(255, 252, 240, 1),
    fontFeatures: <FontFeature>[
      FontFeature.disable("calt"),
    ],
  );
  static TextStyle ursa = base.ursa;
}

extension AppFontFamilies on TextStyle {
  TextStyle get ursa => AppTextStyles.base.copyWith(
        inherit: true,
        fontFamily: BearFonts.ursa,
        fontWeight: FontWeight.w900,
        height: 1,
      );
}

extension AppFontUsages on TextStyle {
  TextStyle get button => copyWith(
        inherit: true,
      ).ursa.s20.hTitle;
  TextStyle get decoratedText => copyWith(
        inherit: true,
      ).ursa.s92.hTitle;
  TextStyle get decoratedButtonText => copyWith(
        inherit: true,
      ).ursa.s27.hTitle;
  TextStyle get decoratedTitle => copyWith(
        inherit: true,
      ).ursa.s60.hTitle;
}

extension AppFontShadows on TextStyle {
  TextStyle get raised => copyWith(inherit: true, shadows: [
        Shadow(
          color: Colors.black.withOpacity(0.25),
          offset: const Offset(5, 5),
          blurRadius: 0,
        ),
      ]);
  TextStyle get threeD => copyWith(inherit: true, shadows: [
        Shadow(
          color: BearColors.bearBrown.darken(10),
          offset: const Offset(1, -3),
          blurRadius: 0,
        ),
        Shadow(
          color: BearColors.bearBrown.darken(10),
          offset: const Offset(2, -2),
          blurRadius: 0,
        ),
        Shadow(
          color: BearColors.bearBrown.darken(10),
          offset: const Offset(3, -1),
          blurRadius: 0,
        ),
        Shadow(
          color: BearColors.bearBrown.darken(10),
          offset: const Offset(4, 0),
          blurRadius: 0,
        ),
        Shadow(
          color: BearColors.bearBrown.darken(10),
          offset: const Offset(5, 1),
          blurRadius: 0,
        ),
        Shadow(
          color: BearColors.bearBrown.darken(10),
          offset: const Offset(6, 2),
          blurRadius: 0,
        ),
        Shadow(
          color: BearColors.bearBrown.darken(10),
          offset: const Offset(7, 3),
          blurRadius: 0,
        ),
        Shadow(
          color: BearColors.bearBrown.darken(10),
          offset: const Offset(8, 4),
          blurRadius: 0,
        ),
        Shadow(
          color: BearColors.bearBrown.darken(10),
          offset: const Offset(9, 5),
          blurRadius: 0,
        ),
        Shadow(
          color: BearColors.bearBrown.darken(10),
          offset: const Offset(-3, 1),
          blurRadius: 0,
        ),
        Shadow(
          color: BearColors.bearBrown.darken(10),
          offset: const Offset(-2, 2),
          blurRadius: 0,
        ),
        Shadow(
          color: BearColors.bearBrown.darken(10),
          offset: const Offset(-1, 3),
          blurRadius: 0,
        ),
        Shadow(
          color: BearColors.bearBrown.darken(10),
          offset: const Offset(0, 4),
          blurRadius: 0,
        ),
        Shadow(
          color: BearColors.bearBrown.darken(10),
          offset: const Offset(1, 5),
          blurRadius: 0,
        ),
        Shadow(
          color: BearColors.bearBrown.darken(10),
          offset: const Offset(2, 6),
          blurRadius: 0,
        ),
        Shadow(
          color: BearColors.bearBrown.darken(10),
          offset: const Offset(3, 7),
          blurRadius: 0,
        ),
        Shadow(
          color: BearColors.bearBrown.darken(10),
          offset: const Offset(4, 8),
          blurRadius: 0,
        ),
        Shadow(
          color: BearColors.bearBrown.darken(10),
          offset: const Offset(5, 9),
          blurRadius: 0,
        ),
        Shadow(
          color: BearColors.bearBrown.darken(10),
          offset: const Offset(1, 1),
          blurRadius: 0,
        ),
        Shadow(
          color: BearColors.bearBrown.darken(10),
          offset: const Offset(2, 2),
          blurRadius: 0,
        ),
        Shadow(
          color: BearColors.bearBrown.darken(10),
          offset: const Offset(3, 3),
          blurRadius: 0,
        ),
        Shadow(
          color: BearColors.bearBrown.darken(10),
          offset: const Offset(4, 4),
          blurRadius: 0,
        ),
        Shadow(
          color: BearColors.bearBrown.darken(10),
          offset: const Offset(5, 5),
          blurRadius: 0,
        ),
        Shadow(
          color: BearColors.bearBrown.darken(10),
          offset: const Offset(6, 6),
          blurRadius: 0,
        ),
        Shadow(
          color: BearColors.bearBrown.darken(10),
          offset: const Offset(7, 7),
          blurRadius: 0,
        ),
        Shadow(
          color: BearColors.bearBrown.darken(10),
          offset: const Offset(8, 8),
          blurRadius: 0,
        ),
        Shadow(
          color: BearColors.bearBrown.darken(10),
          offset: const Offset(9, 9),
          blurRadius: 0,
        ),
      ]);
  TextStyle get flat => copyWith(shadows: null);
}

extension AppFontHeight on TextStyle {
  TextStyle get hTitle => copyWith(
        inherit: true,
        height: 1,
      );
  TextStyle get hSubtitle => copyWith(
        inherit: true,
        height: 1.1,
      );
  TextStyle get hParagraph => copyWith(
        inherit: true,
        height: 1.2,
      );
}

extension AppFontWeight on TextStyle {
  /// FontWeight.w100
  TextStyle get w100 => copyWith(
        inherit: true,
        fontWeight: FontWeight.w100,
      );

  /// FontWeight.w200
  TextStyle get w200 => copyWith(
        inherit: true,
        fontWeight: FontWeight.w200,
      );

  /// FontWeight.w300
  TextStyle get w300 => copyWith(
        inherit: true,
        fontWeight: FontWeight.w300,
      );

  /// FontWeight.w400
  TextStyle get w400 => copyWith(
        inherit: true,
        fontWeight: FontWeight.w400,
      );

  /// FontWeight.w500
  TextStyle get w500 => copyWith(
        inherit: true,
        fontWeight: FontWeight.w500,
      );

  /// FontWeight.w600
  TextStyle get w600 => copyWith(
        inherit: true,
        fontWeight: FontWeight.w600,
      );

  /// FontWeight.w700
  TextStyle get w700 => copyWith(
        inherit: true,
        fontWeight: FontWeight.w700,
      );

  /// FontWeight.w800
  TextStyle get w800 => copyWith(
        inherit: true,
        fontWeight: FontWeight.w800,
      );

  /// FontWeight.w900
  TextStyle get w900 => copyWith(
        inherit: true,
        fontWeight: FontWeight.w900,
      );
}

extension AppFontSize on TextStyle {
  /// fontSize: 10
  TextStyle get s10 => copyWith(
        inherit: true,
        fontSize: 10,
      );

  /// fontSize: 11
  TextStyle get s11 => copyWith(
        inherit: true,
        fontSize: 11,
      );

  /// fontSize: 12
  TextStyle get s12 => copyWith(
        inherit: true,
        fontSize: 12,
      );

  /// fontSize: 13
  TextStyle get s13 => copyWith(
        inherit: true,
        fontSize: 13,
      );

  /// fontSize: 14
  TextStyle get s14 => copyWith(
        inherit: true,
        fontSize: 14,
      );

  /// fontSize: 16
  TextStyle get s16 => copyWith(
        inherit: true,
        fontSize: 16,
      );

  /// fontSize: 18
  TextStyle get s18 => copyWith(
        inherit: true,
        fontSize: 18,
      );

  /// fontSize: 20
  TextStyle get s20 => copyWith(
        inherit: true,
        fontSize: 20,
      );

  /// fontSize: 22
  TextStyle get s22 => copyWith(
        inherit: true,
        fontSize: 22,
      );

  /// fontSize: 24
  TextStyle get s24 => copyWith(
        inherit: true,
        fontSize: 24,
      );

  /// fontSize: 26
  TextStyle get s26 => copyWith(
        inherit: true,
        fontSize: 26,
      );

  /// fontSize: 27
  TextStyle get s27 => copyWith(
        inherit: true,
        fontSize: 27,
      );

  /// fontSize: 30
  TextStyle get s30 => copyWith(
        inherit: true,
        fontSize: 30,
      );

  /// fontSize: 32
  TextStyle get s32 => copyWith(
        inherit: true,
        fontSize: 32,
      );

  /// fontSize: 35
  TextStyle get s35 => copyWith(
        inherit: true,
        fontSize: 35,
      );

  /// fontSize: 40
  TextStyle get s40 => copyWith(
        inherit: true,
        fontSize: 40,
      );

  /// fontSize: 48
  TextStyle get s48 => copyWith(
        inherit: true,
        fontSize: 48,
      );

  TextStyle get s60 => copyWith(
        inherit: true,
        fontSize: 60,
      );

  TextStyle get s54 => copyWith(
        inherit: true,
        fontSize: 54,
      );

  TextStyle get s56 => copyWith(
        inherit: true,
        fontSize: 56,
      );

  TextStyle get s68 => copyWith(
        inherit: true,
        fontSize: 68,
      );
  TextStyle get s92 => copyWith(
        inherit: true,
        fontSize: 76,
      );
}

extension AppFontColor on TextStyle {
  TextStyle get whiteColor => copyWith(
        inherit: true,
        color: BearColors.creamWhite,
      );

  TextStyle get transparentWhiteColor => copyWith(
        inherit: true,
        color: BearColors.creamWhite.withOpacity(0.5),
      );

  TextStyle get blackColor => copyWith(
        inherit: true,
        color: Colors.black,
      );

  TextStyle get primaryColor => copyWith(
        inherit: true,
        color: BearColors.bearGreen,
      );

  TextStyle get yellowColor => copyWith(
        inherit: true,
        color: BearColors.bearActionButton,
      );
  TextStyle get redColor => copyWith(
        inherit: true,
        color: BearColors.bearRed,
      );
  TextStyle get greenColor => copyWith(
        inherit: true,
        color: BearColors.bearGreen,
      );
  TextStyle get brownColor => copyWith(
        inherit: true,
        color: BearColors.bearBrown,
      );
  TextStyle get darkBrownColor => copyWith(
        inherit: true,
        color: BearColors.bearLogo,
      );
  TextStyle get errorColor => copyWith(
        inherit: true,
        color: Colors.red.shade900,
      );
}

extension AppFontStyle on TextStyle {
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);
}

extension AppFontDecoration on TextStyle {
  TextStyle get overline => copyWith(decoration: TextDecoration.overline);

  TextStyle get underline => copyWith(decoration: TextDecoration.underline);

  TextStyle get noneDecoration => copyWith(decoration: TextDecoration.none);

  TextStyle get lineThrough => copyWith(decoration: TextDecoration.lineThrough);
}
