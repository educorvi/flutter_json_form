import 'package:flutter/material.dart';
import '../../../form_field_context.dart';

class InputDecorationBuilder {
  final FormFieldContext context;
  final BuildContext buildContext;

  InputDecorationBuilder({
    required this.context,
    required this.buildContext,
  });

  /// Creates the input decoration for the form field
  /// [border] controls whether to show border
  /// [prefix] and [suffix] widgets can be set to customize the appearance
  /// [suffixIcon] can be set for icons like password visibility toggle
  /// If the uiSchema defines formatting options, they take precedence and will be used instead
  InputDecoration build({
    bool border = true,
    Widget? prefix,
    Widget? suffix,
    Widget? suffixIcon,
    bool showLabel = true,
  }) {
    return InputDecoration(
      labelText: showLabel && context.showLabel ? _getLabel() : null,
      hintText: context.placeholder,
      border: !border ? InputBorder.none : Theme.of(buildContext).inputDecorationTheme.border,
      helperText: context.description,
      helperMaxLines: 10,
      prefix: context.options?.formattingOptions?.prepend == null ? prefix : null,
      prefixText: context.options?.formattingOptions?.prepend,
      suffix: context.options?.formattingOptions?.append == null ? suffix : null,
      suffixText: context.options?.formattingOptions?.append,
      suffixIcon: suffixIcon,
      floatingLabelBehavior: FloatingLabelBehavior.always,
    );
  }

  String? _getLabel() {
    String? getScope() {
      final lastScopeElement = context.scope.split('/').last;
      return lastScopeElement != "items" ? lastScopeElement : null;
    }

    final titleString = context.title ?? getScope();
    return context.required && titleString != null ? ('$titleString*') : titleString;
    // TODO: not barrierefrei, should be an icon with text required/notwendig
  }
}
