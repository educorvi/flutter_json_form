import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter/services.dart';
import 'package:json_schema/json_schema.dart';

import '../../../src/models/ui_schema.dart' as ui;
import '../../../src/utils/parse.dart';
import '../../../src/utils/validators/validators.dart';

class JsonFormTextField extends StatefulWidget {
  final String id;
  final JsonSchema jsonSchema;
  final ui.ControlOptions? options;
  final ui.Format? format;
  final bool required;
  final dynamic initialValue;
  final bool enabled;
  final void Function(dynamic)? onChanged;
  final void Function(dynamic)? onSavedCallback;
  final SchemaType? type;

  const JsonFormTextField({
    super.key,
    required this.id,
    required this.jsonSchema,
    this.options,
    this.format,
    this.required = false,
    this.initialValue,
    this.enabled = true,
    this.onChanged,
    this.onSavedCallback,
    this.type,
  });

  @override
  State<JsonFormTextField> createState() => _JsonFormTextFieldState();
}

class _JsonFormTextFieldState extends State<JsonFormTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.format == ui.Format.PASSWORD;
  }

  int getLines() {
    final opts = widget.options?.fieldSpecificOptions;
    if (opts?.multi != null) {
      if (opts!.multi is bool) {
        return opts.multi ? 2 : 1;
      } else if (opts.multi is int) {
        return opts.multi;
      }
    }
    return 1;
  }

  TextInputType getKeyboardType(int maxLines) {
    final format = widget.format;
    final type = widget.type;
    if (maxLines > 1) return TextInputType.multiline;
    switch (format) {
      case ui.Format.EMAIL:
        return TextInputType.emailAddress;
      case ui.Format.PASSWORD:
        return TextInputType.visiblePassword;
      case ui.Format.SEARCH:
        return TextInputType.text;
      case ui.Format.URL:
        return TextInputType.url;
      case ui.Format.TEL:
        return TextInputType.phone;
      default:
        if (type == SchemaType.integer || type == SchemaType.number) {
          return TextInputType.number;
        }
        return TextInputType.text;
    }
  }

  Iterable<String>? getAutocompleteValues() {
    final opts = widget.options?.fieldSpecificOptions;
    if (opts?.autocomplete != null) {
      switch (opts!.autocomplete!) {
        case ui.Autocomplete.OFF:
          return null; // don't autofill
        case ui.Autocomplete.ON:
          return null; // finding a best match is not implemented
        case ui.Autocomplete.NAME:
          return [AutofillHints.name];
        case ui.Autocomplete.HONORIFIC_PREFIX:
          return [AutofillHints.namePrefix];
        case ui.Autocomplete.GIVEN_NAME:
          return null; // not found
        case ui.Autocomplete.ADDITIONAL_NAME:
          return [AutofillHints.givenName];
        case ui.Autocomplete.FAMILY_NAME:
          return [AutofillHints.familyName];
        case ui.Autocomplete.HONORIFIC_SUFFIX:
          return [AutofillHints.nameSuffix];
        case ui.Autocomplete.NICKNAME:
          return [AutofillHints.nickname];
        case ui.Autocomplete.EMAIL:
          return [AutofillHints.email];
        case ui.Autocomplete.USERNAME:
          return [AutofillHints.username];
        case ui.Autocomplete.NEW_PASSWORD:
          return [AutofillHints.newPassword];
        case ui.Autocomplete.CURRENT_PASSWORD:
          return [AutofillHints.password];
        case ui.Autocomplete.ONE_TIME_CODE:
          return [AutofillHints.oneTimeCode];
        case ui.Autocomplete.ORGANIZATION_TITLE:
          return [AutofillHints.organizationName];
        case ui.Autocomplete.ORGANIZATION:
          return [AutofillHints.organizationName]; // best fit
        case ui.Autocomplete.STREET_ADDRESS:
          return null; // not found
        case ui.Autocomplete.SHIPPING:
          return null; // not found
        case ui.Autocomplete.BILLING:
          return null; // not found
        case ui.Autocomplete.ADDRESS_LINE1:
          return [AutofillHints.streetAddressLine1];
        case ui.Autocomplete.ADDRESS_LINE2:
          return [AutofillHints.streetAddressLine2];
        case ui.Autocomplete.ADDRESS_LINE3:
          return [AutofillHints.streetAddressLine3];
        case ui.Autocomplete.ADDRESS_LEVEL1:
          return [AutofillHints.streetAddressLevel1];
        case ui.Autocomplete.ADDRESS_LEVEL2:
          return [AutofillHints.streetAddressLevel2];
        case ui.Autocomplete.ADDRESS_LEVEL3:
          return [AutofillHints.streetAddressLevel3];
        case ui.Autocomplete.ADDRESS_LEVEL4:
          return [AutofillHints.streetAddressLevel4];
        case ui.Autocomplete.COUNTRY:
          return [AutofillHints.countryCode];
        case ui.Autocomplete.COUNTRY_NAME:
          return [AutofillHints.countryName];
        case ui.Autocomplete.POSTAL_CODE:
          return [AutofillHints.postalCode];
        case ui.Autocomplete.CC_NAME:
          return [AutofillHints.creditCardName];
        case ui.Autocomplete.CC_GIVEN_NAME:
          return [AutofillHints.creditCardGivenName];
        case ui.Autocomplete.CC_ADDITIONAL_NAME:
          return null; // not found
        case ui.Autocomplete.CC_FAMILY_NAME:
          return [AutofillHints.creditCardFamilyName];
        case ui.Autocomplete.CC_NUMBER:
          return [AutofillHints.creditCardNumber];
        case ui.Autocomplete.CC_EXP:
          return [AutofillHints.creditCardExpirationDate];
        case ui.Autocomplete.CC_EXP_MONTH:
          return [AutofillHints.creditCardExpirationMonth];
        case ui.Autocomplete.CC_EXP_YEAR:
          return [AutofillHints.creditCardExpirationYear];
        case ui.Autocomplete.CC_CSC:
          return [AutofillHints.creditCardSecurityCode];
        case ui.Autocomplete.CC_TYPE:
          return [AutofillHints.creditCardType];
        case ui.Autocomplete.TRANSACTION_CURRENCY:
          return [AutofillHints.transactionCurrency];
        case ui.Autocomplete.TRANSACTION_AMOUNT:
          return [AutofillHints.transactionAmount];
        case ui.Autocomplete.LANGUAGE:
          return [AutofillHints.language];
        case ui.Autocomplete.BDAY:
          return [AutofillHints.birthday];
        case ui.Autocomplete.BDAY_DAY:
          return [AutofillHints.birthdayDay];
        case ui.Autocomplete.BDAY_MONTH:
          return [AutofillHints.birthdayMonth];
        case ui.Autocomplete.BDAY_YEAR:
          return [AutofillHints.birthdayYear];
        case ui.Autocomplete.SEX:
          return [AutofillHints.gender];
        case ui.Autocomplete.TEL:
          return [AutofillHints.telephoneNumber];
        case ui.Autocomplete.TEL_COUNTRY_CODE:
          return [AutofillHints.telephoneNumberCountryCode];
        case ui.Autocomplete.TEL_NATIONAL:
          return [AutofillHints.telephoneNumberNational];
        case ui.Autocomplete.TEL_AREA_CODE:
          return [AutofillHints.telephoneNumberAreaCode];
        case ui.Autocomplete.TEL_LOCAL:
          return [AutofillHints.telephoneNumberLocal];
        case ui.Autocomplete.TEL_EXTENSION:
          return [AutofillHints.telephoneNumberExtension];
        case ui.Autocomplete.IMPP:
          return [AutofillHints.impp];
        case ui.Autocomplete.URL:
          return [AutofillHints.url];
        case ui.Autocomplete.PHOTO:
          return [AutofillHints.photo];
        case ui.Autocomplete.WEBAUTHN:
          return null; // not found
      }
    }
    return null;
  }

  TextAlign getTextAlign() {
    switch (widget.options?.fieldSpecificOptions?.textAlign) {
      case ui.TextAlign.START:
        return TextAlign.start;
      case ui.TextAlign.END:
        return TextAlign.end;
      case ui.TextAlign.CENTER:
        return TextAlign.center;
      case ui.TextAlign.LEFT:
        return TextAlign.left;
      case ui.TextAlign.RIGHT:
        return TextAlign.right;
      default:
        return TextAlign.start;
    }
  }

  String getInitialValueString() {
    if (widget.initialValue != null) {
      try {
        return widget.initialValue.toString();
      } catch (_) {}
    }
    return "";
  }

  InputDecoration getInputDecoration() {
    return InputDecoration(
      labelText: widget.jsonSchema.title,
      hintText: widget.options?.formattingOptions?.placeholder,
      suffixIcon: widget.format == ui.Format.PASSWORD
          ? IconButton(
              icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
          : null,
    );
  }

  FormFieldValidator<String> getValidator() {
    final jsonSchema = widget.jsonSchema;
    final options = widget.options;
    final format = widget.format;
    final type = widget.type;
    final required = widget.required;

    return FormBuilderValidators.compose([
      if (required) FormBuilderValidators.required(),
      if (type == SchemaType.number || type == SchemaType.integer) FormBuilderValidators.numeric(checkNullOrEmpty: false),
      if (jsonSchema.minimum != null) FormBuilderValidators.min(safeParseNum(jsonSchema.minimum), checkNullOrEmpty: false),
      if (jsonSchema.maximum != null) FormBuilderValidators.max(safeParseNum(jsonSchema.maximum), checkNullOrEmpty: false),
      if (jsonSchema.exclusiveMinimum != null)
        FormBuilderValidators.min(safeParseNum(jsonSchema.exclusiveMinimum), inclusive: false, checkNullOrEmpty: false),
      if (jsonSchema.exclusiveMaximum != null)
        FormBuilderValidators.max(safeParseNum(jsonSchema.exclusiveMaximum), inclusive: false, checkNullOrEmpty: false),
      if (jsonSchema.multipleOf != null)
        JsonSchemaValidators.multipleOf<dynamic>(
          safeParseNum(jsonSchema.multipleOf),
        ),
      if (jsonSchema.minLength != null) FormBuilderValidators.minLength(safeParseInt(jsonSchema.minLength), checkNullOrEmpty: false),
      if (jsonSchema.maxLength != null) FormBuilderValidators.maxLength(safeParseInt(jsonSchema.maxLength), checkNullOrEmpty: false),
      if (jsonSchema.pattern != null) FormBuilderValidators.match(jsonSchema.pattern!, checkNullOrEmpty: false),
      if (options?.fieldSpecificOptions?.format == ui.Format.EMAIL) FormBuilderValidators.email(checkNullOrEmpty: false),
      if (options?.fieldSpecificOptions?.format == ui.Format.PASSWORD) FormBuilderValidators.password(checkNullOrEmpty: false),
      if (options?.fieldSpecificOptions?.format == ui.Format.TEL) FormBuilderValidators.phoneNumber(checkNullOrEmpty: false),
      if (options?.fieldSpecificOptions?.format == ui.Format.URL) FormBuilderValidators.url(checkNullOrEmpty: false),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final maxLines = getLines();
    return FormBuilderTextField(
      name: widget.id,
      initialValue: getInitialValueString(),
      enabled: widget.enabled,
      obscureText: _obscureText,
      maxLines: maxLines,
      keyboardType: getKeyboardType(maxLines),
      autofillHints: getAutocompleteValues(),
      textAlign: getTextAlign(),
      decoration: getInputDecoration(),
      onSubmitted: widget.onChanged,
      onSaved: widget.onSavedCallback,
      validator: getValidator(),
      textInputAction: maxLines > 1 ? TextInputAction.newline : null,
    );
  }
}
