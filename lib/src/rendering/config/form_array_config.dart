import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Builder typedefs
// ---------------------------------------------------------------------------

/// Builder for the "add item" button in a [FormArrayField].
///
/// [onPressed] is `null` when the array has reached its `maxItems` limit.
typedef ArrayAddButtonBuilder = Widget Function(
  BuildContext context, {
  required VoidCallback? onPressed,
  required String? label,
  required Key? testKey,
});

/// Builder for the drag-handle "reorder" button shown on each array item.
typedef ArrayReorderButtonBuilder = Widget Function(
  BuildContext context, {
  required int index,
  required bool canReorder,
  required String label,
  required double gap,
  required Key? testKey,
});

/// Builder for the "remove item" button shown on each array item.
///
/// [canRemove] is `false` when removing the item would violate `minItems`.
typedef ArrayDeleteButtonBuilder = Widget Function(
  BuildContext context, {
  required int index,
  required int itemId,
  required bool canRemove,
  required String tooltip,
  required void Function(int index) onRemove,
  required double gap,
  required Key? testKey,
});

// ---------------------------------------------------------------------------
// Config class
// ---------------------------------------------------------------------------

/// Customisation options for [FormArrayField].
///
/// Supply one or more builders to replace the default add / reorder / delete
/// buttons with your own widgets.  Leave a builder `null` to keep the
/// built-in widget for that action.
///
/// ### Example – custom add button
/// ```dart
/// FormArrayConfig(
///   addButtonBuilder: (context, {required onPressed, required label, required testKey}) =>
///       OutlinedButton.icon(
///         key: testKey,
///         onPressed: onPressed,
///         icon: const Icon(Icons.playlist_add),
///         label: Text(label ?? 'Add'),
///       ),
/// )
/// ```
///
/// To replace the *entire* array widget, override
/// [DefaultJsonFormRenderer.buildDataArrayControl] instead:
/// ```dart
/// class MyRenderer extends DefaultJsonFormRenderer {
///   @override
///   Widget buildDataArrayControl(BuildContext context, RenderContext ctx) =>
///       MyCustomArrayField(ctx: ctx);
/// }
/// ```
class FormArrayConfig {
  /// Replaces the default add-item button.
  final ArrayAddButtonBuilder? addButtonBuilder;

  /// Replaces the default drag-handle button.
  final ArrayReorderButtonBuilder? reorderButtonBuilder;

  /// Replaces the default remove-item button.
  final ArrayDeleteButtonBuilder? deleteButtonBuilder;

  const FormArrayConfig({
    this.addButtonBuilder,
    this.reorderButtonBuilder,
    this.deleteButtonBuilder,
  });
}
