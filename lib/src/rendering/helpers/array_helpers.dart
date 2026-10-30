import 'package:flutter_json_forms/src/utils/data/list_item.dart';
import 'package:flutter_json_forms/src/utils/parse.dart';
import 'package:json_schema/json_schema.dart';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;

/// Pure utility helpers for building array form fields.
///
/// These helpers expose the core logic so that custom renderer implementations
/// can reuse it without re-implementing it from scratch.
class ArrayHelpers {
  ArrayHelpers._();

  // ---------------------------------------------------------------------------
  // Schema inspection
  // ---------------------------------------------------------------------------

  /// Returns `true` when [schema] represents an object type, either directly
  /// or through `anyOf` / `oneOf` / `allOf` combinators.
  static bool schemaRepresentsObject(JsonSchema schema) {
    if (_schemaTypeIsObject(schema)) return true;
    return [...schema.anyOf, ...schema.oneOf, ...schema.allOf].any(_schemaTypeIsObject);
  }

  /// Returns `true` when [schema] is one of the primitive scalar types
  /// (`boolean`, `integer`, `number`, or `string`).
  static bool schemaIsPrimitive(JsonSchema schema) {
    SchemaType? type;
    try {
      type = schema.type;
    } catch (_) {
      type = null;
    }
    if (type == null) return false;
    switch (type) {
      case SchemaType.boolean:
      case SchemaType.integer:
      case SchemaType.number:
      case SchemaType.string:
        return true;
      default:
        return false;
    }
  }

  static bool _schemaTypeIsObject(JsonSchema schema) {
    SchemaType? type;
    try {
      type = schema.type;
    } catch (_) {
      type = null;
    }
    return type == SchemaType.object;
  }

  // ---------------------------------------------------------------------------
  // Item count / action constraints
  // ---------------------------------------------------------------------------

  /// Returns `true` when an item can be added, i.e. the list has not yet
  /// reached the `maxItems` limit from the schema.
  ///
  /// Pass `null` for [maxItems] when the schema has no upper bound.
  static bool canAddItem(List<ListItem> items, int? maxItems) {
    return maxItems == null || items.length < maxItems;
  }

  /// Returns `true` when an item can be removed from [items] without
  /// violating the `minItems` constraint.
  static bool canRemoveItem(List<ListItem> items, int minItems) {
    return items.length > minItems;
  }

  /// Returns `true` when reordering makes sense, i.e. there is more than one
  /// item in the list.
  static bool canReorderItems(List<ListItem> items) {
    return items.length > 1;
  }

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
  // Item list initialisation
  // ---------------------------------------------------------------------------

  /// Creates the initial [ListItem] list from [initialValue] and the schema's
  /// `minItems` constraint.
  ///
  /// Returns a record with the item list and the next id counter value so the
  /// caller can continue incrementing ids without collisions.
  ///
  /// [initialValue] is expected to be a `List` or `null`.  Non-list values are
  /// treated as empty (the caller is responsible for normalising before calling
  /// this method if needed).
  static ({List<ListItem<dynamic>> items, int idCounter}) initializeItems({
    required dynamic initialValue,
    required dynamic minItemsRaw,
    int startIdCounter = 0,
  }) {
    final List<ListItem<dynamic>> items = [];
    int idCounter = startIdCounter;

    if (initialValue is List) {
      for (final item in initialValue) {
        items.add(ListItem<dynamic>(id: idCounter++, value: item));
      }
    }

    final int minItems = safeParseInt(minItemsRaw);
    for (int i = idCounter; i < minItems; i++) {
      items.add(ListItem<dynamic>(id: idCounter++, value: null));
    }

    return (items: items, idCounter: idCounter);
  }

  // ---------------------------------------------------------------------------
  // Self-indices
  // ---------------------------------------------------------------------------

  /// Builds the merged `selfIndices` map for an array item at [index].
  ///
  /// Copies [parentSelfIndices] (if non-null) and adds `parentScope → index`.
  static Map<String, int> buildChildSelfIndices(
    Map<String, int>? parentSelfIndices,
    String parentScope,
    int index,
  ) {
    final map = <String, int>{};
    if (parentSelfIndices != null) map.addAll(parentSelfIndices);
    map[parentScope] = index;
    return map;
  }
}
