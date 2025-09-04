import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/form_context.dart';
import 'package:flutter_json_forms/src/form_element.dart';
import 'package:flutter_json_forms/src/form_field_context.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_checkbox_group_field.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_field_utils.dart';
import 'package:flutter_json_forms/src/widgets/shared/form_error.dart';
import 'package:json_schema/json_schema.dart';
import '../../utils/show_on.dart';
import '../../utils/parse.dart';
import '../data/list_item.dart';

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

  @override
  Widget build(BuildContext context) {
    final formContext = FormContext.of(context)!;

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
      return Text("Tags not yet implemented");
    }

    return _buildArrayWidget(formContext);
  }

  Widget _buildArrayWidget(FormContext formContext) {
    bool arrayIsShown() => widget.formFieldContext.isShownCallback();

    int? maxItems = trySafeParseInt(widget.formFieldContext.jsonSchema.maxItems);
    int minItems = safeParseInt(widget.formFieldContext.jsonSchema.minItems);

    final labelString = FormFieldUtils.getLabel(widget.formFieldContext);

    Widget arrayWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelString != null)
          SizedBox(
            width: double.infinity,
            child: Text(
              labelString,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final childContext = widget.formFieldContext.createChildContext(
              childScope: '${widget.formFieldContext.scope}/items',
              childId: '${widget.formFieldContext.id}/items/${items[index].id}',
              childJsonSchema: widget.formFieldContext.jsonSchema.items!,
              childInitialValue: items[index].value,
              childRequired: widget.formFieldContext.required,
              childShowLabel: false,
              childSelfIndices: () {
                final map = <String, int>{};
                if (widget.formFieldContext.selfIndices != null) {
                  map.addAll(widget.formFieldContext.selfIndices!);
                }
                map[widget.formFieldContext.scope] = index;
                return map;
              }(),
              childOnChanged: (value) {
                items[index].value = value;
                if (widget.formFieldContext.onChanged != null) {
                  widget.formFieldContext.onChanged!(items.map((e) => e.value).toList());
                }
              },
              childOnSavedCallback: (value) {
                items[index].value = value;
                if (widget.formFieldContext.onSavedCallback != null && index == items.length - 1) {
                  widget.formFieldContext.onSavedCallback!(items.map((e) => e.value).toList());
                }
              },
            );
            // final ui.DescendantControlOverrides? overrides =
            //     widget.formFieldContext.options?.formattingOptions?.descendantControlOverrides?[widget.formFieldContext.scope];
            // final ui.ControlOptions? childOptions = overrides?.options ?? widget.formFieldContext.options;
            // final ui.ShowOnProperty? childShowOn = overrides?.showOn;

            // bool childIsShown() => isElementShown(
            //       parentIsShown: arrayIsShown(),
            //       showOn: childShowOn,
            //       ritaDependencies: formContext.ritaDependencies,
            //       checkValueForShowOn: formContext.checkValueForShowOn,
            //     );

            return Container(
              key: Key('${items[index].id}'),
              child: Row(
                children: [
                  ReorderableDragStartListener(
                    index: index,
                    child: GestureDetector(
                      onTapDown: (_) => FocusScope.of(context).unfocus(),
                      child: const Icon(Icons.drag_handle),
                    ),
                  ),
                  Expanded(child: FormElementFactory.createFormElement(childContext)
                      // FormElementFormControl(
                      //   scope: '${widget.formFieldContext.scope}/items',
                      //   id: '${widget.formFieldContext.id}/items/${items[index].id}',
                      //   options: childOptions,
                      //   showOn: childShowOn,
                      //   jsonSchema: widget.formFieldContext.jsonSchema.items!,
                      //   nestingLevel: widget.formFieldContext.nestingLevel,
                      //   required: widget.formFieldContext.required,
                      //   initialValue: items[index].value,
                      //   selfIndices: () {
                      //     final map = <String, int>{};
                      //     if (widget.formFieldContext.selfIndices != null) {
                      //       map.addAll(widget.formFieldContext.selfIndices!);
                      //     }
                      //     map[widget.formFieldContext.scope] = index;
                      //     return map;
                      //   }(),
                      //   ritaEvaluator: widget.formFieldContext.ritaEvaluator,
                      //   getFullFormData: widget.formFieldContext.getFullFormData,
                      //   onSavedCallback: (value) {
                      //     items[index].value = value;
                      //     if (widget.formFieldContext.onSavedCallback != null && index == items.length - 1) {
                      //       widget.formFieldContext.onSavedCallback!(items.map((e) => e.value).toList());
                      //     }
                      //   },
                      //   isShownCallback: childIsShown,
                      //   onChanged: (value) {
                      //     items[index].value = value;
                      //     if (widget.formFieldContext.onChanged != null) {
                      //       widget.formFieldContext.onChanged!(items);
                      //     }
                      //   },
                      //   showLabel: false,
                      //   parentIsShown: arrayIsShown(),
                      //   ritaDependencies: formContext.ritaDependencies,
                      //   checkValueForShowOn: formContext.checkValueForShowOn,
                      // ),
                      ),
                  IconButton(
                    disabledColor: Theme.of(context).colorScheme.error.withValues(alpha: 0.7),
                    icon: const Icon(Icons.close),
                    color: Theme.of(context).colorScheme.error,
                    onPressed: items.length > minItems ? () => _removeItem(index) : null,
                  ),
                ],
              ),
            );
          },
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }
              final ListItem item = items.removeAt(oldIndex);
              items.insert(newIndex, item);
            });
          },
        ),
        if (widget.formFieldContext.description != null)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              widget.formFieldContext.description!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        SizedBox(
          width: double.infinity,
          child: FilledButton.tonal(
            onPressed: maxItems == null || items.length < maxItems ? _addItem : null,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );

    return handleShowOn(
      child: arrayWidget,
      parentIsShown: widget.formFieldContext.parentIsShown,
      showOn: widget.formFieldContext.showOn,
      ritaDependencies: widget.formFieldContext.ritaDependencies,
      checkValueForShowOn: widget.formFieldContext.checkValueForShowOn,
      selfIndices: widget.formFieldContext.selfIndices,
      ritaEvaluator: widget.formFieldContext.ritaEvaluator,
      getFullFormData: widget.formFieldContext.getFullFormData,
    );
  }

  void _addItem() {
    setState(() {
      _idCounter++;
      items.add(ListItem<dynamic>(id: _idCounter, value: null));
    });
  }

  void _removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }
}
