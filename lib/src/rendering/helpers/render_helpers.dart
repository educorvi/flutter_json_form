import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_forms/l10n/form_fallback_localizations.dart';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:flutter_json_forms/src/rendering/render_context.dart';
import 'package:flutter_json_forms/src/utils/enum_utils.dart';
import 'package:flutter_json_forms/src/rendering/default_renderer/constants.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:json_schema/json_schema.dart';

export 'package:flutter_json_forms/src/utils/enum_utils.dart' show mapEnumValuesToTitles;

/// Static helper functions for building widgets in custom [JsonFormRenderer] implementations.
///
/// All helpers operate on [RenderContext] and standard Flutter/Dart types so they
/// work regardless of which form library the custom renderer uses.
class RenderHelpers {
  RenderHelpers._();

  // ---------------------------------------------------------------------------
  // Decoration & labels
  // ---------------------------------------------------------------------------

  /// Returns a standard [InputDecoration] built from [ctx].
  ///
  /// Pass optional overrides such as [suffixIcon] or [hintText] that the
  /// library itself cannot infer from the schema.
  ///
  /// Set [border] to `false` to remove the input border (useful for sliders,
  /// checkbox groups, etc.).
  static InputDecoration buildInputDecoration(
    RenderContext ctx,
    BuildContext buildCtx, {
    bool border = true,
    Widget? prefix,
    Widget? suffix,
    Widget? suffixIcon,
    String? hintText,
  }) {
    return InputDecoration(
      labelText: ctx.showLabel ? getLabel(ctx) : null,
      hintText: ctx.placeholder ?? hintText,
      border: !border ? InputBorder.none : Theme.of(buildCtx).inputDecorationTheme.border,
      helperText: ctx.description,
      helperMaxLines: 10,
      prefix: ctx.options?.formattingOptions?.prepend == null ? prefix : null,
      prefixText: ctx.options?.formattingOptions?.prepend,
      suffix: ctx.options?.formattingOptions?.append == null ? suffix : null,
      suffixText: ctx.options?.formattingOptions?.append,
      suffixIcon: suffixIcon,
      floatingLabelBehavior: FloatingLabelBehavior.always,
    );
  }

  /// Returns the human-readable label for [ctx], or `null` when no label
  /// should be rendered.
  ///
  /// Set [forInputDecoration] to `false` when rendering a label widget
  /// *separately* from the field's own [InputDecoration] – this is used by
  /// [FormFieldWrapper]-equivalent wrappers that place the label above the
  /// input widget.
  static String? getLabel(RenderContext ctx, {bool forInputDecoration = true}) {
    if (ctx.options?.formattingOptions?.label == false) return null;
    // When labels are always rendered separately (UIConstants.labelSeparateText),
    // do not include the label in the InputDecoration as well.
    if (forInputDecoration && UIConstants.labelSeparateText) return null;
    return _computeLabelText(ctx);
  }

  static String? _computeLabelText(RenderContext ctx) {
    if (ctx.title != null) return ctx.title;
    final lastScopeElement = ctx.scope.split('/').last;
    if (lastScopeElement == 'items') return null;
    return lastScopeElement[0].toUpperCase() + lastScopeElement.substring(1);
  }

  // ---------------------------------------------------------------------------
  // Validators
  // ---------------------------------------------------------------------------

  /// Creates a base [FormFieldValidator] that:
  ///   1. Skips validation when the field is hidden (`ctx.isShownCallback()`).
  ///   2. Validates `required` (via `options.formattingOptions.forceRequired`
  ///      or `ctx.required`).
  ///   3. Runs any [additionalValidators] in order.
  ///
  /// The returned validator is a plain `String? Function(T?)` and can be
  /// composed with Flutter's standard `FormField.validator`.
  static FormFieldValidator<T> createBaseValidator<T>(
    RenderContext ctx, {
    List<FormFieldValidator<T>>? additionalValidators,
  }) {
    return (valueCandidate) {
      if (!ctx.isShownCallback()) return null;

      if (ctx.required || ctx.options?.formattingOptions?.forceRequired == true) {
        final err = FormBuilderValidators.required<T>().call(valueCandidate);
        if (err != null) return err;
      }

      if (additionalValidators != null) {
        for (final v in additionalValidators) {
          final err = v.call(valueCandidate);
          if (err != null) return err;
        }
      }

      return null;
    };
  }

  // ---------------------------------------------------------------------------
  // DateTime helpers
  // ---------------------------------------------------------------------------

  /// Parses the initial value for date/time fields.
  ///
  /// Returns `DateTime.now()` for the special `"$now"` sentinel, attempts
  /// [DateTime.tryParse] for ISO-8601 strings, and returns `null` for
  /// everything else.
  static DateTime? parseDefaultDateTime(dynamic initialValue) {
    if (initialValue is! String) return null;
    if (initialValue == r'$now') return DateTime.now();
    return DateTime.tryParse(initialValue);
  }

  /// Returns a localised hint string (e.g. `"12/31/2024"`) for date/time
  /// fields.
  ///
  /// [inputType] must be one of [InputType.date], [InputType.time], or
  /// [InputType.both].
  static String getDateTimeHintText(InputType inputType, BuildContext buildCtx) {
    late final DateFormat format;
    switch (inputType) {
      case InputType.date:
        format = DateFormat.yMd(Intl.getCurrentLocale());
      case InputType.time:
        format = DateFormat.Hm(Intl.getCurrentLocale());
      case InputType.both:
        format = DateFormat.yMd(Intl.getCurrentLocale()).add_Hm();
    }
    final now = DateTime.now();
    final sample = DateTime(now.year, now.month, now.day, 12);
    return format.format(sample);
  }

  // ---------------------------------------------------------------------------
  // Boolean helpers
  // ---------------------------------------------------------------------------

  /// Converts any initial value to a `bool`.
  ///
  /// Handles native [bool] values and the strings `"true"` / `"false"`.
  /// All other values return `false`.
  static bool parseBoolInitialValue(dynamic initialValue) {
    if (initialValue is bool) return initialValue;
    if (initialValue is String) return initialValue.toLowerCase() == 'true';
    return false;
  }

  // ---------------------------------------------------------------------------
  // Numeric helpers
  // ---------------------------------------------------------------------------

  /// Converts [initialValue] to a [double], returning [fallback] if
  /// conversion fails.
  static double parseNumericInitialValue(dynamic initialValue, double fallback) {
    if (initialValue == null) return fallback;
    if (initialValue is num) return initialValue.toDouble();
    if (initialValue is String) return double.tryParse(initialValue) ?? fallback;
    return fallback;
  }

  /// Determines the `divisions` count for a discrete slider based on the
  /// schema's `minimum`, `maximum`, and optional `multipleOf`.
  ///
  /// Returns `null` when a meaningful division count cannot be computed.
  static int? computeSliderDivisions(double min, double max, double? multipleOf) {
    if (max <= min) return null;
    if (multipleOf != null && multipleOf > 0) {
      final steps = (max - min) / multipleOf;
      if (steps.isFinite && steps > 0 && (steps - steps.roundToDouble()).abs() < 1e-6) {
        return steps.round();
      }
    } else {
      return (max - min).toInt();
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // Text field helpers
  // ---------------------------------------------------------------------------

  /// Converts initialValue to the string shown in a text field.
  static String parseTextInitialValue(dynamic initialValue) {
    if (initialValue == null) return '';
    try {
      return initialValue.toString();
    } catch (_) {
      return '';
    }
  }

  /// Returns the number of text lines for a multiline field based on schema
  /// options.
  ///
  /// `multi: true` → 2, `multi: <int>` → that int, `multi: null/false` → 1.
  static int getTextMaxLines(ui.Options? options) {
    final multi = options?.inputOptions?.multi;
    if (multi is bool) return multi ? 2 : 1;
    if (multi is int) return multi;
    return 1;
  }

  /// Determines the [TextInputType] to use based on the field format, number
  /// of lines, and expected [numType].
  static TextInputType getTextKeyboardType(
    ui.Format? format,
    int maxLines,
    Type numType,
  ) {
    if (maxLines > 1) return TextInputType.multiline;
    if (numType == int) return TextInputType.number;
    if (numType == double) return const TextInputType.numberWithOptions(decimal: true);
    switch (format) {
      case ui.Format.EMAIL:
        return TextInputType.emailAddress;
      case ui.Format.PASSWORD:
        return TextInputType.visiblePassword;
      case ui.Format.URL:
        return TextInputType.url;
      case ui.Format.TEL:
        return TextInputType.phone;
      default:
        return TextInputType.text;
    }
  }

  /// Returns [TextInputFormatter]s that restrict input for numeric fields.
  /// Returns `null` for string fields.
  static List<TextInputFormatter>? getTextInputFormatters(Type numType) {
    if (numType == int) return [FilteringTextInputFormatter.digitsOnly];
    if (numType == double) {
      return [FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*[.,]?[0-9]*'))];
    }
    return null;
  }

  /// Converts [value] (the raw text from the field) to the typed value
  /// matching [numType] (`int`, `double`, or `String`).
  static dynamic convertTextValue(String? value, Type numType) {
    if (value == null || value.isEmpty) return null;
    if (numType == int) return int.tryParse(value);
    if (numType == double) return double.tryParse(value.replaceAll(',', '.'));
    return value;
  }

  /// Returns the [TextAlign] for a text field based on ui-schema options.
  static TextAlign getTextAlign(ui.Options? options) {
    return switch (options?.inputOptions?.textAlign) {
      ui.TextAlign.START => TextAlign.start,
      ui.TextAlign.END => TextAlign.end,
      ui.TextAlign.CENTER => TextAlign.center,
      ui.TextAlign.LEFT => TextAlign.left,
      ui.TextAlign.RIGHT => TextAlign.right,
      null => TextAlign.start,
    };
  }

  // ---------------------------------------------------------------------------
  // File helpers
  // ---------------------------------------------------------------------------

  /// Formats a byte count as a human-readable string (e.g. `"1.50 MB"`).
  static String formatFileSize(double bytes) {
    const kb = 1024.0;
    const mb = kb * 1024;
    const gb = mb * 1024;
    if (bytes >= gb) return '${(bytes / gb).toStringAsFixed(2)} GB';
    if (bytes >= mb) return '${(bytes / mb).toStringAsFixed(2)} MB';
    if (bytes >= kb) return '${(bytes / kb).toStringAsFixed(2)} KB';
    return '${bytes.toStringAsFixed(0)} B';
  }

  /// Parses accepted file extensions from
  /// `options.fileUploadOptions.acceptedFileType`.
  ///
  /// Returns `null` to allow all file types.
  static List<String>? getFileExtensions(ui.Options? options) {
    final acceptedFileType = options?.fileUploadOptions?.acceptedFileType;
    if (acceptedFileType == null) return null;
    final types = acceptedFileType.split(', ');
    if (types.contains('*')) return null;
    return types;
  }

  // ---------------------------------------------------------------------------
  // Enum helpers
  // ---------------------------------------------------------------------------

  /// Maps a list of enum [values] to `(value, label)` pairs using
  /// [enumTitles].  When no title is provided for a value its string
  /// representation is used as the label.
  ///
  /// This is a convenience re-export of [mapEnumValuesToTitles].
  static List<MapEntry<dynamic, String>> buildEnumEntries(
    List<dynamic> values,
    Map<String, String>? enumTitles,
  ) =>
      mapEnumValuesToTitles(values, enumTitles);

  /// Returns the [OptionsOrientation] to use for grouped radio/checkbox fields.
  static OptionsOrientation getOptionsOrientation(ui.Options? options) {
    return options?.enumOptions?.stacked == true ? OptionsOrientation.vertical : OptionsOrientation.wrap;
  }

  // ---------------------------------------------------------------------------
  // File picker helpers
  // ---------------------------------------------------------------------------

  /// Resolves file-picker configuration (max/min files, multi-upload flag)
  /// from [ctx]'s options and JSON schema.
  ///
  /// When `displayAsSingleUploadField` is `true` and the schema type is an
  /// array, multiple files are allowed and the array's `minItems` /
  /// `maxItems` become the file count limits.
  static ({int? maxFiles, int? minFiles, bool allowMultiple}) resolveFilePickerConfig(RenderContext ctx) {
    int? maxFiles = 1;
    int? minFiles;
    bool allowMultiple = false;
    if (ctx.options?.fileUploadOptions?.displayAsSingleUploadField == true && ctx.jsonSchema.type == SchemaType.array) {
      allowMultiple = true;
      if (ctx.jsonSchema.maxItems != null) maxFiles = ctx.jsonSchema.maxItems;
      if (ctx.jsonSchema.minItems != null) minFiles = ctx.jsonSchema.minItems;
    }
    return (maxFiles: maxFiles, minFiles: minFiles, allowMultiple: allowMultiple);
  }

  /// Returns the `onSaved` callback for a file-picker field.
  ///
  /// In multi-upload mode the full [List<PlatformFile>] is forwarded;
  /// otherwise only the first file is unwrapped and forwarded.
  static void Function(List<PlatformFile>?, {dynamic computedSelfIndices}) buildFilePickerOnSaved(
    RenderContext ctx,
  ) {
    return (value, {computedSelfIndices}) {
      final singleMode = ctx.options?.fileUploadOptions?.displayAsSingleUploadField == true;
      if (!singleMode && value != null && value.isNotEmpty) {
        ctx.onSavedCallback?.call(value[0], computedSelfIndices: computedSelfIndices);
      } else {
        ctx.onSavedCallback?.call(value, computedSelfIndices: computedSelfIndices);
      }
    };
  }

  /// Returns a [FormFieldValidator] for a file-picker field.
  ///
  /// Checks base constraints, optional max-file-size, and optional min-file
  /// count.  Localised error strings are obtained from [buildContext].
  static FormFieldValidator<List<PlatformFile>> createFilePickerValidator(
    RenderContext ctx,
    ({int? maxFiles, int? minFiles, bool allowMultiple}) config,
    BuildContext buildContext,
  ) {
    return (files) {
      final baseError = createBaseValidator(ctx)(files);
      if (baseError != null) return baseError;
      if (ctx.options?.fileUploadOptions?.maxFileSize != null && files != null) {
        final maxSize = ctx.options!.fileUploadOptions!.maxFileSize!;
        for (final file in files) {
          if (file.size > maxSize) {
            return buildContext.localize((l) => l.validateMaxFileSize(formatFileSize(maxSize.toDouble())));
          }
        }
      }
      if (config.minFiles != null && (files == null || files.length < config.minFiles!)) {
        return buildContext.localize((l) => l.validateMinItems(config.minFiles!));
      }
      return null;
    };
  }

  // ---------------------------------------------------------------------------
  // Slider helpers
  // ---------------------------------------------------------------------------

  /// Casts a raw slider [double] to the Dart type expected by [type].
  ///
  /// * [SchemaType.integer] → [int]
  /// * [SchemaType.number]  → [double]
  /// * anything else        → the raw [value] unchanged
  static dynamic castSliderValue(SchemaType? type, double? value) {
    return switch (type) {
      SchemaType.integer => value?.toInt(),
      SchemaType.number => value?.toDouble(),
      _ => value,
    };
  }
}
