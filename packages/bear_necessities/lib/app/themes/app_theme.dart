import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AppThemes {
  AppThemes._();

  static final AppLayout appLayout = AppLayout(
    maxWidth: 375,
    padding: AppPadding(
      padding: const AppInsets(
        xs: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        sm: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        md: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        lg: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        xl: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    ),
    scaleFactors: {
      'default': 1.08,
      MOBILE: 1.08,
      TABLET: 1.08,
      'LARGE_TABLET': 1.49,
      'SMALL_DESKTOP': 1.76,
      DESKTOP: 2,
      '4K': 2
    },
  );

  static final TextTheme textTheme = Typography.material2021().white.copyWith(
        headlineLarge: AppTextStyles.ursa.s56.hTitle,
        headlineMedium: AppTextStyles.ursa.s48.hTitle,
        headlineSmall: AppTextStyles.ursa.s30.hSubtitle,
        titleLarge: AppTextStyles.ursa.s22.hSubtitle,
        titleMedium: AppTextStyles.ursa.s20.hSubtitle,
        titleSmall: AppTextStyles.ursa.s16.hSubtitle,
        displayLarge: AppTextStyles.ursa.s35.w400.hTitle,
        displayMedium: AppTextStyles.ursa.s26.w400.hTitle,
        displaySmall: AppTextStyles.ursa.s20.w400.hTitle,
        bodyLarge: AppTextStyles.ursa.s27.w400.hTitle,
        bodyMedium: AppTextStyles.ursa.s14.hParagraph,
        bodySmall: AppTextStyles.ursa.s13.hParagraph,
        labelLarge: AppTextStyles.ursa.s27.hTitle,
        labelMedium: AppTextStyles.ursa.s20.hTitle,
        labelSmall: AppTextStyles.ursa.s14.hTitle,
      );

  static const ColorScheme colorScheme = ColorScheme.light(
    primary: BearColors.bearGreen,
    onPrimary: BearColors.creamWhite,
    primaryContainer: BearColors.bearGreen,
    onPrimaryContainer: BearColors.creamWhite,
    secondary: BearColors.bearRed,
    onSecondary: BearColors.creamWhite,
    secondaryContainer: BearColors.bearRed,
    onSecondaryContainer: BearColors.creamWhite,
    tertiary: BearColors.bearCards,
    onTertiary: BearColors.creamWhite,
    tertiaryContainer: BearColors.bearCards,
    onTertiaryContainer: BearColors.creamWhite,
    surface: BearColors.bearGreen,
    onSurface: BearColors.creamWhite,
  );
  static final ThemeData themeData = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      cupertinoOverrideTheme: const CupertinoThemeData(
        textTheme: CupertinoTextThemeData(), // This is required
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: textTheme,
      listTileTheme: ListTileThemeData(
        titleTextStyle: AppThemes.textTheme.displayMedium!.s22.hTitle,
        subtitleTextStyle: AppThemes.textTheme.bodyMedium,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        titleSpacing: 0,
        titleTextStyle: AppThemes.textTheme.titleMedium,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarTextStyle: AppThemes.textTheme.titleMedium,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: BearColors.bearGreen,
        titleTextStyle: AppThemes.textTheme.titleMedium!.w900.hTitle,
        contentTextStyle: AppThemes.textTheme.bodyMedium!.s16,
        actionsPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        alignment: Alignment.center,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: BearColors.bearGreen,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) {
              return BearColors.creamWhite;
            },
          ),
          textStyle: WidgetStateProperty.resolveWith(
            (states) {
              return AppThemes.textTheme.displayMedium!.s16.whiteColor;
            },
          ),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: textTheme.bodyLarge,
        unselectedLabelStyle: textTheme.bodyLarge,
      ),
      bottomAppBarTheme: const BottomAppBarThemeData(
        shape: AutomaticNotchedShape(RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)))),
      ),
      navigationBarTheme:
          const NavigationBarThemeData(backgroundColor: Colors.transparent),
      chipTheme: const ChipThemeData(
        backgroundColor: BearColors.creamWhite,
        padding: EdgeInsets.only(left: 7, right: 7, top: 6, bottom: 6),
        labelPadding: EdgeInsets.only(left: 6, top: 3),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6))),
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return BearColors.creamWhite;
          }
          return Colors.transparent;
        }),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (!states.contains(WidgetState.disabled)) {
            return Colors.black.withOpacity(0.25);
          }
          return null;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (!states.contains(WidgetState.disabled)) {
            return Colors.black.withOpacity(0.25);
          }
          return null;
        }),
        side: BorderSide(width: 8.5, color: Colors.black.withOpacity(0.25)),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
      ),
      snackBarTheme: const SnackBarThemeData(
          actionTextColor: BearColors.creamWhite,
          backgroundColor: BearColors.bearRed,
          behavior: SnackBarBehavior.fixed,
          contentTextStyle: TextStyle(
            color: BearColors.creamWhite,
          )),
      bannerTheme: MaterialBannerThemeData(
        backgroundColor: Colors.transparent,
        dividerColor: Colors.transparent,
        contentTextStyle: textTheme.displayMedium,
        padding: const EdgeInsets.only(left: 10, right: 2),
      ));
}
