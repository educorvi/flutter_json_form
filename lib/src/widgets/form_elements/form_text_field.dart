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

  FormFieldValidator<String> _composeValidator() {
    return FormBuilderValidators.compose([
      FormFieldUtils.createBaseValidator(widget.formFieldContext),
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
    ]);
  }

  Iterable<String>? _getAutocompleteValues() {
    if (widget.formFieldContext.options?.fieldSpecificOptions?.autocomplete != null) {
      switch (widget.formFieldContext.options!.fieldSpecificOptions!.autocomplete!) {
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
}
