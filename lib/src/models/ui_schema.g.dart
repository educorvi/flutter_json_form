// To parse this JSON data, do
//
//     final arrayOptions = arrayOptionsFromJson(jsonString);
//     final baseVariants = baseVariantsFromJson(jsonString);
//     final button = buttonFromJson(jsonString);
//     final buttongroup = buttongroupFromJson(jsonString);
//     final buttonOptions = buttonOptionsFromJson(jsonString);
//     final colorVariants = colorVariantsFromJson(jsonString);
//     final commonEnumOptions = commonEnumOptionsFromJson(jsonString);
//     final control = controlFromJson(jsonString);
//     final controlFormattingOptions = controlFormattingOptionsFromJson(jsonString);
//     final descendantControlOverride = descendantControlOverrideFromJson(jsonString);
//     final descendantControlOverrides = descendantControlOverridesFromJson(jsonString);
//     final displayAs = displayAsFromJson(jsonString);
//     final divider = dividerFromJson(jsonString);
//     final elements = elementsFromJson(jsonString);
//     final enumOptions = enumOptionsFromJson(jsonString);
//     final fileUploadOptions = fileUploadOptionsFromJson(jsonString);
//     final htmlRenderer = htmlRendererFromJson(jsonString);
//     final inputOptions = inputOptionsFromJson(jsonString);
//     final layout = layoutFromJson(jsonString);
//     final layoutElement = layoutElementFromJson(jsonString);
//     final legacyShowOnProperty = legacyShowOnPropertyFromJson(jsonString);
//     final now = nowFromJson(jsonString);
//     final options = optionsFromJson(jsonString);
//     final outlineVariants = outlineVariantsFromJson(jsonString);
//     final rule = ruleFromJson(jsonString);
//     final showOnFunctionType = showOnFunctionTypeFromJson(jsonString);
//     final showOnProperty = showOnPropertyFromJson(jsonString);
//     final submitOptions = submitOptionsFromJson(jsonString);
//     final tagOptions = tagOptionsFromJson(jsonString);
//     final text2 = text2FromJson(jsonString);
//     final theButtonsType = theButtonsTypeFromJson(jsonString);
//     final titlesForEnum = titlesForEnumFromJson(jsonString);
//     final uiSchema = uiSchemaFromJson(jsonString);
//     final wizard = wizardFromJson(jsonString);

import 'dart:convert';

ArrayOptions arrayOptionsFromJson(String str) => ArrayOptions.fromJson(json.decode(str));

String arrayOptionsToJson(ArrayOptions data) => json.encode(data.toJson());

BaseVariants baseVariantsFromJson(String str) => baseVariantsValues.map[json.decode(str)]!;

String baseVariantsToJson(BaseVariants data) => json.encode(baseVariantsValues.reverse[data]);

Button buttonFromJson(String str) => Button.fromJson(json.decode(str));

String buttonToJson(Button data) => json.encode(data.toJson());

Buttongroup buttongroupFromJson(String str) => Buttongroup.fromJson(json.decode(str));

String buttongroupToJson(Buttongroup data) => json.encode(data.toJson());

ButtonOptions buttonOptionsFromJson(String str) => ButtonOptions.fromJson(json.decode(str));

String buttonOptionsToJson(ButtonOptions data) => json.encode(data.toJson());

ColorVariants colorVariantsFromJson(String str) => colorVariantsValues.map[json.decode(str)]!;

String colorVariantsToJson(ColorVariants data) => json.encode(colorVariantsValues.reverse[data]);

EnumOptions commonEnumOptionsFromJson(String str) => EnumOptions.fromJson(json.decode(str));

String commonEnumOptionsToJson(EnumOptions data) => json.encode(data.toJson());

Control controlFromJson(String str) => Control.fromJson(json.decode(str));

String controlToJson(Control data) => json.encode(data.toJson());

ControlFormattingOptions controlFormattingOptionsFromJson(String str) => ControlFormattingOptions.fromJson(json.decode(str));

String controlFormattingOptionsToJson(ControlFormattingOptions data) => json.encode(data.toJson());

DescendantControlOverrides descendantControlOverrideFromJson(String str) => DescendantControlOverrides.fromJson(json.decode(str));

String descendantControlOverrideToJson(DescendantControlOverrides data) => json.encode(data.toJson());

Map<String, DescendantControlOverrides> descendantControlOverridesFromJson(String str) =>
    Map.from(json.decode(str)).map((k, v) => MapEntry<String, DescendantControlOverrides>(k, DescendantControlOverrides.fromJson(v)));

String descendantControlOverridesToJson(Map<String, DescendantControlOverrides> data) =>
    json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

DisplayAs displayAsFromJson(String str) => displayAsValues.map[json.decode(str)]!;

String displayAsToJson(DisplayAs data) => json.encode(displayAsValues.reverse[data]);

Divider dividerFromJson(String str) => Divider.fromJson(json.decode(str));

String dividerToJson(Divider data) => json.encode(data.toJson());

List<LayoutElement> elementsFromJson(String str) => List<LayoutElement>.from(json.decode(str).map((x) => LayoutElement.fromJson(x)));

String elementsToJson(List<LayoutElement> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

EnumOptions enumOptionsFromJson(String str) => EnumOptions.fromJson(json.decode(str));

String enumOptionsToJson(EnumOptions data) => json.encode(data.toJson());

FileUploadOptions fileUploadOptionsFromJson(String str) => FileUploadOptions.fromJson(json.decode(str));

String fileUploadOptionsToJson(FileUploadOptions data) => json.encode(data.toJson());

HtmlRenderer htmlRendererFromJson(String str) => HtmlRenderer.fromJson(json.decode(str));

String htmlRendererToJson(HtmlRenderer data) => json.encode(data.toJson());

InputOptions inputOptionsFromJson(String str) => InputOptions.fromJson(json.decode(str));

String inputOptionsToJson(InputOptions data) => json.encode(data.toJson());

Layout layoutFromJson(String str) => Layout.fromJson(json.decode(str));

String layoutToJson(Layout data) => json.encode(data.toJson());

LayoutElement layoutElementFromJson(String str) => LayoutElement.fromJson(json.decode(str));

String layoutElementToJson(LayoutElement data) => json.encode(data.toJson());

LegacyShowOnProperty legacyShowOnPropertyFromJson(String str) => LegacyShowOnProperty.fromJson(json.decode(str));

String legacyShowOnPropertyToJson(LegacyShowOnProperty data) => json.encode(data.toJson());

Now nowFromJson(String str) => Now.fromJson(json.decode(str));

String nowToJson(Now data) => json.encode(data.toJson());

Options optionsFromJson(String str) => Options.fromJson(json.decode(str));

String optionsToJson(Options data) => json.encode(data.toJson());

OutlineVariants outlineVariantsFromJson(String str) => outlineVariantsValues.map[json.decode(str)]!;

String outlineVariantsToJson(OutlineVariants data) => json.encode(outlineVariantsValues.reverse[data]);

Rule ruleFromJson(String str) => Rule.fromJson(json.decode(str));

String ruleToJson(Rule data) => json.encode(data.toJson());

ShowOnFunctionType showOnFunctionTypeFromJson(String str) => showOnFunctionTypeValues.map[json.decode(str)]!;

String showOnFunctionTypeToJson(ShowOnFunctionType data) => json.encode(showOnFunctionTypeValues.reverse[data]);

ShowOnProperty showOnPropertyFromJson(String str) => ShowOnProperty.fromJson(json.decode(str));

String showOnPropertyToJson(ShowOnProperty data) => json.encode(data.toJson());

SubmitOptions submitOptionsFromJson(String str) => SubmitOptions.fromJson(json.decode(str));

String submitOptionsToJson(SubmitOptions data) => json.encode(data.toJson());

TagOptions tagOptionsFromJson(String str) => TagOptions.fromJson(json.decode(str));

String tagOptionsToJson(TagOptions data) => json.encode(data.toJson());

String text2FromJson(String str) => json.decode(str);

String text2ToJson(String data) => json.encode(data);

TheButtonsType theButtonsTypeFromJson(String str) => theButtonsTypeValues.map[json.decode(str)]!;

String theButtonsTypeToJson(TheButtonsType data) => json.encode(theButtonsTypeValues.reverse[data]);

Map<String, String> titlesForEnumFromJson(String str) => Map.from(json.decode(str)).map((k, v) => MapEntry<String, String>(k, v));

String titlesForEnumToJson(Map<String, String> data) => json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v)));

UiSchema uiSchemaFromJson(String str) => UiSchema.fromJson(json.decode(str));

String uiSchemaToJson(UiSchema data) => json.encode(data.toJson());

Wizard wizardFromJson(String str) => Wizard.fromJson(json.decode(str));

String wizardToJson(Wizard data) => json.encode(data.toJson());

class ArrayOptions {
  ///Text for the add button
  String? addButtonText;

  ArrayOptions({this.addButtonText});

  factory ArrayOptions.fromJson(Map<String, dynamic> json) => ArrayOptions(addButtonText: json["addButtonText"]);

  Map<String, dynamic> toJson() => {"addButtonText": addButtonText};
}

///Used to group buttons
class Buttongroup implements LayoutElement {
  ///The buttons in the button group
  List<Button> buttons;
  ButtongroupOptions? options;

  ///Show field depending on value of other field
  ShowOnProperty? showOn;
  ButtongroupType type;

  Buttongroup({
    required this.buttons,
    this.options,
    this.showOn,
    required this.type,
  });

  factory Buttongroup.fromJson(Map<String, dynamic> json) => Buttongroup(
        buttons: List<Button>.from(json["buttons"].map((x) => Button.fromJson(x))),
        options: json["options"] == null ? null : ButtongroupOptions.fromJson(json["options"]),
        showOn: json["showOn"] == null ? null : ShowOnProperty.fromJson(json["showOn"]),
        type: buttongroupTypeValues.map[json["type"]]!,
      );

  Map<String, dynamic> toJson() => {
        "buttons": List<dynamic>.from(buttons.map((x) => x.toJson())),
        "options": options?.toJson(),
        "showOn": showOn?.toJson(),
        "type": buttongroupTypeValues.reverse[type],
      };
}

///Used to put a button into the form
class Button implements LayoutElement {
  TheButtonsType buttonType;

  ///Options for the button
  ButtonOptions? options;

  ///Show field depending on value of other field
  ShowOnProperty? showOn;

  ///The buttons text
  String text;
  ButtonType type;

  Button({
    required this.buttonType,
    this.options,
    this.showOn,
    required this.text,
    required this.type,
  });

  factory Button.fromJson(Map<String, dynamic> json) => Button(
        buttonType: theButtonsTypeValues.map[json["buttonType"]]!,
        options: json["options"] == null ? null : ButtonOptions.fromJson(json["options"]),
        showOn: json["showOn"] == null ? null : ShowOnProperty.fromJson(json["showOn"]),
        text: json["text"],
        type: buttonTypeValues.map[json["type"]]!,
      );

  Map<String, dynamic> toJson() => {
        "buttonType": theButtonsTypeValues.reverse[buttonType],
        "options": options?.toJson(),
        "showOn": showOn?.toJson(),
        "text": text,
        "type": buttonTypeValues.reverse[type],
      };
}

///Submit or Reset
enum TheButtonsType { NEXT_WIZARD_PAGE, PREVIOUS_WIZARD_PAGE, RESET, SUBMIT }

final theButtonsTypeValues = EnumValues({
  "nextWizardPage": TheButtonsType.NEXT_WIZARD_PAGE,
  "previousWizardPage": TheButtonsType.PREVIOUS_WIZARD_PAGE,
  "reset": TheButtonsType.RESET,
  "submit": TheButtonsType.SUBMIT,
});

///Options for the button
class ButtonOptions {
  ///The layout's CSS classes
  String? cssClass;

  ///Specifies that the form-data should not be validated on submission
  bool? formnovalidate;

  ///Options that are passed to the submit function. This will not change the behaviour of
  ///VueJsonForm itself, but can bes used by the application/the webcomponent to change the
  ///behaviour of the submit function.
  SubmitOptions? submitOptions;

  ///Different color variants
  ColorVariants? variant;

  ButtonOptions({
    this.cssClass,
    this.formnovalidate,
    this.submitOptions,
    this.variant,
  });

  factory ButtonOptions.fromJson(Map<String, dynamic> json) => ButtonOptions(
        cssClass: json["cssClass"],
        formnovalidate: json["formnovalidate"],
        submitOptions: json["submitOptions"] == null ? null : SubmitOptions.fromJson(json["submitOptions"]),
        variant: colorVariantsValues.map[json["variant"]],
      );

  Map<String, dynamic> toJson() => {
        "cssClass": cssClass,
        "formnovalidate": formnovalidate,
        "submitOptions": submitOptions?.toJson(),
        "variant": colorVariantsValues.reverse[variant],
      };
}

///Options that are passed to the submit function. This will not change the behaviour of
///VueJsonForm itself, but can bes used by the application/the webcomponent to change the
///behaviour of the submit function.
class SubmitOptions {
  ///Action to perform when the button is clicked
  String? action;

  ///Settings for request actions
  Request? request;

  SubmitOptions({this.action, this.request});

  factory SubmitOptions.fromJson(Map<String, dynamic> json) => SubmitOptions(
        action: json["action"],
        request: json["request"] == null ? null : Request.fromJson(json["request"]),
      );

  Map<String, dynamic> toJson() => {
        "action": action,
        "request": request?.toJson(),
      };
}

///Settings for request actions
class Request {
  ///Headers to include in the request
  Map<String, String>? headers;

  ///The HTTP method to use for the request
  Method? method;

  ///URL to redirect to after successful request
  String? onSuccessRedirect;

  ///The URL to send the request to
  String url;

  Request({
    this.headers,
    this.method,
    this.onSuccessRedirect,
    required this.url,
  });

  factory Request.fromJson(Map<String, dynamic> json) => Request(
        headers: json["headers"] == null ? null : Map<String, String>.from(json["headers"]),
        method: methodValues.map[json["method"]],
        onSuccessRedirect: json["onSuccessRedirect"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "headers": headers == null ? null : Map<String, dynamic>.from(headers!),
        "method": methodValues.reverse[method]!,
        "onSuccessRedirect": onSuccessRedirect,
        "url": url,
      };
}

///The HTTP method to use for the request
enum Method { DELETE, GET, POST, PUT }

final methodValues = EnumValues({
  "DELETE": Method.DELETE,
  "GET": Method.GET,
  "POST": Method.POST,
  "PUT": Method.PUT,
});

///Different color variants
enum ColorVariants {
  DANGER,
  DARK,
  INFO,
  LIGHT,
  OUTLINE_DANGER,
  OUTLINE_DARK,
  OUTLINE_INFO,
  OUTLINE_LIGHT,
  OUTLINE_PRIMARY,
  OUTLINE_SECONDARY,
  OUTLINE_SUCCESS,
  OUTLINE_WARNING,
  PRIMARY,
  SECONDARY,
  SUCCESS,
  WARNING,
}

final colorVariantsValues = EnumValues({
  "danger": ColorVariants.DANGER,
  "dark": ColorVariants.DARK,
  "info": ColorVariants.INFO,
  "light": ColorVariants.LIGHT,
  "outline-danger": ColorVariants.OUTLINE_DANGER,
  "outline-dark": ColorVariants.OUTLINE_DARK,
  "outline-info": ColorVariants.OUTLINE_INFO,
  "outline-light": ColorVariants.OUTLINE_LIGHT,
  "outline-primary": ColorVariants.OUTLINE_PRIMARY,
  "outline-secondary": ColorVariants.OUTLINE_SECONDARY,
  "outline-success": ColorVariants.OUTLINE_SUCCESS,
  "outline-warning": ColorVariants.OUTLINE_WARNING,
  "primary": ColorVariants.PRIMARY,
  "secondary": ColorVariants.SECONDARY,
  "success": ColorVariants.SUCCESS,
  "warning": ColorVariants.WARNING,
});

///Show field depending on value of other field
///
///Legacy Variant of defining ShowOn property
class ShowOnProperty {
  ///The field this field depends on in object notation
  String? path;

  ///The value the field from scope is compared against
  dynamic referenceValue;
  ShowOnFunctionType? type;

  ///A comment about what the rule does
  String? comment;
  String? id;
  dynamic rule;

  ShowOnProperty({
    this.path,
    this.referenceValue,
    this.type,
    this.comment,
    this.id,
    this.rule,
  });

  factory ShowOnProperty.fromJson(Map<String, dynamic> json) => ShowOnProperty(
        path: json["path"],
        referenceValue: json["referenceValue"],
        type: showOnFunctionTypeValues.map[json["type"]],
        comment: json["comment"],
        id: json["id"],
        rule: json["rule"],
      );

  Map<String, dynamic> toJson() => {
        "path": path,
        "referenceValue": referenceValue,
        "type": showOnFunctionTypeValues.reverse[type],
        "comment": comment,
        "id": id,
        "rule": rule,
      };
}

///Condition to be applied
enum ShowOnFunctionType {
  EQUALS,
  GREATER,
  GREATER_OR_EQUAL,
  NOT_EQUALS,
  SMALLER,
  SMALLER_OR_EQUAL,
}

final showOnFunctionTypeValues = EnumValues({
  "EQUALS": ShowOnFunctionType.EQUALS,
  "GREATER": ShowOnFunctionType.GREATER,
  "GREATER_OR_EQUAL": ShowOnFunctionType.GREATER_OR_EQUAL,
  "NOT_EQUALS": ShowOnFunctionType.NOT_EQUALS,
  "SMALLER": ShowOnFunctionType.SMALLER,
  "SMALLER_OR_EQUAL": ShowOnFunctionType.SMALLER_OR_EQUAL,
});

enum ButtonType { BUTTON }

final buttonTypeValues = EnumValues({"Button": ButtonType.BUTTON});

class ButtongroupOptions {
  ///Display the buttons vertical
  bool? vertical;

  ButtongroupOptions({this.vertical});

  factory ButtongroupOptions.fromJson(Map<String, dynamic> json) => ButtongroupOptions(
        vertical: json["vertical"],
      );

  Map<String, dynamic> toJson() => {"vertical": vertical};
}

enum ButtongroupType { BUTTONGROUP }

final buttongroupTypeValues = EnumValues({
  "Buttongroup": ButtongroupType.BUTTONGROUP,
});

class EnumOptions {
  ///Different color variants
  ColorVariants? buttonVariant;

  ///Choose how an enum should be displayed
  DisplayAs? displayAs;

  ///If the text in a enums select field is supposed to differ from the keys, they can be
  ///specified as properties of this object. The value in the enum must be used as property
  ///name
  Map<String, String>? enumTitles;

  ///Use rita rules to conditionally display options. If a rule is set for an option, then it
  ///will only be displayed, if the rule is fulfilled. The option value is to be used as a key
  ///in the object.
  Map<String, Rule>? optionFilters;

  ///Radiobutton-/Checkbox group will be stacked if set to true
  bool? stacked;

  EnumOptions({
    this.buttonVariant,
    this.displayAs,
    this.enumTitles,
    this.optionFilters,
    this.stacked,
  });

  factory EnumOptions.fromJson(Map<String, dynamic> json) => EnumOptions(
        buttonVariant: colorVariantsValues.map[json["buttonVariant"]],
        displayAs: displayAsValues.map[json["displayAs"]],
        enumTitles: json["enumTitles"] == null
            ? null
            : Map.from(
                json["enumTitles"],
              ).map((k, v) => MapEntry<String, String>(k, v)),
        optionFilters: json["optionFilters"] == null
            ? null
            : Map.from(
                json["optionFilters"],
              ).map((k, v) => MapEntry<String, Rule>(k, Rule.fromJson(v))),
        stacked: json["stacked"],
      );

  Map<String, dynamic> toJson() => {
        "buttonVariant": colorVariantsValues.reverse[buttonVariant],
        "displayAs": displayAsValues.reverse[displayAs],
        "enumTitles": enumTitles == null ? null : Map<String, dynamic>.from(enumTitles!),
        "optionFilters":
            optionFilters == null ? null : Map<String, dynamic>.from(optionFilters!.map((k, v) => MapEntry<String, dynamic>(k, v.toJson()))),
        "stacked": stacked,
      };
}

///Choose how an enum should be displayed
enum DisplayAs { BUTTONS, RADIOBUTTONS, SELECT, SWITCHES }

final displayAsValues = EnumValues({
  "buttons": DisplayAs.BUTTONS,
  "radiobuttons": DisplayAs.RADIOBUTTONS,
  "select": DisplayAs.SELECT,
  "switches": DisplayAs.SWITCHES,
});

class Rule {
  ///A comment about what the rule does
  String? comment;
  String id;
  dynamic rule;

  Rule({this.comment, required this.id, required this.rule});

  factory Rule.fromJson(Map<String, dynamic> json) => Rule(comment: json["comment"], id: json["id"], rule: json["rule"]);

  Map<String, dynamic> toJson() => {"comment": comment, "id": id, "rule": rule};
}

/// Manually crated because dart doesn't support & union types
/// To use most of the automatically generated classes for each & part class, a separate getter is created
/// Union classes: [TagOptions], [EnumOptions], [FileUploadOptions], [ArrayOptions], [InputOptions], [ControlFormattingOptions]
class Options {
  final TagOptions? tagOptions;
  final EnumOptions? enumOptions;
  final FileUploadOptions? fileUploadOptions;
  final ArrayOptions? arrayOptions;
  final InputOptions? inputOptions;
  final ControlFormattingOptions? formattingOptions;

  Options({
    this.tagOptions,
    this.enumOptions,
    this.fileUploadOptions,
    this.arrayOptions,
    this.inputOptions,
    this.formattingOptions,
  });

  factory Options.fromJson(Map<String, dynamic> json) => Options(
        tagOptions: TagOptions.fromJson(json),
        enumOptions: EnumOptions.fromJson(json),
        fileUploadOptions: FileUploadOptions.fromJson(json),
        arrayOptions: ArrayOptions.fromJson(json),
        inputOptions: InputOptions.fromJson(json),
        formattingOptions: ControlFormattingOptions.fromJson(json),
      );

  Map<String, dynamic> toJson() {
    return {
      ...?tagOptions?.toJson(),
      ...?enumOptions?.toJson(),
      ...?fileUploadOptions?.toJson(),
      ...?arrayOptions?.toJson(),
      ...?inputOptions?.toJson(),
      ...?formattingOptions?.toJson(),
    };
  }
}

///Contains a form element, e. g. a text input
class Control implements LayoutElement {
  ///Gives multiple options to configure the element
  Options? options;

  ///A json pointer referring to the form element in the forms json schema
  String scope;

  ///Show field depending on value of other field
  ShowOnProperty? showOn;
  ControlType type;

  Control({this.options, required this.scope, this.showOn, required this.type});

  factory Control.fromJson(Map<String, dynamic> json) => Control(
        options: json["options"] == null ? null : Options.fromJson(json["options"]),
        scope: json["scope"],
        showOn: json["showOn"] == null ? null : ShowOnProperty.fromJson(json["showOn"]),
        type: controlTypeValues.map[json["type"]]!,
      );

  Map<String, dynamic> toJson() => {
        "options": options?.toJson(),
        "scope": scope,
        "showOn": showOn?.toJson(),
        "type": controlTypeValues.reverse[type],
      };
}

class DescendantControlOverrides {
  ///Gives multiple options to configure the element
  Options? options;

  ///Show field depending on value of other field
  ShowOnProperty? showOn;

  DescendantControlOverrides({this.options, this.showOn});

  factory DescendantControlOverrides.fromJson(Map<String, dynamic> json) => DescendantControlOverrides(
        options: json["options"] == null ? null : Options.fromJson(json["options"]),
        showOn: json["showOn"] == null ? null : ShowOnProperty.fromJson(json["showOn"]),
      );

  Map<String, dynamic> toJson() => {
        "options": options?.toJson(),
        "showOn": showOn?.toJson(),
      };
}

///Specifies what should be autocompleted by the browser. Possible values are taken from
///https://developer.mozilla.org/en-US/docs/Web/HTML/Attributes/autocomplete#values
enum Autocomplete {
  ADDITIONAL_NAME,
  ADDRESS_LEVEL1,
  ADDRESS_LEVEL2,
  ADDRESS_LEVEL3,
  ADDRESS_LEVEL4,
  ADDRESS_LINE1,
  ADDRESS_LINE2,
  ADDRESS_LINE3,
  BDAY,
  BDAY_DAY,
  BDAY_MONTH,
  BDAY_YEAR,
  BILLING,
  CC_ADDITIONAL_NAME,
  CC_CSC,
  CC_EXP,
  CC_EXP_MONTH,
  CC_EXP_YEAR,
  CC_FAMILY_NAME,
  CC_GIVEN_NAME,
  CC_NAME,
  CC_NUMBER,
  CC_TYPE,
  COUNTRY,
  COUNTRY_NAME,
  CURRENT_PASSWORD,
  EMAIL,
  FAMILY_NAME,
  GIVEN_NAME,
  HONORIFIC_PREFIX,
  HONORIFIC_SUFFIX,
  IMPP,
  LANGUAGE,
  NAME,
  NEW_PASSWORD,
  NICKNAME,
  OFF,
  ON,
  ONE_TIME_CODE,
  ORGANIZATION,
  ORGANIZATION_TITLE,
  PHOTO,
  POSTAL_CODE,
  SEX,
  SHIPPING,
  STREET_ADDRESS,
  TEL,
  TEL_AREA_CODE,
  TEL_COUNTRY_CODE,
  TEL_EXTENSION,
  TEL_LOCAL,
  TEL_NATIONAL,
  TRANSACTION_AMOUNT,
  TRANSACTION_CURRENCY,
  URL,
  USERNAME,
  WEBAUTHN,
}

final autocompleteValues = EnumValues({
  "additional-name": Autocomplete.ADDITIONAL_NAME,
  "address-level1": Autocomplete.ADDRESS_LEVEL1,
  "address-level2": Autocomplete.ADDRESS_LEVEL2,
  "address-level3": Autocomplete.ADDRESS_LEVEL3,
  "address-level4": Autocomplete.ADDRESS_LEVEL4,
  "address-line1": Autocomplete.ADDRESS_LINE1,
  "address-line2": Autocomplete.ADDRESS_LINE2,
  "address-line3": Autocomplete.ADDRESS_LINE3,
  "bday": Autocomplete.BDAY,
  "bday-day": Autocomplete.BDAY_DAY,
  "bday-month": Autocomplete.BDAY_MONTH,
  "bday-year": Autocomplete.BDAY_YEAR,
  "billing": Autocomplete.BILLING,
  "cc-additional-name": Autocomplete.CC_ADDITIONAL_NAME,
  "cc-csc": Autocomplete.CC_CSC,
  "cc-exp": Autocomplete.CC_EXP,
  "cc-exp-month": Autocomplete.CC_EXP_MONTH,
  "cc-exp-year": Autocomplete.CC_EXP_YEAR,
  "cc-family-name": Autocomplete.CC_FAMILY_NAME,
  "cc-given-name": Autocomplete.CC_GIVEN_NAME,
  "cc-name": Autocomplete.CC_NAME,
  "cc-number": Autocomplete.CC_NUMBER,
  "cc-type": Autocomplete.CC_TYPE,
  "country": Autocomplete.COUNTRY,
  "country-name": Autocomplete.COUNTRY_NAME,
  "current-password": Autocomplete.CURRENT_PASSWORD,
  "email": Autocomplete.EMAIL,
  "family-name": Autocomplete.FAMILY_NAME,
  "given-name": Autocomplete.GIVEN_NAME,
  "honorific-prefix": Autocomplete.HONORIFIC_PREFIX,
  "honorific-suffix": Autocomplete.HONORIFIC_SUFFIX,
  "impp": Autocomplete.IMPP,
  "language": Autocomplete.LANGUAGE,
  "name": Autocomplete.NAME,
  "new-password": Autocomplete.NEW_PASSWORD,
  "nickname": Autocomplete.NICKNAME,
  "off": Autocomplete.OFF,
  "on": Autocomplete.ON,
  "one-time-code": Autocomplete.ONE_TIME_CODE,
  "organization": Autocomplete.ORGANIZATION,
  "organization-title": Autocomplete.ORGANIZATION_TITLE,
  "photo": Autocomplete.PHOTO,
  "postal-code": Autocomplete.POSTAL_CODE,
  "sex": Autocomplete.SEX,
  "shipping": Autocomplete.SHIPPING,
  "street-address": Autocomplete.STREET_ADDRESS,
  "tel": Autocomplete.TEL,
  "tel-area-code": Autocomplete.TEL_AREA_CODE,
  "tel-country-code": Autocomplete.TEL_COUNTRY_CODE,
  "tel-extension": Autocomplete.TEL_EXTENSION,
  "tel-local": Autocomplete.TEL_LOCAL,
  "tel-national": Autocomplete.TEL_NATIONAL,
  "transaction-amount": Autocomplete.TRANSACTION_AMOUNT,
  "transaction-currency": Autocomplete.TRANSACTION_CURRENCY,
  "url": Autocomplete.URL,
  "username": Autocomplete.USERNAME,
  "webauthn": Autocomplete.WEBAUTHN,
});

///Format for string fields
enum Format {
  COLOR,
  DATE,
  DATETIME_LOCAL,
  EMAIL,
  HIDDEN,
  PASSWORD,
  SEARCH,
  TEL,
  TEXT,
  TIME,
  URL,
}

final formatValues = EnumValues({
  "color": Format.COLOR,
  "date": Format.DATE,
  "datetime-local": Format.DATETIME_LOCAL,
  "email": Format.EMAIL,
  "hidden": Format.HIDDEN,
  "password": Format.PASSWORD,
  "search": Format.SEARCH,
  "tel": Format.TEL,
  "text": Format.TEXT,
  "time": Format.TIME,
  "url": Format.URL,
});

///Help text popover
class OptionsHelp {
  String? label;
  String text;
  BaseVariants? variant;

  OptionsHelp({this.label, required this.text, this.variant});

  factory OptionsHelp.fromJson(Map<String, dynamic> json) => OptionsHelp(
        label: json["label"],
        text: json["text"],
        variant: baseVariantsValues.map[json["variant"]]!,
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "text": text,
        "variant": baseVariantsValues.reverse[variant],
      };
}

enum BaseVariants {
  DANGER,
  DARK,
  INFO,
  LIGHT,
  PRIMARY,
  SECONDARY,
  SUCCESS,
  WARNING,
}

final baseVariantsValues = EnumValues({
  "danger": BaseVariants.DANGER,
  "dark": BaseVariants.DARK,
  "info": BaseVariants.INFO,
  "light": BaseVariants.LIGHT,
  "primary": BaseVariants.PRIMARY,
  "secondary": BaseVariants.SECONDARY,
  "success": BaseVariants.SUCCESS,
  "warning": BaseVariants.WARNING,
});

///Will be rendered as tags-Field
class OptionsTags {
  ///Set to true to render the field as tags field
  bool? enabled;
  bool? pills;
  BaseVariants? variant;

  OptionsTags({this.enabled, this.pills, this.variant});

  factory OptionsTags.fromJson(Map<String, dynamic> json) => OptionsTags(
        enabled: json["enabled"],
        pills: json["pills"],
        variant: baseVariantsValues.map[json["variant"]]!,
      );

  Map<String, dynamic> toJson() => {
        "enabled": enabled,
        "pills": pills,
        "variant": baseVariantsValues.reverse[variant],
      };
}

///Set the text-align of input fields
enum TextAlign { CENTER, END, LEFT, RIGHT, START }

final textAlignValues = EnumValues({
  "center": TextAlign.CENTER,
  "end": TextAlign.END,
  "left": TextAlign.LEFT,
  "right": TextAlign.RIGHT,
  "start": TextAlign.START,
});

enum ControlType { CONTROL }

final controlTypeValues = EnumValues({"Control": ControlType.CONTROL});

class ControlFormattingOptions {
  ///Will be appended to field
  String? append;

  ///The Controls CSS classes
  String? cssClass;

  ///Allows to override UI options and ShowOn for all descendant controls of this control. The
  ///key is the scope of the descendant control. Options will be merged.
  Map<String, DescendantControlOverrides>? descendantControlOverrides;

  ///Disables the field
  bool? disabled;

  ///If set to true, the field will be marked as required even if it is not required by the
  ///schema
  bool? forceRequired;

  ///Help text popover
  ControlFormattingOptionsHelp? help;

  ///Sets the visibility of the field to hidden. For example useful in combination with a
  ///DateTime field with default:"$now" to create a hidden timestamp.
  bool? hidden;

  ///Defines whether the fields label is shown
  bool? label;

  ///Will be shown as placeholder in form fields, if supported by field
  String? placeholder;

  ///Will be appended to field
  String? postHtml;

  ///Will be prepended to field (before the label)
  String? preHtml;

  ///Will be prepended to field
  String? prepend;

  ControlFormattingOptions({
    this.append,
    this.cssClass,
    this.descendantControlOverrides,
    this.disabled,
    this.forceRequired,
    this.help,
    this.hidden,
    this.label,
    this.placeholder,
    this.postHtml,
    this.preHtml,
    this.prepend,
  });

  factory ControlFormattingOptions.fromJson(Map<String, dynamic> json) => ControlFormattingOptions(
        append: json["append"],
        cssClass: json["cssClass"],
        descendantControlOverrides: json["descendantControlOverrides"] == null
            ? null
            : Map.from(json["descendantControlOverrides"]!).map(
                (k, v) => MapEntry<String, DescendantControlOverrides>(
                  k,
                  DescendantControlOverrides.fromJson(v),
                ),
              ),
        disabled: json["disabled"],
        forceRequired: json["forceRequired"],
        help: json["help"] == null ? null : ControlFormattingOptionsHelp.fromJson(json["help"]),
        hidden: json["hidden"],
        label: json["label"],
        placeholder: json["placeholder"],
        postHtml: json["postHtml"],
        preHtml: json["preHtml"],
        prepend: json["prepend"],
      );

  Map<String, dynamic> toJson() => {
        "append": append,
        "cssClass": cssClass,
        "descendantControlOverrides": descendantControlOverrides == null
            ? null
            : Map.from(
                descendantControlOverrides!,
              ).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "disabled": disabled,
        "forceRequired": forceRequired,
        "help": help?.toJson(),
        "hidden": hidden,
        "label": label,
        "placeholder": placeholder,
        "postHtml": postHtml,
        "preHtml": preHtml,
        "prepend": prepend,
      };
}

///Help text popover
class ControlFormattingOptionsHelp {
  String? label;
  String text;
  BaseVariants? variant;

  ControlFormattingOptionsHelp({this.label, required this.text, this.variant});

  factory ControlFormattingOptionsHelp.fromJson(Map<String, dynamic> json) => ControlFormattingOptionsHelp(
        label: json["label"],
        text: json["text"],
        variant: baseVariantsValues.map[json["variant"]],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "text": text,
        "variant": baseVariantsValues.reverse[variant],
      };
}

///inserts a simple divider
class Divider implements LayoutElement {
  ///Show field depending on value of other field
  ShowOnProperty? showOn;
  DividerType type;

  Divider({this.showOn, required this.type});

  factory Divider.fromJson(Map<String, dynamic> json) => Divider(
        showOn: json["showOn"] == null ? null : ShowOnProperty.fromJson(json["showOn"]),
        type: dividerTypeValues.map[json["type"]]!,
      );

  Map<String, dynamic> toJson() => {
        "showOn": showOn?.toJson(),
        "type": dividerTypeValues.reverse[type],
      };
}

enum DividerType { DIVIDER }

final dividerTypeValues = EnumValues({"Divider": DividerType.DIVIDER});

class FileUploadOptions {
  ///The accepted File Types
  String? acceptedFileType;

  ///If this is an array of upload fields, display as a single Multi-Upload field instead
  bool? displayAsSingleUploadField;

  ///Maximum file size in bytes per file. If file using a multi file upload, this needs to be
  ///set on the array that is the multi file upload.
  double? maxFileSize;

  FileUploadOptions({
    this.acceptedFileType,
    this.displayAsSingleUploadField,
    this.maxFileSize,
  });

  factory FileUploadOptions.fromJson(Map<String, dynamic> json) => FileUploadOptions(
        acceptedFileType: json["acceptedFileType"],
        displayAsSingleUploadField: json["displayAsSingleUploadField"],
        maxFileSize: json["maxFileSize"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "acceptedFileType": acceptedFileType,
        "displayAsSingleUploadField": displayAsSingleUploadField,
        "maxFileSize": maxFileSize,
      };
}

///Some HTML to be rendered in the form
class HtmlRenderer implements LayoutElement {
  String htmlData;

  ///Show field depending on value of other field
  ShowOnProperty? showOn;
  HtmlRendererType? type;

  HtmlRenderer({required this.htmlData, this.showOn, this.type});

  factory HtmlRenderer.fromJson(Map<String, dynamic> json) => HtmlRenderer(
        htmlData: json["htmlData"],
        showOn: json["showOn"] == null ? null : ShowOnProperty.fromJson(json["showOn"]),
        type: htmlRendererTypeValues.map[json["type"]]!,
      );

  Map<String, dynamic> toJson() => {
        "htmlData": htmlData,
        "showOn": showOn?.toJson(),
        "type": htmlRendererTypeValues.reverse[type],
      };
}

enum HtmlRendererType { HTML }

final htmlRendererTypeValues = EnumValues({"HTML": HtmlRendererType.HTML});

///Options for text fields
class InputOptions {
  ///Specifies what should be autocompleted by the browser. Possible values are taken from
  ///https://developer.mozilla.org/en-US/docs/Web/HTML/Attributes/autocomplete#values
  Autocomplete? autocomplete;

  ///Format for string fields
  Format? format;

  ///If set true, textarea will be shown instead of textfield.
  ///Alternatively can be set to the number of wanted lines
  dynamic multi;

  ///If set true, a range input will be shown instead of a text input
  bool? range;

  ///Set the text-align of input fields
  TextAlign? textAlign;

  InputOptions({
    this.autocomplete,
    this.format,
    this.multi,
    this.range,
    this.textAlign,
  });

  factory InputOptions.fromJson(Map<String, dynamic> json) => InputOptions(
        autocomplete: autocompleteValues.map[json["autocomplete"]],
        format: formatValues.map[json["format"]],
        multi: json["multi"],
        range: json["range"],
        textAlign: textAlignValues.map[json["textAlign"]],
      );

  Map<String, dynamic> toJson() => {
        "autocomplete": autocompleteValues.reverse[autocomplete],
        "format": formatValues.reverse[format],
        "multi": multi,
        "range": range,
        "textAlign": textAlignValues.reverse[textAlign],
      };
}

///Legacy Variant of defining ShowOn property
class LegacyShowOnProperty {
  ///The field this field depends on in object notation
  String path;

  ///The value the field from scope is compared against
  dynamic referenceValue;
  ShowOnFunctionType type;

  LegacyShowOnProperty({
    required this.path,
    required this.referenceValue,
    required this.type,
  });

  factory LegacyShowOnProperty.fromJson(Map<String, dynamic> json) => LegacyShowOnProperty(
        path: json["path"],
        referenceValue: json["referenceValue"],
        type: showOnFunctionTypeValues.map[json["type"]]!,
      );

  Map<String, dynamic> toJson() => {
        "path": path,
        "referenceValue": referenceValue,
        "type": showOnFunctionTypeValues.reverse[type],
      };
}

///Returns the current time
class Now {
  NowType? type;

  Now({this.type});

  factory Now.fromJson(Map<String, dynamic> json) => Now(type: nowTypeValues.map[json["type"]]);

  Map<String, dynamic> toJson() => {"type": nowTypeValues.reverse[type]};
}

enum NowType { NOW }

final nowTypeValues = EnumValues({"now": NowType.NOW});

enum OutlineVariants {
  OUTLINE_DANGER,
  OUTLINE_DARK,
  OUTLINE_INFO,
  OUTLINE_LIGHT,
  OUTLINE_PRIMARY,
  OUTLINE_SECONDARY,
  OUTLINE_SUCCESS,
  OUTLINE_WARNING,
}

final outlineVariantsValues = EnumValues({
  "outline-danger": OutlineVariants.OUTLINE_DANGER,
  "outline-dark": OutlineVariants.OUTLINE_DARK,
  "outline-info": OutlineVariants.OUTLINE_INFO,
  "outline-light": OutlineVariants.OUTLINE_LIGHT,
  "outline-primary": OutlineVariants.OUTLINE_PRIMARY,
  "outline-secondary": OutlineVariants.OUTLINE_SECONDARY,
  "outline-success": OutlineVariants.OUTLINE_SUCCESS,
  "outline-warning": OutlineVariants.OUTLINE_WARNING,
});

class TagOptions {
  ///Will be rendered as tags-Field
  TagOptionsTags? tags;

  TagOptions({this.tags});

  factory TagOptions.fromJson(Map<String, dynamic> json) => TagOptions(
        tags: json["tags"] == null ? null : TagOptionsTags.fromJson(json["tags"]),
      );

  Map<String, dynamic> toJson() => {"tags": tags?.toJson()};
}

///Will be rendered as tags-Field
class TagOptionsTags {
  ///Set to true to render the field as tags field
  bool? enabled;
  bool? pills;
  BaseVariants? variant;

  TagOptionsTags({this.enabled, this.pills, this.variant});

  factory TagOptionsTags.fromJson(Map<String, dynamic> json) => TagOptionsTags(
        enabled: json["enabled"],
        pills: json["pills"],
        variant: baseVariantsValues.map[json["variant"]]!,
      );

  Map<String, dynamic> toJson() => {
        "enabled": enabled,
        "pills": pills,
        "variant": baseVariantsValues.reverse[variant],
      };
}

/// Manually crated because dart doesn't support union types
/// Discriminator: Type
/// Union classes: [Wizard], [Layout]
sealed class RootLayout {
  Map<String, dynamic> toJson();

  factory RootLayout.fromJson(Map<String, dynamic> json) {
    final type = layoutTypeEnumValues.map[json["type"]];
    switch (type) {
      case LayoutTypeEnum.WIZARD:
        return Wizard.fromJson(json);
      case LayoutTypeEnum.HORIZONTAL_LAYOUT:
      case LayoutTypeEnum.VERTICAL_LAYOUT:
      case LayoutTypeEnum.GROUP:
        return Layout.fromJson(json);
      default:
        throw Exception("Unknown RootLayout type: $type");
    }
  }
}

///Schema for the UI Schema
class UiSchema {
  RootLayout layout;

  ///Version of the UI Schema. Changes in a major version are backwards compatible. So a
  ///parser for version z.x must be compatible with all versions z.y where y is <=x.
  String version;

  UiSchema({required this.layout, required this.version});

  factory UiSchema.fromJson(Map<String, dynamic> json) => UiSchema(
        layout: RootLayout.fromJson(json["layout"]),
        version: json["version"],
      );

  Map<String, dynamic> toJson() => {
        "layout": layout.toJson(),
        "version": version,
      };
}

/// Manually crated because dart doesn't support union types
/// Discriminator: Type
/// Union classes: [Control], [Layout], [HtmlRenderer], [Divider], [Button], [Buttongroup]
sealed class LayoutElement {
  Map<String, dynamic> toJson();

  ShowOnProperty? get showOn;

  factory LayoutElement.fromJson(Map<String, dynamic> json) {
    final type = layoutElementTypeValues.map[json["type"]];
    switch (type) {
      case LayoutElementType.CONTROL:
        return Control.fromJson(json);
      case LayoutElementType.VERTICAL_LAYOUT:
      case LayoutElementType.HORIZONTAL_LAYOUT:
      case LayoutElementType.GROUP:
        return Layout.fromJson(json);
      case LayoutElementType.HTML:
        return HtmlRenderer.fromJson(json);
      case LayoutElementType.DIVIDER:
        return Divider.fromJson(json);
      case LayoutElementType.BUTTON:
        return Button.fromJson(json);
      case LayoutElementType.BUTTONGROUP:
        return Buttongroup.fromJson(json);
      case null:
        throw Exception("Unknown LayoutElement type: null");
    }
  }
}

enum LayoutElementType {
  BUTTON,
  BUTTONGROUP,
  CONTROL,
  DIVIDER,
  GROUP,
  HORIZONTAL_LAYOUT,
  HTML,
  VERTICAL_LAYOUT,
}

final layoutElementTypeValues = EnumValues({
  "Button": LayoutElementType.BUTTON,
  "Buttongroup": LayoutElementType.BUTTONGROUP,
  "Control": LayoutElementType.CONTROL,
  "Divider": LayoutElementType.DIVIDER,
  "Group": LayoutElementType.GROUP,
  "HorizontalLayout": LayoutElementType.HORIZONTAL_LAYOUT,
  "HTML": LayoutElementType.HTML,
  "VerticalLayout": LayoutElementType.VERTICAL_LAYOUT,
});

///The different layouts
class Layout implements LayoutElement, RootLayout {
  List<LayoutElement> elements;

  ///Additional options
  LayoutOptions? options;

  ///Show field depending on value of other field
  ShowOnProperty? showOn;
  LayoutType type;

  Layout({
    required this.elements,
    this.options,
    this.showOn,
    required this.type,
  });

  factory Layout.fromJson(Map<String, dynamic> json) => Layout(
        elements: List<LayoutElement>.from(
          json["elements"].map((x) => LayoutElement.fromJson(x)),
        ),
        options: json["options"] == null ? null : LayoutOptions.fromJson(json["options"]),
        showOn: json["showOn"] == null ? null : ShowOnProperty.fromJson(json["showOn"]),
        type: layoutTypeValues.map[json["type"]]!,
      );

  Map<String, dynamic> toJson() => {
        "elements": List<dynamic>.from(elements.map((x) => x.toJson())),
        "options": options?.toJson(),
        "showOn": showOn?.toJson(),
        "type": layoutTypeValues.reverse[type],
      };
}

///Additional options
class LayoutOptions {
  ///The layout's CSS classes
  String? cssClass;

  ///Adds a description for a group (only for type=Group)
  String? description;

  ///Adds a label for groups (only for type=Group)
  String? label;

  LayoutOptions({this.cssClass, this.description, this.label});

  factory LayoutOptions.fromJson(Map<String, dynamic> json) => LayoutOptions(
        cssClass: json["cssClass"],
        description: json["description"],
        label: json["label"],
      );

  Map<String, dynamic> toJson() => {
        "cssClass": cssClass,
        "description": description,
        "label": label,
      };
}

enum LayoutType { GROUP, HORIZONTAL_LAYOUT, VERTICAL_LAYOUT }

final layoutTypeValues = EnumValues({
  "Group": LayoutType.GROUP,
  "HorizontalLayout": LayoutType.HORIZONTAL_LAYOUT,
  "VerticalLayout": LayoutType.VERTICAL_LAYOUT,
});

enum LayoutTypeEnum { GROUP, HORIZONTAL_LAYOUT, VERTICAL_LAYOUT, WIZARD }

final layoutTypeEnumValues = EnumValues({
  "Group": LayoutTypeEnum.GROUP,
  "HorizontalLayout": LayoutTypeEnum.HORIZONTAL_LAYOUT,
  "VerticalLayout": LayoutTypeEnum.VERTICAL_LAYOUT,
  "Wizard": LayoutTypeEnum.WIZARD,
});

///A wizard
class Wizard implements RootLayout {
  ///Additional options
  WizardOptions? options;
  List<Layout> pages;
  WizardType type;

  Wizard({this.options, required this.pages, required this.type});

  factory Wizard.fromJson(Map<String, dynamic> json) => Wizard(
        options: json["options"] == null ? null : WizardOptions.fromJson(json["options"]),
        pages: List<Layout>.from(json["pages"].map((x) => Layout.fromJson(x))),
        type: wizardTypeValues.map[json["type"]]!,
      );

  Map<String, dynamic> toJson() => {
        "options": options?.toJson(),
        "pages": List<dynamic>.from(pages.map((x) => x.toJson())),
        "type": wizardTypeValues.reverse[type],
      };
}

///Additional options
class WizardOptions {
  List<String>? pageTitles;

  WizardOptions({this.pageTitles});

  factory WizardOptions.fromJson(Map<String, dynamic> json) => WizardOptions(
        pageTitles: json["pageTitles"] == null ? [] : List<String>.from(json["pageTitles"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "pageTitles": pageTitles == null ? [] : List<dynamic>.from(pageTitles!.map((x) => x)),
      };
}

enum WizardType { WIZARD }

final wizardTypeValues = EnumValues({"Wizard": WizardType.WIZARD});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
