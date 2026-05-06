import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormBuilderSegmentedButton<T> extends FormBuilderFieldDecoration<T> {
  final List<ButtonSegment<T>> segments;
  final Set<T>? selected;
  final void Function(Set<T>)? onSelectionChanged;
  final bool multiSelectionEnabled;
  final bool emptySelectionAllowed;
  final ButtonStyle? style;
  final bool showSelectedIcon;
  final Widget? selectedIcon;
  final bool? stacked;

  FormBuilderSegmentedButton({
    super.autovalidateMode = AutovalidateMode.disabled,
    super.enabled,
    super.focusNode,
    super.onSaved,
    super.validator,
    super.decoration,
    super.key,
    required super.name,
    super.initialValue,
    required this.segments,
    this.selected,
    this.onSelectionChanged,
    this.multiSelectionEnabled = false,
    this.emptySelectionAllowed = false,
    this.style,
    this.showSelectedIcon = true,
    this.selectedIcon,
    super.onChanged,
    super.valueTransformer,
    super.onReset,
    super.restorationId,
    this.stacked = false,
  })  : assert(selected == null && onSelectionChanged == null || selected != null && onSelectionChanged != null),
        super(
          builder: (FormFieldState<T?> field) {
            final state = field as _FormBuilderFieldDecorationState<T>;
            T currentValue = initialValue ?? segments.first.value;

            Widget buttonWidget;
            if (stacked == true) {
              buttonWidget = Column(
                children: segments.map((segment) {
                  final isSelected = (selected ?? <T>{state.value ?? currentValue}).contains(segment.value);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: OutlinedButton(
                      style: style,
                      onPressed: enabled
                          ? () {
                              state.didChange(segment.value);
                              onSelectionChanged?.call({segment.value});
                            }
                          : null,
                      child: Row(
                        children: [
                          segment.label ?? const SizedBox.shrink(),
                          if (showSelectedIcon && isSelected && selectedIcon != null) ...[
                            const SizedBox(width: 8),
                            selectedIcon,
                          ],
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            } else {
              buttonWidget = SegmentedButton<T>(
                segments: segments,
                selected: selected ?? <T>{state.value ?? currentValue},
                onSelectionChanged: onSelectionChanged ??
                    (value) {
                      state.didChange(value.first);
                    },
                multiSelectionEnabled: multiSelectionEnabled,
                emptySelectionAllowed: emptySelectionAllowed,
                style: style,
                showSelectedIcon: showSelectedIcon,
                selectedIcon: selectedIcon,
              );
            }

            return InputDecorator(
              decoration: state.decoration,
              child: buttonWidget,
            );
          },
        );

  @override
  FormBuilderFieldDecorationState<FormBuilderSegmentedButton<T>, T> createState() => _FormBuilderFieldDecorationState<T>();
}

class _FormBuilderFieldDecorationState<T> extends FormBuilderFieldDecorationState<FormBuilderSegmentedButton<T>, T> {}

/// TODO remove asserts and selected ?? and onSelectionChanged ?? checks
/// (In other Form Builder Methods, these methods arent supported, so selected
/// and onSelectionChanged dont exists for the FormBuilderClass
/// allow Multi Selection (maybe have a look at the checkbox group Form Element)
