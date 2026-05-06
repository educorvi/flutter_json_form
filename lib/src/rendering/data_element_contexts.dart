import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Array sub-component contexts
// ---------------------------------------------------------------------------
// Each context carries exactly the data a renderer override needs to build
// the corresponding widget.  All action logic (canAdd, canRemove, …) is
// pre-computed by [ArrayHelpers] before the contexts are constructed, so
// renderer implementations deal with UI only—no schema access required.

/// Context passed to [JsonFormRenderer.buildArrayAddButton].
class ArrayAddButtonContext {
  /// Whether an item may be added (i.e. `maxItems` not yet reached).
  ///
  /// Computed by [ArrayHelpers.canAddItem].
  final bool canAdd;

  /// Optional label text for the button, sourced from
  /// `options.arrayOptions.addButtonText`.  `null` = use the localised
  /// default ("Add").
  final String? label;

  /// Callback that adds a new item.  Should be forwarded to the button's
  /// `onPressed`.
  final VoidCallback onAdd;

  /// Test key for the button widget.
  final Key? testKey;

  const ArrayAddButtonContext({
    required this.canAdd,
    this.label,
    required this.onAdd,
    this.testKey,
  });
}

/// Context passed to [JsonFormRenderer.buildArrayReorderButton].
class ArrayReorderButtonContext {
  /// Zero-based position of the item in the list.
  final int index;

  /// Stable unique id of the item (survives reorders).
  final int itemId;

  /// Whether drag-reordering is currently possible.
  ///
  /// `false` when only one item is present; compute with
  /// [ArrayHelpers.canReorderItems].
  final bool canReorder;

  /// Localised accessibility label for the drag handle.
  final String label;

  /// Test key for the button widget.
  final Key? testKey;

  const ArrayReorderButtonContext({
    required this.index,
    required this.itemId,
    required this.canReorder,
    required this.label,
    this.testKey,
  });
}

/// Context passed to [JsonFormRenderer.buildArrayDeleteButton].
class ArrayDeleteButtonContext {
  /// Zero-based position of the item in the list.
  final int index;

  /// Stable unique id of the item (survives reorders).
  final int itemId;

  /// Whether the item may be removed (i.e. `minItems` would not be violated).
  ///
  /// Computed by [ArrayHelpers.canRemoveItem].
  final bool canRemove;

  /// Localised tooltip / accessibility label for the remove action.
  final String tooltip;

  /// Callback to remove an item at a given index.
  final void Function(int index) onRemove;

  /// Test key for the button widget.
  final Key? testKey;

  const ArrayDeleteButtonContext({
    required this.index,
    required this.itemId,
    required this.canRemove,
    required this.tooltip,
    required this.onRemove,
    this.testKey,
  });
}

/// Context passed to [JsonFormRenderer.buildArrayItemLayout].
///
/// Carries positional information about the item so renderers can apply
/// correct top/bottom spacing without depending on the item list itself.
class ArrayItemContext {
  /// Zero-based position of the item in the list.
  final int index;

  /// Stable unique id of the item (survives reorders).
  final int itemId;

  /// `true` when this is the first item in the list (index == 0).
  final bool isFirst;

  /// `true` when this is the last item in the list.
  final bool isLast;

  const ArrayItemContext({
    required this.index,
    required this.itemId,
    required this.isFirst,
    required this.isLast,
  });
}
