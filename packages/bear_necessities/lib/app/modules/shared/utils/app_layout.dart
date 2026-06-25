import 'package:bear_necessities/app/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

enum LayoutSize {
  xs,
  sm,
  md,
  lg,
  xl,
}

class AppLayout {
  AppLayout({
    required this.padding,
    required this.maxWidth,
    required this.scaleFactors,
  }) {
    final context = Get.context!;
    _maxViewWidth = ResponsiveValue<double>(context,
        defaultValue: maxWidth / scaleFactors['default']!,
        conditionalValues: [
          Condition.equals(
              name: MOBILE, value: maxWidth / scaleFactors[MOBILE]!),
          Condition.equals(
              name: TABLET, value: maxWidth / scaleFactors[TABLET]!),
          Condition.equals(
              name: 'LARGE_TABLET',
              value: maxWidth / scaleFactors['LARGE_TABLET']!),
          Condition.equals(
              name: 'SMALL_DESKTOP',
              value: maxWidth / scaleFactors['SMALL_DESKTOP']!),
          Condition.equals(
              name: DESKTOP, value: maxWidth / scaleFactors[DESKTOP]!),
          Condition.equals(name: '4K', value: maxWidth / scaleFactors['4K']!),
        ]).value;
  }

  final AppPadding padding;
  final double maxWidth;

  final Map<String, double> scaleFactors;

  double _maxViewWidth = 0;

  double get maxViewWidth {
    return _maxViewWidth;
  }
}

class AppPadding {
  AppPadding({
    this.padding = AppInsets.defaultInsets,
  });

  final AppInsets padding;

  static const double minPadding = 12;

  double get scaledMinPadding {
    final scaleFactors = AppThemes.appLayout.scaleFactors;
    return minPadding / scaleFactors[MOBILE]!;
  }

  EdgeInsets _getPadding({LayoutSize size = LayoutSize.xs}) {
    final context = Get.context!;
    final scaleFactors = AppThemes.appLayout.scaleFactors;
    final double scaledViewWidth = ResponsiveValue<double>(
      context,
      defaultValue: context.width / scaleFactors['default']!,
      conditionalValues: [
        Condition.equals(
          name: MOBILE,
          value: context.width / scaleFactors[MOBILE]!,
        ),
        Condition.equals(
          name: TABLET,
          value: context.width / scaleFactors[TABLET]!,
        ),
        Condition.equals(
          name: 'LARGE_TABLET',
          value: context.width / scaleFactors['LARGE_TABLET']!,
        ),
        Condition.equals(
          name: 'SMALL_DESKTOP',
          value: context.width / scaleFactors['SMALL_DESKTOP']!,
        ),
        Condition.equals(
          name: DESKTOP,
          value: context.width / scaleFactors[DESKTOP]!,
        ),
        Condition.equals(
          name: '4K',
          value: context.width / scaleFactors['4K']!,
        ),
      ],
    ).value;

    AppInsets insets = ResponsiveValue<AppInsets>(
      context,
      defaultValue: AppInsets(
        xs: EdgeInsets.symmetric(
            horizontal:
                (scaledViewWidth - AppThemes.appLayout.maxViewWidth) / 2),
        sm: EdgeInsets.symmetric(
            horizontal:
                (scaledViewWidth - AppThemes.appLayout.maxViewWidth) / 2),
        md: EdgeInsets.symmetric(
            horizontal:
                (scaledViewWidth - AppThemes.appLayout.maxViewWidth) / 2),
        lg: EdgeInsets.symmetric(
            horizontal:
                (scaledViewWidth - AppThemes.appLayout.maxViewWidth) / 2),
        xl: EdgeInsets.symmetric(
            horizontal:
                (scaledViewWidth - AppThemes.appLayout.maxViewWidth) / 2),
      ),
      conditionalValues: [
        Condition.equals(
          name: MOBILE,
          value: AppInsets(
            xs: EdgeInsets.symmetric(
                horizontal: AppPadding.minPadding / scaleFactors[MOBILE]!),
            sm: EdgeInsets.symmetric(
                horizontal: AppPadding.minPadding / scaleFactors[MOBILE]!),
            md: EdgeInsets.symmetric(
                horizontal: AppPadding.minPadding / scaleFactors[MOBILE]!),
            lg: EdgeInsets.symmetric(
                horizontal: AppPadding.minPadding / scaleFactors[MOBILE]!),
            xl: EdgeInsets.symmetric(
                horizontal: AppPadding.minPadding / scaleFactors[MOBILE]!),
          ),
        ),
      ],
    ).value;

    switch (size) {
      case LayoutSize.xs:
        return insets.xs;
      case LayoutSize.sm:
        return insets.sm;
      case LayoutSize.md:
        return insets.md;
      case LayoutSize.lg:
        return insets.lg;
      case LayoutSize.xl:
        return insets.xl;
    }
  }

  EdgeInsets get xs {
    return _getPadding(size: LayoutSize.xs);
  }

  EdgeInsets get sm {
    return _getPadding(size: LayoutSize.sm);
  }

  EdgeInsets get md {
    return _getPadding(size: LayoutSize.md);
  }

  EdgeInsets get lg {
    return _getPadding(size: LayoutSize.lg);
  }

  EdgeInsets get xl {
    return _getPadding(size: LayoutSize.xl);
  }
}

class AppInsets {
  const AppInsets(
      {this.xs = EdgeInsets.zero,
      this.sm = EdgeInsets.zero,
      this.md = EdgeInsets.zero,
      this.lg = EdgeInsets.zero,
      this.xl = EdgeInsets.zero});

  static const AppInsets defaultInsets = AppInsets();

  final EdgeInsets xs;
  final EdgeInsets sm;
  final EdgeInsets md;
  final EdgeInsets lg;
  final EdgeInsets xl;
}
