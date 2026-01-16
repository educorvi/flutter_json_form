import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_json_forms/l10n/form_fallback_localizations.dart';
// import 'package:flutter_json_forms/l10n/form_localizations.dart';
import 'package:flutter_json_forms/src/form_context.dart';
import 'package:flutter_json_forms/src/form_element.dart';
import 'package:flutter_json_forms/src/form_field_context.dart';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:flutter_json_forms/src/widgets/constants.dart';
import 'package:flutter_json_forms/src/widgets/custom_form_fields/form_field_text.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_array/form_array_add_button.dart';
import 'package:flutter_json_forms/src/widgets/form_input_elements/form_checkbox_group_field.dart';
import 'package:flutter_json_forms/src/widgets/form_utils/form_field_utils.dart';
import 'package:flutter_json_forms/src/widgets/shared/form_error.dart';
import 'package:flutter_json_forms/src/widgets/shared/form_element_loading.dart';
import 'package:flutter_json_forms/src/utils/logger.dart';
import 'package:json_schema/json_schema.dart';
import '../../../utils/show_on.dart';
import '../../../utils/parse.dart';
import '../../data/list_item.dart';

part 'form_array_reorder_helpers.dart';

enum FormArrayReorderMode { custom, material }

const FormArrayReorderMode _arrayReorderMode = FormArrayReorderMode.material;

// TODO: make padding or seperator between elements configurable, make reorder, delete and add button configurable, first it should be possible to chnage the icon the button displays and if this is not enough the user cna provide a custom widget which is being rendered.
// Same for description and title, maybe allow to render custom widget there

class FormArrayField extends StatefulWidget {
  final FormFieldContext formFieldContext;

  const FormArrayField({
    super.key,
    required this.formFieldContext,
  });

  @override
  State<FormArrayField> createState() => _FormArrayFieldState();
}

class _FormArrayFieldState extends State<FormArrayField> {
  List<ListItem> items = [];
  bool itemsInitialized = false;
  int _idCounter = 0;
  FormContext? _cachedFormContext;
  int _lastResetRevision = 0;
  int _lastRitaDependenciesRevision = 0;
  late final _ArrayReorderDelegate _reorderDelegate;
  static final _logger = FormLogger.arrayField;

  bool get _useCustomReorder => _arrayReorderMode == FormArrayReorderMode.custom;

  @override
  void initState() {
    super.initState();
    _initializeItems();
    _reorderDelegate = _ArrayReorderDelegate(
      getItems: () => items,
      getContext: () => context,
      getFormFieldContext: () => widget.formFieldContext,
      setState: setState,
      notifyItemsChanged: _notifyItemsChanged,
      isMounted: () => mounted,
      removeItem: _removeItem,
    );
  }

  void _initializeItems() {
    if (!itemsInitialized) {
      itemsInitialized = true;

      if (widget.formFieldContext.initialValue != null) {
        if (widget.formFieldContext.initialValue is! List) {
          widget.formFieldContext.initialValue = [];
        }
        for (dynamic item in widget.formFieldContext.initialValue) {
          items.add(ListItem<dynamic>(id: _idCounter, value: item));
          _idCounter++;
        }
      } else {
        int minItems = safeParseInt(widget.formFieldContext.jsonSchema.minItems);
        for (int i = 0; i < minItems; i++) {
          items.add(ListItem<dynamic>(id: _idCounter++, value: null));
        }
      }
    }
  }

  /// Initialize items for reset - ignores current initialValue and uses only schema defaults
  void _initializeItemsForReset() {
    if (!itemsInitialized) {
      itemsInitialized = true;

      // On reset, ignore current initialValue and use only schema defaults
      int minItems = safeParseInt(widget.formFieldContext.jsonSchema.minItems);
      for (int i = 0; i < minItems; i++) {
        // Use schema default value if available, otherwise null
        dynamic defaultValue = widget.formFieldContext.jsonSchema.items?.defaultValue;
        items.add(ListItem<dynamic>(id: _idCounter++, value: defaultValue));
      }
    }
  }

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

    // Check if form was reset and items need to be re-initialized
    if (effectiveFormContext.formResetRevision != _lastResetRevision) {
      _lastResetRevision = effectiveFormContext.formResetRevision;
      itemsInitialized = false;
      items.clear();
      _idCounter = 0;
      _initializeItemsForReset();
    }

    // Check if Rita dependencies have changed and trigger rebuild for dependent fields
    if (effectiveFormContext.ritaDependenciesRevision != _lastRitaDependenciesRevision) {
      _lastRitaDependenciesRevision = effectiveFormContext.ritaDependenciesRevision;
    }

    // Check if this should be rendered as checkbox group
    if (widget.formFieldContext.jsonSchema.items != null) {
      late final SchemaType? type;
      try {
        type = widget.formFieldContext.jsonSchema.items!.type;
      } catch (e) {
        return FormError(e.toString());
      }
      // TODO: this should be done in the factory and here should only be complex array elements so this simple ones dont get wrapped unnecessary in the FormArrayField (also this is not the concern of the FormArrayField)
      if (type != SchemaType.object && type != SchemaType.array && widget.formFieldContext.jsonSchema.items!.enumValues?.isNotEmpty == true) {
        List<String> values = widget.formFieldContext.jsonSchema.items!.enumValues!.map((e) => e.toString()).toList();
        return FormCheckboxGroupField(context: widget.formFieldContext, values: values);
      }
    }

    if (widget.formFieldContext.jsonSchema.enumValues?.isNotEmpty ?? false) {
      List<String> values = widget.formFieldContext.jsonSchema.enumValues!.map((e) => e.toString()).toList();
      return FormCheckboxGroupField(context: widget.formFieldContext, values: values);
    }

    // Handle tags
    if (widget.formFieldContext.options?.fieldSpecificOptions?.tags?.enabled == true) {
      // TODO: implement proper tags support
      return FormFieldText("Tags not yet implemented");
    }

    return _buildArrayWidget(effectiveFormContext);
  }

  Widget _buildArrayWidget(FormContext formContext) {
    int? maxItems = trySafeParseInt(widget.formFieldContext.jsonSchema.maxItems);
    int minItems = safeParseInt(widget.formFieldContext.jsonSchema.minItems);

    final labelString = FormFieldUtils.getLabel(widget.formFieldContext, getLabel: true);
    final description = widget.formFieldContext.description;
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
          FormArrayAddButton(
            testKey: Key('${widget.formFieldContext.id}/add'),
            onPressed: maxItems == null || items.length < maxItems ? _addItem : null,
          ),
        ],
      );
    }

    Widget arrayWidget = KeyedSubtree(
      key: _reorderDelegate.headerKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelString != null) ...[
            SizedBox(
              width: double.infinity,
              child: FormFieldText(
                labelString,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            // const SizedBox(height: 12.0),
          ],
          if (description != null) ...[
            const SizedBox(height: UIConstants.verticalElementSpacing),
            FormFieldText(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
          buildArrayBody(),
        ],
      ),
    );

    return handleShowOn(
      child: arrayWidget,
      parentIsShown: widget.formFieldContext.parentIsShown,
      showOn: widget.formFieldContext.showOn,
      ritaDependencies: formContext.ritaDependencies,
      checkValueForShowOn: formContext.checkValueForShowOn,
      selfIndices: widget.formFieldContext.selfIndices,
      ritaEvaluator: widget.formFieldContext.ritaEvaluator,
      getFullFormData: widget.formFieldContext.getFullFormData,
    );
  }

  void _addItem() {
    _logger.fine('Adding new array item');
    setState(() {
      _idCounter++;
      items.add(ListItem<dynamic>(id: _idCounter, value: null));
    });
    _logger.finer('Array now has ${items.length} items');
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
    widget.formFieldContext.onChanged?.call(items.map((e) => e.value).toList());
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
          key: ValueKey('${widget.formFieldContext.id}/items/${item.id}'),
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
    final FormFieldContext parentContext = widget.formFieldContext;
    final ui.DescendantControlOverrides? overrides = parentContext.options?.formattingOptions?.descendantControlOverrides?[parentContext.scope];
    final ui.ControlOptions? childOptions = overrides?.options ?? parentContext.options;
    final ui.ShowOnProperty? childShowOn = overrides?.showOn;
    final JsonSchema childSchema = parentContext.jsonSchema.items!;
    final bool childIsObjectType = _schemaRepresentsObject(childSchema);

    final childSelfIndices = () {
      final map = <String, int>{};
      if (parentContext.selfIndices != null) {
        map.addAll(parentContext.selfIndices!);
      }
      map[parentContext.scope] = index;
      return map;
    }();

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

    final ThemeData theme = Theme.of(context);
    final bool canRemove = items.length > minItems;

    const double sideActionWidth = UIConstants.verticalSpacingForArrayControlItems;
    const double sideActionGap = UIConstants.verticalElementSpacing;
    final topPadding = index == 0 ? 0.0 : UIConstants.verticalElementSpacing / 2;

    final bottomPadding = index == items.length - 1 ? 0.0 : UIConstants.verticalElementSpacing / 2;

    return Container(
      padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
      width: double.infinity,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sideActionWidth),
            child: FormElementFactory.createFormElement(childContext),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            width: sideActionWidth,
            child: buildReorderAction(
              theme: theme,
              gap: sideActionGap,
              index: index,
              label: context.localize((l) => l.buttonDragHandle),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            width: sideActionWidth,
            child: buildDeleteAction(
              theme: theme,
              index: index,
              gap: sideActionGap,
              itemId: item.id,
              canRemove: canRemove,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDeleteAction({
    required ThemeData theme,
    required int index,
    required bool canRemove,
    required double gap,
    required int itemId,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: gap),
      child: Tooltip(
        message: context.localize((l) => l.buttonRemove),
        child: FilledButton.tonal(
          onPressed: canRemove ? () => _removeItem(index) : null,
          style: FilledButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          child: Icon(
            Icons.close,
          ),
        ),
      ),
    );
  }

  Widget buildReorderAction({
    required ThemeData theme,
    required double gap,
    required int index,
    required String label,
  }) {
    return Padding(
      padding: EdgeInsets.only(right: gap),
      child: Tooltip(
        message: label,
        child: ReorderableDragStartListener(
          index: index,
          child: FilledButton.tonal(
            onPressed: () => {},
            style: FilledButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            child: const Icon(Icons.drag_indicator_rounded),
          ),
        ),
      ),
    );
  }
}
