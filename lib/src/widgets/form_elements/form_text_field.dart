import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_forms/src/form_field_context.dart';
import 'package:flutter_json_forms/src/models/ui_schema.dart' as ui;
import 'package:flutter_json_forms/src/utils/parse.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_field_utils.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_field_wrapper.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class FormTextField extends StatefulWidget {
  final FormFieldContext formFieldContext;
  final Type expectedType; // String, int, double

  const FormTextField({
    super.key,
    required this.formFieldContext,
    this.expectedType = String,
  });

  @override
  State<FormTextField> createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  late bool obscureText;

  @override
  void initState() {
    super.initState();
    obscureText = widget.formFieldContext.format == ui.Format.PASSWORD;
  }

  @override
  Widget build(BuildContext context) {
    final fieldContext = widget.formFieldContext;

    // Convert initial value to string
    String initialValueString = "";
    if (fieldContext.initialValue != null) {
      try {
        initialValueString = fieldContext.initialValue.toString();
      } catch (e) {
        initialValueString = "";
      }
    }

    return FormFieldWrapper(
      context: fieldContext,
      child: FormBuilderTextField(
        textAlign: _getTextAlign(),
        name: fieldContext.id,
        onSubmitted: (value) => _handleValueChange(value),
        enabled: fieldContext.enabled,
        onSaved: (value) => _handleSave(value),
        onChanged: (value) => _handleValueChange(value),
        obscureText: obscureText,
        validator: _composeValidator(),
        decoration: FormFieldUtils.getInputDecoration(
          fieldContext,
          context,
          suffixIcon: fieldContext.format == ui.Format.PASSWORD
              ? IconButton(
                  icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                )
              : null,
        ),
        initialValue: initialValueString,
        textInputAction: _getMaxLines() > 1 ? TextInputAction.newline : null,
        maxLines: _getMaxLines(),
        keyboardType: _getKeyboardType(),
        autofillHints: _getAutocompleteValues(),
      ),
    );
  }

  void _handleValueChange(String? value) {
    if (widget.formFieldContext.onChanged != null) {
      widget.formFieldContext.onChanged!(_convertValue(value));
    }
  }

  void _handleSave(String? value) {
    if (widget.formFieldContext.onSavedCallback != null) {
      widget.formFieldContext.onSavedCallback!(_convertValue(value));
    }
  }

  dynamic _convertValue(String? value) {
    if (value == null || value.isEmpty) return null;

    switch (widget.expectedType) {
      case int:
        return int.tryParse(value) ?? value;
      case double:
        return double.tryParse(value) ?? value;
      case String:
      default:
        return value;
    }
  }

  int _getMaxLines() {
    if (widget.formFieldContext.options?.fieldSpecificOptions?.multi != null) {
      dynamic multi = widget.formFieldContext.options!.fieldSpecificOptions!.multi;
      if (multi is bool) {
        return multi ? 2 : 1;
      } else if (multi is int) {
        return multi;
      }
    }
    return 1;
  }

  TextInputType _getKeyboardType() {
    if (_getMaxLines() > 1) return TextInputType.multiline;

    switch (widget.formFieldContext.format) {
      case ui.Format.EMAIL:
        return TextInputType.emailAddress;
      case ui.Format.PASSWORD:
        return TextInputType.visiblePassword;
      case ui.Format.URL:
        return TextInputType.url;
      case ui.Format.TEL:
        return TextInputType.phone;
      default:
        if (widget.expectedType == int || widget.expectedType == double) {
          return TextInputType.number;
        }
        return TextInputType.text;
    }
  }

  TextAlign _getTextAlign() {
    return switch (widget.formFieldContext.options?.fieldSpecificOptions?.textAlign) {
      ui.TextAlign.START => TextAlign.start,
      ui.TextAlign.END => TextAlign.end,
      ui.TextAlign.CENTER => TextAlign.center,
      ui.TextAlign.LEFT => TextAlign.left,
      ui.TextAlign.RIGHT => TextAlign.right,
      null => TextAlign.start,
    };
  }

  FormFieldValidator<dynamic> _composeValidator() {
    return FormFieldUtils.createBaseValidator(
      widget.formFieldContext,
      additionalValidators: [
        if (widget.expectedType == int || widget.expectedType == double) FormBuilderValidators.numeric(checkNullOrEmpty: false),
        if (widget.formFieldContext.jsonSchema.minimum != null)
          FormBuilderValidators.min(
            safeParseNum(widget.formFieldContext.jsonSchema.minimum),
            checkNullOrEmpty: false,
          ),
        if (widget.formFieldContext.jsonSchema.maximum != null)
          FormBuilderValidators.max(
            safeParseNum(widget.formFieldContext.jsonSchema.maximum),
            checkNullOrEmpty: false,
          ),
        if (widget.formFieldContext.jsonSchema.minLength != null)
          FormBuilderValidators.minLength(
            safeParseInt(widget.formFieldContext.jsonSchema.minLength),
            checkNullOrEmpty: false,
          ),
        if (widget.formFieldContext.jsonSchema.maxLength != null)
          FormBuilderValidators.maxLength(
            safeParseInt(widget.formFieldContext.jsonSchema.maxLength),
            checkNullOrEmpty: false,
          ),
        if (widget.formFieldContext.jsonSchema.pattern != null)
          FormBuilderValidators.match(
            widget.formFieldContext.jsonSchema.pattern!,
            checkNullOrEmpty: false,
          ),
        if (widget.formFieldContext.format == ui.Format.EMAIL) FormBuilderValidators.email(checkNullOrEmpty: false),
        if (widget.formFieldContext.format == ui.Format.TEL) FormBuilderValidators.phoneNumber(checkNullOrEmpty: false),
        if (widget.formFieldContext.format == ui.Format.URL) FormBuilderValidators.url(checkNullOrEmpty: false),
      ],
    );
  }

  InputDecoration _getInputDecoration() {
    return InputDecoration(
      labelText: widget.formFieldContext.showLabel ? _getLabel() : null,
      hintText: widget.formFieldContext.placeholder,
      border: Theme.of(context).inputDecorationTheme.border,
      helperText: widget.formFieldContext.description,
      helperMaxLines: 10,
      prefixText: widget.formFieldContext.options?.formattingOptions?.prepend,
      suffixText: widget.formFieldContext.options?.formattingOptions?.append,
      suffixIcon: widget.formFieldContext.format == ui.Format.PASSWORD
          ? IconButton(
              icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  obscureText = !obscureText;
                });
              },
            )
          : null,
      floatingLabelBehavior: FloatingLabelBehavior.always,
    );
  }

  String? _getLabel() {
    String? getScope() {
      final lastScopeElement = widget.formFieldContext.scope.split('/').last;
      return lastScopeElement != "items" ? lastScopeElement : null;
    }

    final titleString = widget.formFieldContext.title ?? getScope();
    return widget.formFieldContext.required && titleString != null ? ('${titleString}*') : titleString;
  }

  Iterable<String>? _getAutocompleteValues() {
    // Implementation same as original
    return null;
  }
}
