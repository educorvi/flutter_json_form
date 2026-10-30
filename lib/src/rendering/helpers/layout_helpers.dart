import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:flutter_json_forms/src/rendering/ui_element_contexts.dart';
import 'package:flutter_json_forms/src/rendering/helpers/common.dart';
import 'package:flutter_json_forms/src/rendering/helpers/spacing_utils.dart';

export 'package:flutter_json_forms/src/rendering/helpers/spacing_utils.dart' show LayoutDirection;

/// Helpers for building and wrapping UI layout elements.
///
/// These methods are used by [FormLayout] (the thin widget shell) and by
/// the implementations in `rendering/default_renderer/ui_elements/`.
class LayoutHelpers {
  LayoutHelpers._();

  // ---------------------------------------------------------------------------
  // Direction
  // ---------------------------------------------------------------------------

  /// Maps a [ui.LayoutType] to the corresponding [LayoutDirection].
  static LayoutDirection directionForType(ui.LayoutType type) {
    switch (type) {
      case ui.LayoutType.HORIZONTAL_LAYOUT:
        return LayoutDirection.horizontal;
      case ui.LayoutType.GROUP:
      case ui.LayoutType.VERTICAL_LAYOUT:
        return LayoutDirection.vertical;
    }
  }

  // ---------------------------------------------------------------------------
  // Children with spacing
  // ---------------------------------------------------------------------------

  /// Builds the child widget list for a layout, including visibility-aware
  /// spacing between items.
  ///
  /// [widgetBuilder] receives each element and its pre-computed visibility
  /// flag so the factory is not called twice per element.
  /// [visibilityChecker] returns `true` when an element is currently visible.
  ///
  /// The returned widgets are **not** wrapped in [Expanded] — that is a
  /// renderer-specific decision.  The default renderer's horizontal-layout
  /// builder wraps each child in [Expanded]; custom renderers may do otherwise.
  static List<Widget> buildLayoutChildren(
    List<ui.LayoutElement> elements,
    LayoutDirection direction,
    Widget Function(ui.LayoutElement element, bool isShown) widgetBuilder,
    bool Function(ui.LayoutElement element) visibilityChecker,
  ) {
    return SpacingUtils.buildWidgetsWithSpacing<ui.LayoutElement>(
      items: elements,
      layoutDirection: direction,
      widgetBuilder: (element, index) {
        return widgetBuilder(element, visibilityChecker(element));
      },
      isVisibleChecker: (element, index) => visibilityChecker(element),
    );
  }

  // ---------------------------------------------------------------------------
  // Header wrapping
  // ---------------------------------------------------------------------------

  /// Wraps [content] with an optional heading (from [layout.label] /
  /// [layout.description]), a [LayoutHeaderScope] so nested data-field
  /// wrappers can suppress their own labels, and the CSS-class transform.
  static Widget wrapWithHeader(
    BuildContext context,
    UiLayoutContext layout,
    Widget content,
  ) {
    final scoped = LayoutHeaderScope(hasHeader: layout.hasHeader, child: content);
    final withHead = withHeader(context, layout.label, layout.description, scoped);
    return withCss(context, withHead, cssClass: layout.cssClass);
  }
}
