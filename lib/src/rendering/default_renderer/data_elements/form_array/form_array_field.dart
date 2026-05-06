import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_json_forms/l10n/form_fallback_localizations.dart';
import 'package:flutter_json_forms/src/form_context.dart';
import 'package:flutter_json_forms/src/widgets/form_input_elements/data_element_factory.dart';
import 'package:flutter_json_forms/src/rendering/render_context.dart';
import 'package:flutter_json_forms/src/rendering/renderer_scope.dart';
import 'package:flutter_json_forms/src/rendering/data_element_contexts.dart';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:flutter_json_forms/src/rendering/default_renderer/constants.dart';
import 'package:flutter_json_forms/src/rendering/helpers/array_helpers.dart';
import 'package:flutter_json_forms/src/widgets/shared/form_element_loading.dart';
import 'package:flutter_json_forms/src/utils/logger.dart';
import 'package:json_schema/json_schema.dart';
import '../../../../utils/parse.dart';
import '../../../../utils/data/list_item.dart';

part 'form_array_custom_reorder.dart';

enum FormArrayReorderMode { custom, material }

const FormArrayReorderMode _arrayReorderMode = FormArrayReorderMode.material;

class FormArrayField extends StatefulWidget {
  final RenderContext ctx;

  const FormArrayField({
    super.key,
    required this.ctx,
  });

  @override
  State<FormArrayField> createState() => _FormArrayFieldState();
}

class _FormArrayFieldState extends State<FormArrayField> {
  List<ListItem> items = [];
  bool itemsInitialized = false;
  late int _idCounter;
  FormContext? _cachedFormContext;
  late final _ArrayReorderDelegate _reorderDelegate;

  static final _logger = FormLogger.arrayField;
  static bool get _useCustomReorder => _arrayReorderMode == FormArrayReorderMode.custom;

  @override
  void initState() {
    super.initState();
    _cachedFormContext = null;
    _idCounter = 0;
    _initializeItems();
    _reorderDelegate = _ArrayReorderDelegate(
      getItems: () => items,
      getContext: () => context,
      getFormFieldContext: () => widget.ctx,
      setState: setState,
      notifyItemsChanged: _notifyItemsChanged,
      isMounted: () => mounted,
      removeItem: _removeItem,
    );
  }

  void _initializeItems() {
    if (!itemsInitialized) {
      itemsInitialized = true;

      // Normalise initialValue: non-list values are treated as empty.
      if (widget.ctx.initialValue != null && widget.ctx.initialValue is! List) {
        widget.ctx.initialValue = [];
      }

      final result = ArrayHelpers.initializeItems(
        initialValue: widget.ctx.initialValue,
        minItemsRaw: widget.ctx.jsonSchema.minItems,
      );
      items = result.items;
      _idCounter = result.idCounter;
    }
  }

  /// Initialize items for reset - ignores current initialValue and uses only schema defaults

  @override
  Widget build(BuildContext context) {
    final formContext = FormContext.of(context);

    // Cache the FormContext when it's available
    if (formContext != null) {
      _cachedFormContext = formContext;
    }

    // If FormContext is not available and there is no cached one, show a placeholder
    if (formContext == null && _cachedFormContext == null) {
      return const FormElementLoading();
    }

    // Use available FormContext or cached one
    final effectiveFormContext = formContext ?? _cachedFormContext!;

    return _buildArrayWidget(effectiveFormContext);
  }

  Widget _buildArrayWidget(FormContext formContext) {
    int? maxItems = trySafeParseInt(widget.ctx.jsonSchema.maxItems);
    int minItems = safeParseInt(widget.ctx.jsonSchema.minItems);

    // final bool collapseWhileReordering = formContext.collapseArrayItemsWhileReordering;

    Widget buildArrayBody() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (items.isNotEmpty)
            _useCustomReorder
                ? SelectionArea(
                    child: _reorderDelegate.buildCustomList(
                      minItems: minItems,
                      // collapseWhileReordering: collapseWhileReordering,
                    ),
                  )
                : _buildMaterialArrayList(
                    minItems: minItems,
                    // collapseWhileReordering: collapseWhileReordering,
                  ),
          if (items.isNotEmpty) SizedBox(height: UIConstants.verticalElementSpacing),
          _buildAddButton(maxItems: maxItems),
        ],
      );
    }

    return KeyedSubtree(key: _reorderDelegate.headerKey, child: buildArrayBody());
  }

  Widget _buildAddButton({int? maxItems}) {
    final renderer = RendererScope.of(context);
    return renderer.buildArrayAddButton(
      context,
      ArrayAddButtonContext(
        canAdd: ArrayHelpers.canAddItem(items, maxItems),
        label: widget.ctx.options?.arrayOptions?.addButtonText,
        onAdd: _addItem,
        testKey: Key('${widget.ctx.id}/add'),
      ),
    );
  }

  void _addItem() {
    _logger.fine('Adding new array item');
    setState(() {
      items.add(ListItem<dynamic>(id: _idCounter++, value: null));
    });
    _logger.finer('Array now has ${items.length} items');
    _notifyItemsChanged();
  }

  void _removeItem(int index) {
    _logger.fine('Removing array item at index $index');
    setState(() {
      items.removeAt(index);
    });
    _logger.finer('Array now has ${items.length} items');
    _notifyItemsChanged();
  }

  void _notifyItemsChanged() {
    widget.ctx.onChanged?.call(items.map((e) => e.value).toList());
  }

  Widget _buildMaterialArrayList({
    required int minItems,
    // required bool collapseWhileReordering,
  }) {
    final List<ListItem> currentItems = items;
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      buildDefaultDragHandles: false,
      itemCount: currentItems.length,
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final item = currentItems.removeAt(oldIndex);
          currentItems.insert(newIndex, item);
        });
        _notifyItemsChanged();
      },
      itemBuilder: (context, index) {
        final ListItem<dynamic> item = currentItems[index];
        return KeyedSubtree(
          key: ValueKey('${widget.ctx.id}/items/${item.id}'),
          child: buildArrayItemWidget(
            item: item,
            index: index,
            minItems: minItems,
            // collapseWhileReordering: collapseWhileReordering,
            useCustomReorder: false,
          ),
        );
      },
    );
  }

  Widget buildArrayItemWidget({
    required ListItem<dynamic> item,
    required int index,
    required int minItems,
    // required bool collapseWhileReordering,
    required bool useCustomReorder,
  }) {
    final RenderContext parentContext = widget.ctx;
    final ui.DescendantControlOverrides? overrides = parentContext.options?.formattingOptions?.descendantControlOverrides?[parentContext.scope];
    final ui.Options? childOptions = overrides?.options ?? parentContext.options;
    final ui.ShowOnProperty? childShowOn = overrides?.showOn;
    final JsonSchema childSchema = parentContext.jsonSchema.items!;
    final bool childIsObjectType = ArrayHelpers.schemaRepresentsObject(childSchema);

    final childSelfIndices = ArrayHelpers.buildChildSelfIndices(
      parentContext.selfIndices,
      parentContext.scope,
      index,
    );

    final childContext = parentContext.createChildContext(
      childScope: '${parentContext.scope}/items',
      childId: '${parentContext.id}/items/${item.id}',
      childJsonSchema: childSchema,
      childInitialValue: item.value,
      childRequired: parentContext.required,
      childShowLabel: false,
      childOptions: childOptions,
      childShowOn: childShowOn,
      childSelfIndices: childSelfIndices,
      childShowObjectLeadingLine: childIsObjectType ? false : null,
      childOnChanged: (value) {
        items[index].value = value;
        _notifyItemsChanged();
        setState(() {});
      },
      childOnSavedCallback: (value, {Map<String, int>? computedSelfIndices}) {
        items[index].value = value;
        if (parentContext.onSavedCallback != null && index == items.length - 1) {
          parentContext.onSavedCallback!(
            items.map((e) => e.value).toList(),
            computedSelfIndices: childSelfIndices,
          );
        }
      },
    );

    final renderer = RendererScope.of(context);
    final bool canRemove = ArrayHelpers.canRemoveItem(items, minItems);
    final bool canReorder = ArrayHelpers.canReorderItems(items) || useCustomReorder;

    final reorderButton = renderer.buildArrayReorderButton(
      context,
      ArrayReorderButtonContext(
        index: index,
        itemId: item.id,
        canReorder: canReorder,
        label: context.localize((l) => l.buttonDragHandle),
        testKey: Key('${parentContext.id}/items/${item.id}/drag'),
      ),
    );

    final deleteButton = renderer.buildArrayDeleteButton(
      context,
      ArrayDeleteButtonContext(
        index: index,
        itemId: item.id,
        canRemove: canRemove,
        tooltip: context.localize((l) => l.buttonRemove),
        onRemove: _removeItem,
        testKey: Key('${parentContext.id}/items/${item.id}/remove'),
      ),
    );

    final itemCtx = ArrayItemContext(
      index: index,
      itemId: item.id,
      isFirst: index == 0,
      isLast: index == items.length - 1,
    );

    return renderer.buildArrayItemLayout(
      context,
      itemCtx,
      child: FormElementFactory.createFormElement(childContext),
      reorderButton: reorderButton,
      deleteButton: deleteButton,
    );
  }
}
