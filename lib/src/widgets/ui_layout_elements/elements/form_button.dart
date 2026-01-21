import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/form_context.dart';
import 'package:flutter_json_forms/src/utils/logger.dart';
import 'package:http/http.dart' as http;
import '../../../models/ui_schema.g.dart' as ui;
import 'package:flutter_json_forms/src/widgets/ui_layout_elements/elements/form_wizard.dart';

class FormButton extends StatelessWidget {
  final ui.Button button;

  const FormButton({
    super.key,
    required this.button,
  });

  static final _logger = FormLogger.generic;

  @override
  Widget build(BuildContext context) {
    final formContext = FormContext.of(context)!;
    final wizardScope = FormWizardScope.maybeOf(context);
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
      bool valid = formNoValidate ? true : formContext.saveAndValidate();

      if (!valid) return;

      final action = submitOptions?.action;

      switch (action) {
        case 'request':
          if (formContext.onFormRequestCallback != null) {
            _logger.info('Submitting form data to onFormRequestCallback: ${jsonEncode(formContext.getFormValues())}');
            formContext.onFormRequestCallback!(formContext.getFormValues(), submitOptions?.request);
            return;
          }
          final request = submitOptions?.request;
          _logger.info('Submitting form data to request ${request?.toString()}: ${jsonEncode(formContext.getFormValues())}');

          if (request != null) {
            final url = Uri.parse(request.url);
            final method = getMethod(request.method);
            final headers = request.headers;
            final body = jsonEncode(formContext.getFormValues());

            // ignore: unused_local_variable
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
                debugPrint('Unsupported HTTP method: $method');
            }
          }
          break;
        case 'save':
          if (formContext.onFormSubmitSaveCallback != null) {
            _logger.info('Submitting form data to onFormSubmitCallback: ${jsonEncode(formContext.getFormValues())}');
            formContext.onFormSubmitSaveCallback!(formContext.getFormValues());
          }
          break;
        case 'print':
          debugPrint('Print action: ${jsonEncode(formContext.getFormValues())}');
          break;
        default:
          if (formContext.onFormSubmitSaveCallback != null) {
            _logger.info('Submitting form data to onFormSubmitCallback: ${jsonEncode(formContext.getFormValues())}');
            formContext.onFormSubmitSaveCallback!(formContext.getFormValues());
          } else {
            debugPrint('$action action : ${jsonEncode(formContext.getFormValues())}');
          }
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
      case ui.TheButtonsType.NEXT_WIZARD_PAGE:
        onPressed = wizardScope?.nextPage;
        break;
      case ui.TheButtonsType.PREVIOUS_WIZARD_PAGE:
        onPressed = wizardScope?.previousPage;
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
    required ui.ColorVariants? variant,
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    final scheme = Theme.of(context).colorScheme;

    late final Color color;
    late final bool isOutline;
    late final bool isLight;

    switch (variant) {
      case ui.ColorVariants.PRIMARY:
        color = scheme.primary;
        isOutline = false;
        isLight = false;
        break;
      case ui.ColorVariants.SECONDARY:
        color = scheme.secondary;
        isOutline = false;
        isLight = false;
        break;
      case ui.ColorVariants.SUCCESS:
        color = Colors.green;
        isOutline = false;
        isLight = false;
        break;
      case ui.ColorVariants.WARNING:
        color = Colors.orange;
        isOutline = false;
        isLight = false;
        break;
      case ui.ColorVariants.DANGER:
        color = scheme.error;
        isOutline = false;
        isLight = false;
        break;
      case ui.ColorVariants.INFO:
        color = Colors.blue;
        isOutline = false;
        isLight = false;
        break;
      case ui.ColorVariants.LIGHT:
        color = scheme.surfaceContainerHighest;
        isOutline = false;
        isLight = true;
        break;
      case ui.ColorVariants.DARK:
        color = Colors.black87;
        isOutline = false;
        isLight = false;
        break;
      case ui.ColorVariants.OUTLINE_PRIMARY:
        color = scheme.primary;
        isOutline = true;
        isLight = false;
        break;
      case ui.ColorVariants.OUTLINE_SECONDARY:
        color = scheme.secondary;
        isOutline = true;
        isLight = false;
        break;
      case ui.ColorVariants.OUTLINE_SUCCESS:
        color = Colors.green;
        isOutline = true;
        isLight = false;
        break;
      case ui.ColorVariants.OUTLINE_WARNING:
        color = Colors.orange;
        isOutline = true;
        isLight = false;
        break;
      case ui.ColorVariants.OUTLINE_DANGER:
        color = scheme.error;
        isOutline = true;
        isLight = false;
        break;
      case ui.ColorVariants.OUTLINE_INFO:
        color = Colors.blue;
        isOutline = true;
        isLight = false;
        break;
      case ui.ColorVariants.OUTLINE_LIGHT:
        color = scheme.surfaceContainerHighest;
        isOutline = true;
        isLight = true;
        break;
      case ui.ColorVariants.OUTLINE_DARK:
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
