import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_forms/src/form_field_context.dart';
import 'package:flutter_json_forms/src/widgets/shared/form_field_utils.dart';
import 'package:intl/intl.dart';

class FormDateTimePickerField extends StatelessWidget {
  final FormFieldContext formFieldContext;
  final InputType inputType;

  const FormDateTimePickerField({
    super.key,
    required this.formFieldContext,
    required this.inputType,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 100),
      child: FormBuilderDateTimePicker(
        name: formFieldContext.id,
        onChanged: formFieldContext.onChanged,
        enabled: formFieldContext.enabled,
        validator: FormFieldUtils.createBaseValidator(formFieldContext),
        decoration: FormFieldUtils.getInputDecoration(formFieldContext, context,
            suffixIcon: const Icon(Icons.date_range), hintText: _getHintText(inputType, context)),
        initialValue: _getDefaultDateTime(),
        inputType: inputType,
        onSaved: (DateTime? dateTime) => formFieldContext.onSavedCallback?.call(dateTime?.toIso8601String()),
      ),
    );
  }

  String _getHintText(InputType inputType, BuildContext buildContext) {
    late final DateFormat format;
    switch (inputType) {
      case InputType.date:
        format = DateFormat.yMd(Intl.getCurrentLocale());
      case InputType.time:
        format = DateFormat.Hm(Intl.getCurrentLocale());
      case InputType.both:
        format = DateFormat.yMd(Intl.getCurrentLocale()).add_Hm();
    }
    final currentDate = DateTime.now();
    final datetime = DateTime(currentDate.year, currentDate.month, currentDate.day, 12);
    return format.format(datetime);
  }

  DateTime? _getDefaultDateTime() {
    if (formFieldContext.initialValue is! String) {
      return null;
    }
    final String initialValueString = formFieldContext.initialValue;
    if (initialValueString == '\$now') {
      return DateTime.now();
    } else {
      return DateTime.tryParse(initialValueString);
    }
  }
}
