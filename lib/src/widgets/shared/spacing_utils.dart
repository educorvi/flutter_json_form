import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/utils/layout_direction.dart';
import 'package:flutter_json_forms/src/widgets/constants.dart';

/// Utility class for handling consistent spacing between form elements
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
          // Use custom spacing builder if provided
          allWidgets.add(spacingBuilder(item, i, isVisible, hasVisibleElement));
        } else {
          // Use default spacing
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

      // Track if we have a visible element for next iteration
      if (isVisible) {
        hasVisibleElement = true;
      }

      // Always create and add the widget
      allWidgets.add(widgetBuilder(item, i));
    }

    return allWidgets;
  }

  /// Simplified version for layout elements (FormGroup/FormLayout)
  static List<Widget> buildLayoutElementsWithSpacing({
    required BuildContext context,
    required List<dynamic> elements, // ui.LayoutElement
    required Widget Function(dynamic element, int index) widgetBuilder,
    required bool Function(dynamic element, int index) isVisibleChecker,
    LayoutDirection layoutDirection = LayoutDirection.vertical,
    double spacing = UIConstants.elementSpacing,
  }) {
    return buildWidgetsWithSpacing<dynamic>(
      items: elements,
      widgetBuilder: widgetBuilder,
      isVisibleChecker: isVisibleChecker,
      layoutDirection: layoutDirection,
      spacing: spacing,
    );
  }

  /// Specialized version for object properties
  static List<Widget> buildObjectPropertiesWithSpacing({
    required BuildContext context,
    required List<String> propertyKeys,
    required Widget Function(String key, int index) widgetBuilder,
    required bool Function(String key, int index) isVisibleChecker,
    double spacing = UIConstants.elementSpacing,
  }) {
    return buildWidgetsWithSpacing<String>(
      items: propertyKeys,
      widgetBuilder: widgetBuilder,
      isVisibleChecker: isVisibleChecker,
      layoutDirection: LayoutDirection.vertical,
      spacing: spacing,
    );
  }

  /// Specialized version for array items with custom spacing widgets
  static List<Widget> buildArrayItemsWithSpacing<T>({
    required List<T> items,
    required Widget Function(T item, int index) widgetBuilder,
    required bool Function(T item, int index) isVisibleChecker,
    required Widget Function(T item, int index) spacingWidgetBuilder,
    double spacing = UIConstants.elementSpacing,
  }) {
    return buildWidgetsWithSpacing<T>(
      items: items,
      widgetBuilder: widgetBuilder,
      isVisibleChecker: isVisibleChecker,
      layoutDirection: LayoutDirection.vertical,
      spacing: spacing,
      spacingBuilder: (item, index, isVisible, hasVisibleElement) {
        // For arrays, we need the custom spacing widget but with dynamic height
        final spacingWidget = spacingWidgetBuilder(item, index);

        // If it's a Container, modify its height
        if (spacingWidget is Container) {
          return SizedBox(
            key: spacingWidget.key,
            height: (isVisible && hasVisibleElement) ? spacing : 0.0,
            width: spacingWidget.constraints?.maxWidth,
            child: spacingWidget.child,
          );
        }

        // Fallback to regular SizedBox
        return SizedBox(
          height: (isVisible && hasVisibleElement) ? spacing : 0.0,
        );
      },
    );
  }
}
