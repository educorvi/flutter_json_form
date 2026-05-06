import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_forms/src/rendering/render_context.dart';
import 'package:flutter_json_forms/src/rendering/helpers/render_helpers.dart';
import 'package:flutter_json_forms/src/rendering/helpers/text_field_helpers.dart';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;

class FormTextField extends StatefulWidget {
  final RenderContext ctx;
  final Type expectedType; // String, int, double

  const FormTextField({
    super.key,
    required this.ctx,
    this.expectedType = String,
  });

  @override
  State<FormTextField> createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  late bool obscureText = widget.ctx.format == ui.Format.PASSWORD;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final fieldContext = widget.ctx;
    final maxLines = RenderHelpers.getTextMaxLines(fieldContext.options);

    return FormBuilderTextField(
      key: Key(fieldContext.scope),
      textAlign: RenderHelpers.getTextAlign(fieldContext.options),
      name: fieldContext.id,
      onSubmitted: (value) => _handleValueChange(value),
      enabled: fieldContext.enabled,
      onSaved: (value) => _handleSave(value),
      onChanged: (value) => _handleValueChange(value),
      obscureText: obscureText,
      validator: TextFieldHelpers.composeValidator(fieldContext, widget.expectedType),
      decoration: RenderHelpers.buildInputDecoration(
        fieldContext,
        context,
        suffixIcon: fieldContext.format == ui.Format.PASSWORD
            ? IconButton(
                icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
              )
            : null,
      ),
      initialValue: RenderHelpers.parseTextInitialValue(fieldContext.initialValue),
      textInputAction: maxLines > 1 ? TextInputAction.newline : null,
      maxLines: maxLines,
      keyboardType: RenderHelpers.getTextKeyboardType(fieldContext.format, maxLines, widget.expectedType),
      inputFormatters: RenderHelpers.getTextInputFormatters(widget.expectedType),
      autofillHints: TextFieldHelpers.getAutocompleteValues(fieldContext.options),
    );
  }

  void _handleValueChange(String? value) {
    widget.ctx.onChanged?.call(RenderHelpers.convertTextValue(value, widget.expectedType));
  }

  void _handleSave(String? value) {
    widget.ctx.onSavedCallback?.call(RenderHelpers.convertTextValue(value, widget.expectedType));
  }
}
