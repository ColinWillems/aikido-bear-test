import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart';

/// A dropdown form field whose closed-state field is styled to match
/// [AppTextFormField] / [AppInputDecoration].
///
/// The open menu uses Flutter's default `DropdownButtonFormField` styling,
/// which is fully keyboard-accessible out of the box (focusable, openable
/// with Enter/Space, navigable with arrow keys, dismissable with Escape).
class AppDropdownFormField<T> extends StatelessWidget {
  const AppDropdownFormField({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.decoration,
    this.style,
    this.hint,
    this.validator,
    this.focusNode,
    this.autofocus = false,
    this.menuItemPadding,
  });

  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final InputDecoration? decoration;
  final TextStyle? style;
  final Widget? hint;
  final String? Function(T?)? validator;
  final FocusNode? focusNode;
  final bool autofocus;

  /// Horizontal padding applied to each item in the open menu. Defaults to
  /// [EdgeInsets.zero] (Flutter's default `_kMenuItemPadding` already adds
  /// 16 px on each side). Pass the page's outer horizontal padding here to
  /// align the text with the rest of the layout.
  final EdgeInsetsGeometry? menuItemPadding;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TextStyle effectiveStyle = style ??
        textTheme.displayMedium?.s27.copyWith(color: BearColors.bearBrown) ??
        const TextStyle(color: BearColors.bearBrown);

    final List<DropdownMenuItem<T>> effectiveItems = items
        .map(
          (DropdownMenuItem<T> item) => DropdownMenuItem<T>(
            value: item.value,
            enabled: item.enabled,
            alignment: Alignment.center,
            onTap: item.onTap,
            child: menuItemPadding == null
                ? item.child
                : Padding(
                    padding: menuItemPadding!,
                    child: item.child,
                  ),
          ),
        )
        .toList();

    // Pin decoration values that would otherwise change between the field's
    // unfocused/empty and focused/non-empty states, which is what causes the
    // surrounding layout to shift the first time the dropdown is opened.
    final InputDecoration baseDecoration =
        decoration ?? const AppInputDecoration();
    final InputDecoration effectiveDecoration = baseDecoration.copyWith(
      floatingLabelBehavior:
          baseDecoration.floatingLabelBehavior ?? FloatingLabelBehavior.never,
      contentPadding: baseDecoration.contentPadding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      isDense: baseDecoration.isDense ?? false,
    );

    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButtonFormField<T>(
        initialValue: value,
        items: effectiveItems,
        onChanged: onChanged,
        validator: validator,
        focusNode: focusNode,
        autofocus: autofocus,
        hint: hint,
        isExpanded: true,
        alignment: Alignment.center,
        style: effectiveStyle,
        iconEnabledColor: BearColors.bearBrown,
        iconDisabledColor: BearColors.bearBrown,
        dropdownColor: const Color(0xFFF6EDD2),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        decoration: effectiveDecoration,
      ),
    );
  }
}
