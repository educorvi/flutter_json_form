import 'package:flutter/material.dart';
import 'package:flutter_json_forms/l10n/form_fallbackLocalizations.dart';
import 'package:flutter_json_forms/l10n/form_localizations.dart';
import 'package:flutter_json_forms/src/form_context.dart';
import 'package:flutter_json_forms/src/form_element.dart';
import 'package:flutter_json_forms/src/form_field_context.dart';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:flutter_json_forms/src/widgets/custom_form_fields/form_field_text.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_array_add_button.dart';
import 'package:flutter_json_forms/src/widgets/form_input_elements/form_checkbox_group_field.dart';
import 'package:flutter_json_forms/src/widgets/form_utils/form_field_utils.dart';
import 'package:flutter_json_forms/src/widgets/shared/form_error.dart';
import 'package:flutter_json_forms/src/widgets/shared/form_element_loading.dart';
import 'package:flutter_json_forms/src/utils/logger.dart';
import 'package:json_schema/json_schema.dart';
import '../../utils/show_on.dart';
import '../../utils/parse.dart';
import '../data/list_item.dart';
import '../shared/spacing_utils.dart';

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
  static final _logger = FormLogger.arrayField;

  @override
  void initState() {
    super.initState();
    _initializeItems();
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
    bool arrayIsShown() => widget.formFieldContext.isShownCallback();

    int? maxItems = trySafeParseInt(widget.formFieldContext.jsonSchema.maxItems);
    int minItems = safeParseInt(widget.formFieldContext.jsonSchema.minItems);

    final labelString = FormFieldUtils.getLabel(widget.formFieldContext, getLabel: true);

    Widget arrayWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelString != null)
          SizedBox(
            width: double.infinity,
            child: FormFieldText(
              labelString,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        if (items.isNotEmpty) ...[
          SelectionArea(
            child: ReorderableListView(
              buildDefaultDragHandles: false,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              onReorder: _moveItem,
              children: _buildArrayItemsWithSpacing(formContext, arrayIsShown, minItems),
            ),
          ),
        ],
        FormArrayAddButton(
          testKey: Key('${widget.formFieldContext.id}/add'),
          onPressed: maxItems == null || items.length < maxItems ? _addItem : null,
        ),
        if (widget.formFieldContext.description != null)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: FormFieldText(
              widget.formFieldContext.description!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
      ],
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
  }

  void _moveItem(int oldIndex, int newIndex) {
    _logger.fine('Moving array item from $oldIndex to $newIndex');
    setState(() {
      // Convert widget indices back to item indices
      // Widget layout: Item0 (0), Spacer (1), Item1 (2), Spacer (3), Item2 (4), etc.

      // For oldIndex, we only care about actual items (even indices)
      int actualOldIndex = oldIndex ~/ 2;

      // For newIndex, we need to handle both items and spacers intelligently
      int actualNewIndex;
      if (newIndex % 2 == 0) {
        // newIndex is on an actual item
        actualNewIndex = newIndex ~/ 2;
      } else {
        // newIndex is on a spacer, so we want to move to the item after the spacer
        actualNewIndex = (newIndex + 1) ~/ 2;
      }

      // Ensure indices are within bounds
      actualOldIndex = actualOldIndex.clamp(0, items.length - 1);
      actualNewIndex = actualNewIndex.clamp(0, items.length);

      // Standard reordering logic adjustment
      if (actualNewIndex > actualOldIndex) {
        actualNewIndex -= 1;
      }

      // Ensure we don't go out of bounds after adjustment
      actualNewIndex = actualNewIndex.clamp(0, items.length - 1);

      if (actualOldIndex != actualNewIndex) {
        final ListItem item = items.removeAt(actualOldIndex);
        items.insert(actualNewIndex, item);

        // Trigger dependency re-evaluation after reordering
        // This is crucial for showOn/Rita rules that depend on array indices
        if (widget.formFieldContext.onChanged != null) {
          widget.formFieldContext.onChanged!(items.map((e) => e.value).toList());
        }
      }
    });
  }

  /// Builds a list of array items with proper spacing using shared utility
  List<Widget> _buildArrayItemsWithSpacing(FormContext formContext, bool Function() arrayIsShown, int minItems) {
    return SpacingUtils.buildArrayItemsWithSpacing<ListItem<dynamic>>(
      items: items,
      widgetBuilder: (item, index) => _buildArrayItemWidget(item, index, formContext, minItems),
      isVisibleChecker: (item, index) => true, // Array items are typically always visible
      spacingWidgetBuilder: (item, index) => Container(
        key: Key('${item.id}_spacing'),
        height: 8.0,
      ),
    );
  }

  /// Builds a single array item widget
  Widget _buildArrayItemWidget(ListItem<dynamic> item, int index, FormContext formContext, int minItems) {
    final ui.DescendantControlOverrides? overrides =
        widget.formFieldContext.options?.formattingOptions?.descendantControlOverrides?[widget.formFieldContext.scope];
    final ui.ControlOptions? childOptions = overrides?.options ?? widget.formFieldContext.options;
    final ui.ShowOnProperty? childShowOn = overrides?.showOn;

    final childSelfIndices = () {
      final map = <String, int>{};
      if (widget.formFieldContext.selfIndices != null) {
        map.addAll(widget.formFieldContext.selfIndices!);
      }
      map[widget.formFieldContext.scope] = index;
      return map;
    }();

    final childContext = widget.formFieldContext.createChildContext(
      childScope: '${widget.formFieldContext.scope}/items',
      childId: '${widget.formFieldContext.id}/items/${item.id}',
      childJsonSchema: widget.formFieldContext.jsonSchema.items!,
      childInitialValue: item.value, // _getInitialValueForArrayItem(item, index),
      childRequired: widget.formFieldContext.required,
      childShowLabel: false,
      childOptions: childOptions,
      childShowOn: childShowOn,
      childSelfIndices: childSelfIndices,
      childOnChanged: (value) {
        items[index].value = value;
        if (widget.formFieldContext.onChanged != null) {
          widget.formFieldContext.onChanged!(items.map((e) => e.value).toList());
        }
        // Force rebuild of this array field when any child changes
        // This is crucial for nested arrays where child state changes need to be reflected immediately
        setState(() {});
      },
      childOnSavedCallback: (value, {Map<String, int>? computedSelfIndices}) {
        items[index].value = value;
        if (widget.formFieldContext.onSavedCallback != null && index == items.length - 1) {
          widget.formFieldContext.onSavedCallback!(items.map((e) => e.value).toList(), computedSelfIndices: childSelfIndices);
        }
      },
    );

    // Calculate the widget index for this item (accounting for spacing widgets)
    int widgetIndex = index * 2; // Widget layout: Item0 (0), Spacer (1), Item1 (2), Spacer (3), Item2 (4), etc.

    return Container(
      key: Key('${item.id}'),
      child: Row(
        children: [
          // TODO make it externally customizable by providing a callback
          ReorderableDragStartListener(
            key: Key('${widget.formFieldContext.id}/${item.id}/drag'),
            index: widgetIndex, // Use the actual widget index, not the item index
            child: GestureDetector(
              onTapDown: (_) => FocusScope.of(context).unfocus(),
              child: Tooltip(
                message: context.localize((l) => l.buttonDragHandle),
                child: const Icon(Icons.drag_handle),
              ),
            ),
          ),
          // TODO make it externally customizable by providing a callback
          Expanded(child: FormElementFactory.createFormElement(childContext)),
          // TODO make it externally customizable by providing a callback
          IconButton(
              key: Key('${widget.formFieldContext.id}/${item.id}/remove'),
              disabledColor: Theme.of(context).colorScheme.error.withValues(alpha: 0.7),
              icon: const Icon(Icons.close),
              color: Theme.of(context).colorScheme.error,
              tooltip: context.localize((l) => l.buttonRemove),
              onPressed: items.length > minItems ? () => _removeItem(index) : null),
        ],
      ),
    );
  }
}
