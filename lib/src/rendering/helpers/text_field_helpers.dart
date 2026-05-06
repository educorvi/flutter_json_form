import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:flutter_json_forms/src/rendering/helpers/render_helpers.dart';
import 'package:flutter_json_forms/src/rendering/render_context.dart';
import 'package:flutter_json_forms/src/utils/parse.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

/// Helpers specific to text / numeric input fields.
///
/// All methods work with [RenderContext] so they can be used by custom
/// [JsonFormRenderer] implementations as well as the built-in [FormTextField].
///
/// See also: [RenderHelpers] for shared helpers used across all control types.
class TextFieldHelpers {
  TextFieldHelpers._();

  // ---------------------------------------------------------------------------
  // Autocomplete / autofill
  // ---------------------------------------------------------------------------

  /// Maps the `options.inputOptions.autocomplete` value to the corresponding
  /// [AutofillHints] strings understood by Flutter's autofill service.
  ///
  /// Returns `null` when autocomplete is disabled, unset, or has no Flutter
  /// equivalent.
  static Iterable<String>? getAutocompleteValues(ui.Options? options) {
    final autocomplete = options?.inputOptions?.autocomplete;
    if (autocomplete == null) return null;

    switch (autocomplete) {
      case ui.Autocomplete.OFF:
        return null;
      case ui.Autocomplete.ON:
        return null;
      case ui.Autocomplete.NAME:
        return [AutofillHints.name];
      case ui.Autocomplete.HONORIFIC_PREFIX:
        return [AutofillHints.namePrefix];
      case ui.Autocomplete.GIVEN_NAME:
        return null;
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
        return [AutofillHints.organizationName];
      case ui.Autocomplete.STREET_ADDRESS:
        return null;
      case ui.Autocomplete.SHIPPING:
        return null;
      case ui.Autocomplete.BILLING:
        return null;
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
        return null;
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
        return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Validator composition
  // ---------------------------------------------------------------------------

  /// Composes a complete [FormFieldValidator] for a text/number field by
  /// combining the base visibility+required validator with all relevant JSON
  /// Schema constraints (min, max, minLength, maxLength, pattern, format
  /// email/tel/url, and numeric type check).
  static FormFieldValidator<String> composeValidator(
    RenderContext ctx,
    Type numType,
  ) {
    return FormBuilderValidators.compose([
      RenderHelpers.createBaseValidator(ctx),
      if (numType == int || numType == double) FormBuilderValidators.numeric(checkNullOrEmpty: false),
      if (ctx.jsonSchema.minimum != null)
        FormBuilderValidators.min(
          safeParseNum(ctx.jsonSchema.minimum),
          checkNullOrEmpty: false,
        ),
      if (ctx.jsonSchema.maximum != null)
        FormBuilderValidators.max(
          safeParseNum(ctx.jsonSchema.maximum),
          checkNullOrEmpty: false,
        ),
      if (ctx.jsonSchema.minLength != null)
        FormBuilderValidators.minLength(
          safeParseInt(ctx.jsonSchema.minLength),
          checkNullOrEmpty: false,
        ),
      if (ctx.jsonSchema.maxLength != null)
        FormBuilderValidators.maxLength(
          safeParseInt(ctx.jsonSchema.maxLength),
          checkNullOrEmpty: false,
        ),
      if (ctx.jsonSchema.pattern != null)
        FormBuilderValidators.match(
          ctx.jsonSchema.pattern!,
          checkNullOrEmpty: false,
        ),
      if (ctx.format == ui.Format.EMAIL) FormBuilderValidators.email(checkNullOrEmpty: false),
      if (ctx.format == ui.Format.TEL) FormBuilderValidators.phoneNumber(checkNullOrEmpty: false),
      if (ctx.format == ui.Format.URL) FormBuilderValidators.url(checkNullOrEmpty: false),
    ]);
  }
}
