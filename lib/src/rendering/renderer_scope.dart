import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/rendering/default_renderer/default_json_form_renderer.dart';
import 'package:flutter_json_forms/src/rendering/json_form_renderer.dart';

/// An [InheritedWidget] that provides the active [JsonFormRenderer] to the
/// entire widget subtree of a [FlutterJsonForm].
///
/// [FormElementFactory] reads this widget at build time to route schema field
/// types to the correct [JsonFormRenderer] builder method.
///
/// You normally don't need to use [RendererScope] directly – pass a renderer
/// to [FlutterJsonForm] instead.  It is exposed publicly so advanced use-cases
/// (e.g. isolated sub-trees with different renderers) are possible.
class RendererScope extends InheritedWidget {
  /// The active renderer for this sub-tree.
  final JsonFormRenderer renderer;

  const RendererScope({
    super.key,
    required this.renderer,
    required super.child,
  });

  /// Returns the nearest [JsonFormRenderer] from the widget tree.
  ///
  /// Falls back to a [DefaultJsonFormRenderer] when no [RendererScope] is
  /// present (e.g. in unit tests that do not wrap the widget under test).
  static JsonFormRenderer of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<RendererScope>();
    return scope?.renderer ?? const DefaultJsonFormRenderer();
  }

  @override
  bool updateShouldNotify(RendererScope oldWidget) => renderer != oldWidget.renderer;
}
