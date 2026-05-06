import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/form_context.dart';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:flutter_json_forms/src/rendering/ui_element_contexts.dart';
import 'package:flutter_json_forms/src/utils/logger.dart';
import 'package:http/http.dart' as http;

/// Helpers specific to button actions and styling.
///
/// [ButtonHelpers.resolveOnPressed] computes the [VoidCallback] for a
/// `ui.Button` schema element by routing button-type → form action.
///
/// See also: [DefaultButtonHelpers] in `default_renderer/ui_elements/` for the
/// default styled-button widget builder.
class ButtonHelpers {
  ButtonHelpers._();

  static final _logger = FormLogger.generic;

  // ---------------------------------------------------------------------------
  // Action resolution
  // ---------------------------------------------------------------------------

  /// Returns the [VoidCallback] (or `null` if disabled/unsupported) for
  /// [button] based on its `buttonType` and `submitOptions`.
  ///
  /// Requires [formContext] for submit / reset actions and an optional
  /// [wizardScope] for wizard navigation buttons.
  static VoidCallback? resolveOnPressed(BuildContext context, UiButtonContext button, {FormContext? formContext, FormWizardScope? formWizardScope}) {
    final formCtx = formContext ?? FormContext.of(context)!;
    final wizardScope = formWizardScope ?? FormWizardScope.maybeOf(context);
    final formNoValidate = button.button.options?.formnovalidate ?? false;
    final submitOptions = button.button.options?.submitOptions;

    Future<void> handleSubmit() async {
      final bool valid = formNoValidate ? true : formCtx.saveAndValidate();
      if (!valid) return;

      final action = submitOptions?.action;
      switch (action) {
        case 'request':
          if (formCtx.onFormRequestCallback != null) {
            _logger.info(
              'Submitting form data to onFormRequestCallback: '
              '${jsonEncode(formCtx.getFormValues())}',
            );
            formCtx.onFormRequestCallback!(formCtx.getFormValues(), submitOptions?.request);
            return;
          }
          final request = submitOptions?.request;
          _logger.info(
            'Submitting form data to request ${request?.toString()}: '
            '${jsonEncode(formCtx.getFormValues())}',
          );
          if (request != null) {
            final url = Uri.parse(request.url);
            final method = _methodString(request.method);
            final headers = request.headers;
            final body = jsonEncode(formCtx.getFormValues());
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
                return;
            }
            _logger.info('HTTP ${response.statusCode}');
          }
          break;
        case 'save':
          if (formCtx.onFormSubmitSaveCallback != null) {
            _logger.info(
              'Submitting form data to onFormSubmitCallback: '
              '${jsonEncode(formCtx.getFormValues())}',
            );
            formCtx.onFormSubmitSaveCallback!(formCtx.getFormValues());
          }
          break;
        case 'print':
          debugPrint('Print action: ${jsonEncode(formCtx.getFormValues())}');
          break;
        default:
          if (formCtx.onFormSubmitSaveCallback != null) {
            _logger.info(
              'Submitting form data to onFormSubmitCallback: '
              '${jsonEncode(formCtx.getFormValues())}',
            );
            formCtx.onFormSubmitSaveCallback!(formCtx.getFormValues());
          } else {
            debugPrint('$action action: ${jsonEncode(formCtx.getFormValues())}');
          }
      }
    }

    switch (button.button.buttonType) {
      case ui.TheButtonsType.RESET:
        return formCtx.reset;
      case ui.TheButtonsType.SUBMIT:
        return handleSubmit;
      case ui.TheButtonsType.NEXT_WIZARD_PAGE:
        return wizardScope?.nextPage;
      case ui.TheButtonsType.PREVIOUS_WIZARD_PAGE:
        return wizardScope?.previousPage;
    }
  }

  // ---------------------------------------------------------------------------
  // Button appearance
  // ---------------------------------------------------------------------------

  /// Resolves the visual appearance (colour, outline flag, light-foreground
  /// flag) for a button with [variant], using [scheme] for theme-derived
  /// colours.
  ///
  /// The returned record can be used by any renderer to style a button widget
  /// without importing Flutter widget classes.
  static ({Color color, bool isOutline}) resolveButtonStyle(
    ui.ColorVariants? variant,
    ColorScheme scheme,
  ) {
    return switch (variant) {
      ui.ColorVariants.PRIMARY => (color: scheme.primary, isOutline: false),
      ui.ColorVariants.SECONDARY => (color: scheme.secondary, isOutline: false),
      ui.ColorVariants.SUCCESS => (color: Colors.green, isOutline: false),
      ui.ColorVariants.WARNING => (color: Colors.orange, isOutline: false),
      ui.ColorVariants.DANGER => (color: scheme.error, isOutline: false),
      ui.ColorVariants.INFO => (color: Colors.blue, isOutline: false),
      ui.ColorVariants.LIGHT => (color: scheme.surfaceContainerHighest, isOutline: false),
      ui.ColorVariants.DARK => (color: Colors.black87, isOutline: false),
      ui.ColorVariants.OUTLINE_PRIMARY => (color: scheme.primary, isOutline: true),
      ui.ColorVariants.OUTLINE_SECONDARY => (color: scheme.secondary, isOutline: true),
      ui.ColorVariants.OUTLINE_SUCCESS => (color: Colors.green, isOutline: true),
      ui.ColorVariants.OUTLINE_WARNING => (color: Colors.orange, isOutline: true),
      ui.ColorVariants.OUTLINE_DANGER => (color: scheme.error, isOutline: true),
      ui.ColorVariants.OUTLINE_INFO => (color: Colors.blue, isOutline: true),
      ui.ColorVariants.OUTLINE_LIGHT => (color: scheme.surfaceContainerHighest, isOutline: true),
      ui.ColorVariants.OUTLINE_DARK => (color: Colors.black87, isOutline: true),
      null => (color: scheme.primary, isOutline: false),
    };
  }

  // ---------------------------------------------------------------------------
  // Internal
  // ---------------------------------------------------------------------------

  static String _methodString(ui.Method? method) {
    switch (method) {
      case ui.Method.GET:
        return 'GET';
      case ui.Method.POST:
      case null:
        return 'POST';
      case ui.Method.PUT:
        return 'PUT';
      case ui.Method.DELETE:
        return 'DELETE';
    }
  }
}
