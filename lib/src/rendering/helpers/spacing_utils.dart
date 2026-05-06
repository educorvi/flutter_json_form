import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/rendering/default_renderer/constants.dart';

/// Axis along which form elements are arranged.
enum LayoutDirection { vertical, horizontal }

/// Utility class for handling consistent spacing between form elements.
class SpacingUtils {
  /// Builds a list of widgets with consistent spacing logic
  ///
  /// This ensures stable widget trees by always creating spacing widgets
  /// with dynamic sizing based on visibility conditions.
  static List<Widget> buildWidgetsWithSpacing<T>({
    required List<T> items,
    required Widget Function(T item, int index) widgetBuilder,
    required bool Function(T item, int index) isVisibleChecker,
    LayoutDirection layoutDirection = LayoutDirection.vertical,
    double spacing = UIConstants.elementSpacing,
    Widget Function(T item, int index, bool isVisible, bool hasVisibleElement)? spacingBuilder,
  }) {
    final List<Widget> allWidgets = [];
    bool hasVisibleElement = false;

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final isVisible = isVisibleChecker(item, i);

      // Always add spacing widget, but with zero size if not needed
      if (i > 0) {
        if (spacingBuilder != null) {
          allWidgets.add(spacingBuilder(item, i, isVisible, hasVisibleElement));
        } else {
          if (layoutDirection == LayoutDirection.vertical) {
            allWidgets.add(SizedBox(
              height: (isVisible && hasVisibleElement) ? spacing : 0.0,
            ));
          } else {
            allWidgets.add(SizedBox(
              width: (isVisible && hasVisibleElement) ? spacing : 0.0,
            ));
          }
        }
      }

      // Track if we there is a visible element for the next iteration
      if (isVisible) {
        hasVisibleElement = true;
      }

      allWidgets.add(widgetBuilder(item, i));
    }

    return allWidgets;
  }
}
