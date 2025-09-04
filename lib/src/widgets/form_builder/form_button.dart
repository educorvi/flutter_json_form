import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/form_context.dart';
import 'package:http/http.dart' as http;
import '../../models/ui_schema.dart' as ui;

class FormButton extends StatelessWidget {
  final ui.Button button;

  const FormButton({
    super.key,
    required this.button,
  });

  @override
  Widget build(BuildContext context) {
    final formContext = FormContext.of(context)!;
    final formNoValidate = button.options?.formnovalidate ?? false;
    final submitOptions = button.options?.submitOptions;

    String getMethod(ui.Method? method) {
      switch (method) {
        case ui.Method.GET:
          return 'GET';
        case ui.Method.POST:
          return 'POST';
        case ui.Method.PUT:
          return 'PUT';
        case ui.Method.DELETE:
          return 'DELETE';
        case null:
          return 'POST';
      }
    }

    Future<void> handleSubmit() async {
      // If formnovalidate is true, skip validation
      bool valid = formNoValidate ? true : formContext.saveAndValidate();

      if (!valid) return;

      final action = submitOptions?.action ?? 'submit';

      switch (action) {
        case 'request':
          final request = submitOptions?.request;
          if (request != null) {
            final url = Uri.parse(request.url);
            final method = getMethod(request.method);
            final headers = request.headers;
            final body = jsonEncode(formContext.getFormValues());

            http.Response response;
            switch (method) {
              case 'GET':
                response = await http.get(url, headers: headers);
                break;
              case 'POST':
                response = await http.post(url, headers: headers, body: body);
                break;
              case 'PUT':
                response = await http.put(url, headers: headers, body: body);
                break;
              case 'DELETE':
                response = await http.delete(url, headers: headers, body: body);
                break;
              default:
                throw Exception('Unsupported HTTP method: $method');
            }
            debugPrint('Request response: ${response.statusCode} ${response.body}');
          }
          break;
        case 'save':
          debugPrint('Save action: ${jsonEncode(formContext.getFormValues())}');
          break;
        case 'print':
          debugPrint('Print action: ${jsonEncode(formContext.getFormValues())}');
          break;
        default:
          debugPrint('Default submit: ${jsonEncode(formContext.getFormValues())}');
      }
    }

    VoidCallback? onPressed;
    switch (button.buttonType) {
      case ui.TheButtonsType.RESET:
        onPressed = formContext.reset;
        break;
      case ui.TheButtonsType.SUBMIT:
        onPressed = handleSubmit;
        break;
    }

    return _renderStyledButton(
      context: context,
      variant: button.options?.variant,
      onPressed: onPressed,
      child: Text(button.text),
    );
  }

  Widget _renderStyledButton({
    required BuildContext context,
    required ui.ColorVariant? variant,
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    final scheme = Theme.of(context).colorScheme;

    late final Color color;
    late final bool isOutline;
    late final bool isLight;

    switch (variant) {
      case ui.ColorVariant.PRIMARY:
        color = scheme.primary;
        isOutline = false;
        isLight = false;
        break;
      case ui.ColorVariant.SECONDARY:
        color = scheme.secondary;
        isOutline = false;
        isLight = false;
        break;
      case ui.ColorVariant.SUCCESS:
        color = Colors.green;
        isOutline = false;
        isLight = false;
        break;
      case ui.ColorVariant.WARNING:
        color = Colors.orange;
        isOutline = false;
        isLight = false;
        break;
      case ui.ColorVariant.DANGER:
        color = scheme.error;
        isOutline = false;
        isLight = false;
        break;
      case ui.ColorVariant.INFO:
        color = Colors.blue;
        isOutline = false;
        isLight = false;
        break;
      case ui.ColorVariant.LIGHT:
        color = scheme.surfaceContainerHighest;
        isOutline = false;
        isLight = true;
        break;
      case ui.ColorVariant.DARK:
        color = Colors.black87;
        isOutline = false;
        isLight = false;
        break;
      case ui.ColorVariant.OUTLINE_PRIMARY:
        color = scheme.primary;
        isOutline = true;
        isLight = false;
        break;
      case ui.ColorVariant.OUTLINE_SECONDARY:
        color = scheme.secondary;
        isOutline = true;
        isLight = false;
        break;
      case ui.ColorVariant.OUTLINE_SUCCESS:
        color = Colors.green;
        isOutline = true;
        isLight = false;
        break;
      case ui.ColorVariant.OUTLINE_WARNING:
        color = Colors.orange;
        isOutline = true;
        isLight = false;
        break;
      case ui.ColorVariant.OUTLINE_DANGER:
        color = scheme.error;
        isOutline = true;
        isLight = false;
        break;
      case ui.ColorVariant.OUTLINE_INFO:
        color = Colors.blue;
        isOutline = true;
        isLight = false;
        break;
      case ui.ColorVariant.OUTLINE_LIGHT:
        color = scheme.surfaceContainerHighest;
        isOutline = true;
        isLight = true;
        break;
      case ui.ColorVariant.OUTLINE_DARK:
        color = Colors.black87;
        isOutline = true;
        isLight = false;
        break;
      case null:
        color = scheme.primary;
        isOutline = false;
        isLight = false;
        break;
    }

    if (isOutline) {
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color),
        ),
        onPressed: onPressed,
        child: child,
      );
    } else {
      return FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: isLight ? Colors.black : Colors.white,
        ),
        onPressed: onPressed,
        child: child,
      );
    }
  }
}
