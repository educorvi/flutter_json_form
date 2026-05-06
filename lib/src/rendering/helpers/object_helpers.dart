import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;

/// Pure utility helpers for building object form fields.
///
/// These helpers expose the core logic so that custom renderer implementations
/// can reuse it without re-implementing it from scratch.
class ObjectHelpers {
  ObjectHelpers._();

  // ---------------------------------------------------------------------------
  // Scope / id helpers
  // ---------------------------------------------------------------------------

  /// Computes the child scope string for property [key] inside [parentScope].
  ///
  /// Example: `ObjectHelpers.buildChildScope('#/properties/address', 'city')`
  /// → `'#/properties/address/properties/city'`
  static String buildChildScope(String parentScope, String key) => '$parentScope/properties/$key';

  /// Computes the child id string for property [key] inside [parentId].
  static String buildChildId(String parentId, String key) => '$parentId/properties/$key';

  // ---------------------------------------------------------------------------
  // Descendant-control overrides
  // ---------------------------------------------------------------------------

  /// Returns the [ui.DescendantControlOverrides] for [childScope] from
  /// [parentOptions], or `null` when no override is configured.
  static ui.DescendantControlOverrides? getDescendantOverrides(
    ui.Options? parentOptions,
    String childScope,
  ) {
    return parentOptions?.formattingOptions?.descendantControlOverrides?[childScope];
  }

  // ---------------------------------------------------------------------------
  // Initial value resolution
  // ---------------------------------------------------------------------------

  /// Extracts the initial value for child property [key] from the parent's
  /// [initialValue] map.
  ///
  /// Handles two key formats:
  /// - Direct key access (e.g. `"name"`) — used when the object is nested
  ///   inside an array item.
  /// - `/properties/<key>` prefix format — used for top-level objects.
  ///
  /// Returns `null` when [initialValue] is not a [Map] or does not contain
  /// [key] in either format.
  static dynamic getChildInitialValue(dynamic initialValue, String key) {
    if (initialValue is! Map) return null;
    if (initialValue.containsKey(key)) return initialValue[key];
    final prefixedKey = '/properties/$key';
    if (initialValue.containsKey(prefixedKey)) return initialValue[prefixedKey];
    return null;
  }
}
