// To parse this JSON data, do
//
//     final button = buttonFromJson(jsonString);
//     final buttongroup = buttongroupFromJson(jsonString);
//     final buttonOptions = buttonOptionsFromJson(jsonString);
//     final colorVariant = colorVariantFromJson(jsonString);
//     final colorVariant1 = colorVariant1FromJson(jsonString);
//     final commonEnumOptions = commonEnumOptionsFromJson(jsonString);
//     final control = controlFromJson(jsonString);
//     final controlFormattingOptions = controlFormattingOptionsFromJson(jsonString);
//     final coreSchemaMetaSchema = coreSchemaMetaSchemaFromJson(jsonString);
//     final descendantControlOverride = descendantControlOverrideFromJson(jsonString);
//     final descendantControlOverrides = descendantControlOverridesFromJson(jsonString);
//     final displayAs = displayAsFromJson(jsonString);
//     final divider = dividerFromJson(jsonString);
//     final elements = elementsFromJson(jsonString);
//     final enumOptions = enumOptionsFromJson(jsonString);
//     final fieldSpecificOptions = fieldSpecificOptionsFromJson(jsonString);
//     final fileUploadOptions = fileUploadOptionsFromJson(jsonString);
//     final htmlRenderer = htmlRendererFromJson(jsonString);
//     final inputOptions = inputOptionsFromJson(jsonString);
//     final layout = layoutFromJson(jsonString);
//     final layoutElement = layoutElementFromJson(jsonString);
//     final legacyShowOnProperty = legacyShowOnPropertyFromJson(jsonString);
//     final nonNegativeInteger = nonNegativeIntegerFromJson(jsonString);
//     final nonNegativeIntegerDefault0 = nonNegativeIntegerDefault0FromJson(jsonString);
//     final now = nowFromJson(jsonString);
//     final options = optionsFromJson(jsonString);
//     final rule = ruleFromJson(jsonString);
//     final schemaArray = schemaArrayFromJson(jsonString);
//     final showOnFunctionType = showOnFunctionTypeFromJson(jsonString);
//     final showOnProperty = showOnPropertyFromJson(jsonString);
//     final simpleTypes = simpleTypesFromJson(jsonString);
//     final stringArray = stringArrayFromJson(jsonString);
//     final submitOptions = submitOptionsFromJson(jsonString);
//     final tagOptions = tagOptionsFromJson(jsonString);
//     final text2 = text2FromJson(jsonString);
//     final theButtonsType = theButtonsTypeFromJson(jsonString);
//     final titlesForEnum = titlesForEnumFromJson(jsonString);
//     final uiSchema = uiSchemaFromJson(jsonString);

import 'dart:convert';

Button buttonFromJson(String str) => Button.fromJson(json.decode(str));

String buttonToJson(Button data) => json.encode(data.toJson());

Buttongroup buttongroupFromJson(String str) => Buttongroup.fromJson(json.decode(str));

String buttongroupToJson(Buttongroup data) => json.encode(data.toJson());

ButtonOptions buttonOptionsFromJson(String str) => ButtonOptions.fromJson(json.decode(str));

String buttonOptionsToJson(ButtonOptions data) => json.encode(data.toJson());

ColorVariant1 colorVariantFromJson(String str) => colorVariant1Values.map[json.decode(str)]!;

String colorVariantToJson(ColorVariant1 data) => json.encode(colorVariant1Values.reverse[data]);

ColorVariant1 colorVariant1FromJson(String str) => colorVariant1Values.map[json.decode(str)]!;

String colorVariant1ToJson(ColorVariant1 data) => json.encode(colorVariant1Values.reverse[data]);

EnumOptions commonEnumOptionsFromJson(String str) => EnumOptions.fromJson(json.decode(str));

String commonEnumOptionsToJson(EnumOptions data) => json.encode(data.toJson());

Control controlFromJson(String str) => Control.fromJson(json.decode(str));

String controlToJson(Control data) => json.encode(data.toJson());

ControlFormattingOptions controlFormattingOptionsFromJson(String str) => ControlFormattingOptions.fromJson(json.decode(str));

String controlFormattingOptionsToJson(ControlFormattingOptions data) => json.encode(data.toJson());

CoreSchemaMetaSchema coreSchemaMetaSchemaFromJson(String str) => CoreSchemaMetaSchema.fromJson(json.decode(str));

String coreSchemaMetaSchemaToJson(CoreSchemaMetaSchema data) => json.encode(data.toJson());

DescendantControlOverrides descendantControlOverrideFromJson(String str) => DescendantControlOverrides.fromJson(json.decode(str));

String descendantControlOverrideToJson(DescendantControlOverrides data) => json.encode(data.toJson());

Map<String, DescendantControlOverrides> descendantControlOverridesFromJson(String str) => Map.from(json.decode(str)).map((k, v) => MapEntry<String, DescendantControlOverrides>(k, DescendantControlOverrides.fromJson(v)));

String descendantControlOverridesToJson(Map<String, DescendantControlOverrides> data) => json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

DisplayAs displayAsFromJson(String str) => displayAsValues.map[json.decode(str)]!;

String displayAsToJson(DisplayAs data) => json.encode(displayAsValues.reverse[data]);

Divider dividerFromJson(String str) => Divider.fromJson(json.decode(str));

String dividerToJson(Divider data) => json.encode(data.toJson());

List<LayoutElement> elementsFromJson(String str) => List<LayoutElement>.from(json.decode(str).map((x) => LayoutElement.fromJson(x)));

String elementsToJson(List<LayoutElement> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

EnumOptions enumOptionsFromJson(String str) => EnumOptions.fromJson(json.decode(str));

String enumOptionsToJson(EnumOptions data) => json.encode(data.toJson());

FieldSpecificOptions fieldSpecificOptionsFromJson(String str) => FieldSpecificOptions.fromJson(json.decode(str));

String fieldSpecificOptionsToJson(FieldSpecificOptions data) => json.encode(data.toJson());

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

double nonNegativeIntegerFromJson(String str) => json.decode(str)?.toDouble();

String nonNegativeIntegerToJson(double data) => json.encode(data);

double nonNegativeIntegerDefault0FromJson(String str) => json.decode(str)?.toDouble();

String nonNegativeIntegerDefault0ToJson(double data) => json.encode(data);

Now nowFromJson(String str) => Now.fromJson(json.decode(str));

String nowToJson(Now data) => json.encode(data.toJson());

dynamic optionsFromJson(String str) => json.decode(str);

String optionsToJson(dynamic data) => json.encode(data);

Rule ruleFromJson(String str) => Rule.fromJson(json.decode(str));

String ruleToJson(Rule data) => json.encode(data.toJson());

List<dynamic> schemaArrayFromJson(String str) => List<dynamic>.from(json.decode(str).map((x) => x));

String schemaArrayToJson(List<dynamic> data) => json.encode(List<dynamic>.from(data.map((x) => x)));

ShowOnFunctionType showOnFunctionTypeFromJson(String str) => showOnFunctionTypeValues.map[json.decode(str)]!;

String showOnFunctionTypeToJson(ShowOnFunctionType data) => json.encode(showOnFunctionTypeValues.reverse[data]);

ShowOnProperty showOnPropertyFromJson(String str) => ShowOnProperty.fromJson(json.decode(str));

String showOnPropertyToJson(ShowOnProperty data) => json.encode(data.toJson());

SimpleTypes simpleTypesFromJson(String str) => simpleTypesValues.map[json.decode(str)]!;

String simpleTypesToJson(SimpleTypes data) => json.encode(simpleTypesValues.reverse[data]);

List<String> stringArrayFromJson(String str) => List<String>.from(json.decode(str).map((x) => x));

String stringArrayToJson(List<String> data) => json.encode(List<dynamic>.from(data.map((x) => x)));

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


///Used to group buttons
class Buttongroup {
    
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
class Button {
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
enum TheButtonsType {
    RESET,
    SUBMIT
}

final theButtonsTypeValues = EnumValues({
    "reset": TheButtonsType.RESET,
    "submit": TheButtonsType.SUBMIT
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
    ColorVariant1? variant;

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
        variant: colorVariant1Values.map[json["variant"]]!,
    );

    Map<String, dynamic> toJson() => {
        "cssClass": cssClass,
        "formnovalidate": formnovalidate,
        "submitOptions": submitOptions?.toJson(),
        "variant": colorVariant1Values.reverse[variant],
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

    SubmitOptions({
        this.action,
        this.request,
    });

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
    
    ///The URL to send the request to
    String url;

    Request({
        this.headers,
        this.method,
        required this.url,
    });

    factory Request.fromJson(Map<String, dynamic> json) => Request(
        headers: Map.from(json["headers"]!).map((k, v) => MapEntry<String, String>(k, v)),
        method: methodValues.map[json["method"]]!,
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "headers": Map.from(headers!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "method": methodValues.reverse[method],
        "url": url,
    };
}


///The HTTP method to use for the request
enum Method {
    DELETE,
    GET,
    POST,
    PUT
}

final methodValues = EnumValues({
    "DELETE": Method.DELETE,
    "GET": Method.GET,
    "POST": Method.POST,
    "PUT": Method.PUT
});


///Different color variants
///
///The color of the help text popover
enum ColorVariant1 {
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
    WARNING
}

final colorVariant1Values = EnumValues({
    "danger": ColorVariant1.DANGER,
    "dark": ColorVariant1.DARK,
    "info": ColorVariant1.INFO,
    "light": ColorVariant1.LIGHT,
    "outline-danger": ColorVariant1.OUTLINE_DANGER,
    "outline-dark": ColorVariant1.OUTLINE_DARK,
    "outline-info": ColorVariant1.OUTLINE_INFO,
    "outline-light": ColorVariant1.OUTLINE_LIGHT,
    "outline-primary": ColorVariant1.OUTLINE_PRIMARY,
    "outline-secondary": ColorVariant1.OUTLINE_SECONDARY,
    "outline-success": ColorVariant1.OUTLINE_SUCCESS,
    "outline-warning": ColorVariant1.OUTLINE_WARNING,
    "primary": ColorVariant1.PRIMARY,
    "secondary": ColorVariant1.SECONDARY,
    "success": ColorVariant1.SUCCESS,
    "warning": ColorVariant1.WARNING
});


///Show field depending on value of other field
///
///Legacy Variant of defining ShowOn property
///
///Rita Rule
///See https://educorvi.github.io/rita/rita-core/docs/schema/#/rule
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
        type: showOnFunctionTypeValues.map[json["type"]]!,
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
    SMALLER_OR_EQUAL
}

final showOnFunctionTypeValues = EnumValues({
    "EQUALS": ShowOnFunctionType.EQUALS,
    "GREATER": ShowOnFunctionType.GREATER,
    "GREATER_OR_EQUAL": ShowOnFunctionType.GREATER_OR_EQUAL,
    "NOT_EQUALS": ShowOnFunctionType.NOT_EQUALS,
    "SMALLER": ShowOnFunctionType.SMALLER,
    "SMALLER_OR_EQUAL": ShowOnFunctionType.SMALLER_OR_EQUAL
});

enum ButtonType {
    BUTTON
}

final buttonTypeValues = EnumValues({
    "Button": ButtonType.BUTTON
});

class ButtongroupOptions {
    
    ///Display the buttons vertical
    bool? vertical;

    ButtongroupOptions({
        this.vertical,
    });

    factory ButtongroupOptions.fromJson(Map<String, dynamic> json) => ButtongroupOptions(
        vertical: json["vertical"],
    );

    Map<String, dynamic> toJson() => {
        "vertical": vertical,
    };
}

enum ButtongroupType {
    BUTTONGROUP
}

final buttongroupTypeValues = EnumValues({
    "Buttongroup": ButtongroupType.BUTTONGROUP
});

class EnumOptions {
    
    ///Different color variants
    ColorVariant1? buttonVariant;
    
    ///Choose how an enum should be displayed
    DisplayAs? displayAs;
    
    ///If the text in a enums select field is supposed to differ from the keys, they can be
    ///specified as properties of this object. The value in the enum must be used as property
    ///name
    Map<String, String>? enumTitles;
    
    ///Radiobutton-/Checkbox group will be stacked if set to true
    bool? stacked;

    EnumOptions({
        this.buttonVariant,
        this.displayAs,
        this.enumTitles,
        this.stacked,
    });

    factory EnumOptions.fromJson(Map<String, dynamic> json) => EnumOptions(
        buttonVariant: colorVariant1Values.map[json["buttonVariant"]]!,
        displayAs: displayAsValues.map[json["displayAs"]]!,
        enumTitles: Map.from(json["enumTitles"]!).map((k, v) => MapEntry<String, String>(k, v)),
        stacked: json["stacked"],
    );

    Map<String, dynamic> toJson() => {
        "buttonVariant": colorVariant1Values.reverse[buttonVariant],
        "displayAs": displayAsValues.reverse[displayAs],
        "enumTitles": Map.from(enumTitles!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "stacked": stacked,
    };
}


///Choose how an enum should be displayed
enum DisplayAs {
    BUTTONS,
    RADIOBUTTONS,
    SELECT,
    SWITCHES
}

final displayAsValues = EnumValues({
    "buttons": DisplayAs.BUTTONS,
    "radiobuttons": DisplayAs.RADIOBUTTONS,
    "select": DisplayAs.SELECT,
    "switches": DisplayAs.SWITCHES
});


///Contains a form element, e. g. a text input
class Control {
    
    ///Gives multiple options to configure the element
    dynamic options;
    
    ///A json pointer referring to the form element in the forms json schema
    String scope;
    
    ///Show field depending on value of other field
    ShowOnProperty? showOn;
    ControlType type;

    Control({
        this.options,
        required this.scope,
        this.showOn,
        required this.type,
    });

    factory Control.fromJson(Map<String, dynamic> json) => Control(
        options: json["options"],
        scope: json["scope"],
        showOn: json["showOn"] == null ? null : ShowOnProperty.fromJson(json["showOn"]),
        type: controlTypeValues.map[json["type"]]!,
    );

    Map<String, dynamic> toJson() => {
        "options": options,
        "scope": scope,
        "showOn": showOn?.toJson(),
        "type": controlTypeValues.reverse[type],
    };
}

class PurpleOptions {
    
    ///Will be rendered as tags-Field
    PurpleTags? tags;
    
    ///The accepted File Types
    String? acceptedFileType;
    
    ///Allows the upload of multiple files with fileupload
    bool? allowMultipleFiles;
    
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

    PurpleOptions({
        this.tags,
        this.acceptedFileType,
        this.allowMultipleFiles,
        this.autocomplete,
        this.format,
        this.multi,
        this.range,
        this.textAlign,
    });

    factory PurpleOptions.fromJson(Map<String, dynamic> json) => PurpleOptions(
        tags: json["tags"] == null ? null : PurpleTags.fromJson(json["tags"]),
        acceptedFileType: json["acceptedFileType"],
        allowMultipleFiles: json["allowMultipleFiles"],
        autocomplete: autocompleteValues.map[json["autocomplete"]]!,
        format: formatValues.map[json["format"]]!,
        multi: json["multi"],
        range: json["range"],
        textAlign: textAlignValues.map[json["textAlign"]]!,
    );

    Map<String, dynamic> toJson() => {
        "tags": tags?.toJson(),
        "acceptedFileType": acceptedFileType,
        "allowMultipleFiles": allowMultipleFiles,
        "autocomplete": autocompleteValues.reverse[autocomplete],
        "format": formatValues.reverse[format],
        "multi": multi,
        "range": range,
        "textAlign": textAlignValues.reverse[textAlign],
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
    WEBAUTHN
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
    "webauthn": Autocomplete.WEBAUTHN
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
    URL
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
    "url": Format.URL
});


///Will be rendered as tags-Field
class PurpleTags {
    
    ///Set to true to render the field as tags field
    bool? enabled;
    bool? pills;
    
    ///Different color variants
    ColorVariant1? variant;

    PurpleTags({
        this.enabled,
        this.pills,
        this.variant,
    });

    factory PurpleTags.fromJson(Map<String, dynamic> json) => PurpleTags(
        enabled: json["enabled"],
        pills: json["pills"],
        variant: colorVariant1Values.map[json["variant"]]!,
    );

    Map<String, dynamic> toJson() => {
        "enabled": enabled,
        "pills": pills,
        "variant": colorVariant1Values.reverse[variant],
    };
}


///Set the text-align of input fields
enum TextAlign {
    CENTER,
    END,
    LEFT,
    RIGHT,
    START
}

final textAlignValues = EnumValues({
    "center": TextAlign.CENTER,
    "end": TextAlign.END,
    "left": TextAlign.LEFT,
    "right": TextAlign.RIGHT,
    "start": TextAlign.START
});

enum ControlType {
    CONTROL
}

final controlTypeValues = EnumValues({
    "Control": ControlType.CONTROL
});

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
    
    ///Help text popover
    Help? help;
    
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
        descendantControlOverrides: Map.from(json["descendantControlOverrides"]!).map((k, v) => MapEntry<String, DescendantControlOverrides>(k, DescendantControlOverrides.fromJson(v))),
        disabled: json["disabled"],
        help: json["help"] == null ? null : Help.fromJson(json["help"]),
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
        "descendantControlOverrides": Map.from(descendantControlOverrides!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "disabled": disabled,
        "help": help?.toJson(),
        "hidden": hidden,
        "label": label,
        "placeholder": placeholder,
        "postHtml": postHtml,
        "preHtml": preHtml,
        "prepend": prepend,
    };
}

class DescendantControlOverrides {
    
    ///Gives multiple options to configure the element
    dynamic options;
    
    ///Show field depending on value of other field
    ShowOnProperty? showOn;

    DescendantControlOverrides({
        this.options,
        this.showOn,
    });

    factory DescendantControlOverrides.fromJson(Map<String, dynamic> json) => DescendantControlOverrides(
        options: json["options"],
        showOn: json["showOn"] == null ? null : ShowOnProperty.fromJson(json["showOn"]),
    );

    Map<String, dynamic> toJson() => {
        "options": options,
        "showOn": showOn?.toJson(),
    };
}

class FluffyOptions {
    
    ///Will be rendered as tags-Field
    FluffyTags? tags;
    
    ///The accepted File Types
    String? acceptedFileType;
    
    ///Allows the upload of multiple files with fileupload
    bool? allowMultipleFiles;
    
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

    FluffyOptions({
        this.tags,
        this.acceptedFileType,
        this.allowMultipleFiles,
        this.autocomplete,
        this.format,
        this.multi,
        this.range,
        this.textAlign,
    });

    factory FluffyOptions.fromJson(Map<String, dynamic> json) => FluffyOptions(
        tags: json["tags"] == null ? null : FluffyTags.fromJson(json["tags"]),
        acceptedFileType: json["acceptedFileType"],
        allowMultipleFiles: json["allowMultipleFiles"],
        autocomplete: autocompleteValues.map[json["autocomplete"]]!,
        format: formatValues.map[json["format"]]!,
        multi: json["multi"],
        range: json["range"],
        textAlign: textAlignValues.map[json["textAlign"]]!,
    );

    Map<String, dynamic> toJson() => {
        "tags": tags?.toJson(),
        "acceptedFileType": acceptedFileType,
        "allowMultipleFiles": allowMultipleFiles,
        "autocomplete": autocompleteValues.reverse[autocomplete],
        "format": formatValues.reverse[format],
        "multi": multi,
        "range": range,
        "textAlign": textAlignValues.reverse[textAlign],
    };
}


///Will be rendered as tags-Field
class FluffyTags {
    
    ///Set to true to render the field as tags field
    bool? enabled;
    bool? pills;
    
    ///Different color variants
    ColorVariant1? variant;

    FluffyTags({
        this.enabled,
        this.pills,
        this.variant,
    });

    factory FluffyTags.fromJson(Map<String, dynamic> json) => FluffyTags(
        enabled: json["enabled"],
        pills: json["pills"],
        variant: colorVariant1Values.map[json["variant"]]!,
    );

    Map<String, dynamic> toJson() => {
        "enabled": enabled,
        "pills": pills,
        "variant": colorVariant1Values.reverse[variant],
    };
}


///Help text popover
class Help {
    String? label;
    String text;
    
    ///The color of the help text popover
    ColorVariant1? variant;

    Help({
        this.label,
        required this.text,
        this.variant,
    });

    factory Help.fromJson(Map<String, dynamic> json) => Help(
        label: json["label"],
        text: json["text"],
        variant: colorVariant1Values.map[json["variant"]]!,
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "text": text,
        "variant": colorVariant1Values.reverse[variant],
    };
}


///This file was automatically generated by json-schema-to-typescript.
///DO NOT MODIFY IT BY HAND. Instead, modify the source JSONSchema file,
///and run json-schema-to-typescript to regenerate this file.
class CoreSchemaMetaSchema {
    String? comment;
    String? id;
    String? ref;
    String? schema;
    dynamic additionalItems;
    dynamic additionalProperties;
    List<dynamic>? allOf;
    List<dynamic>? anyOf;
    dynamic coreSchemaMetaSchemaConst;
    dynamic contains;
    String? contentEncoding;
    String? contentMediaType;
    dynamic coreSchemaMetaSchemaDefault;
    Map<String, dynamic>? definitions;
    Map<String, dynamic>? dependencies;
    String? description;
    dynamic coreSchemaMetaSchemaElse;
    List<dynamic>? coreSchemaMetaSchemaEnum;
    List<dynamic>? examples;
    double? exclusiveMaximum;
    double? exclusiveMinimum;
    String? format;
    dynamic coreSchemaMetaSchemaIf;
    dynamic items;
    double? maximum;
    double? maxItems;
    double? maxLength;
    double? maxProperties;
    double? minimum;
    double? minItems;
    double? minLength;
    double? minProperties;
    double? multipleOf;
    dynamic not;
    List<dynamic>? oneOf;
    String? pattern;
    Map<String, dynamic>? patternProperties;
    Map<String, dynamic>? properties;
    dynamic propertyNames;
    bool? readOnly;
    List<String>? required;
    dynamic then;
    String? title;
    dynamic type;
    bool? uniqueItems;
    bool? writeOnly;

    CoreSchemaMetaSchema({
        this.comment,
        this.id,
        this.ref,
        this.schema,
        this.additionalItems,
        this.additionalProperties,
        this.allOf,
        this.anyOf,
        this.coreSchemaMetaSchemaConst,
        this.contains,
        this.contentEncoding,
        this.contentMediaType,
        this.coreSchemaMetaSchemaDefault,
        this.definitions,
        this.dependencies,
        this.description,
        this.coreSchemaMetaSchemaElse,
        this.coreSchemaMetaSchemaEnum,
        this.examples,
        this.exclusiveMaximum,
        this.exclusiveMinimum,
        this.format,
        this.coreSchemaMetaSchemaIf,
        this.items,
        this.maximum,
        this.maxItems,
        this.maxLength,
        this.maxProperties,
        this.minimum,
        this.minItems,
        this.minLength,
        this.minProperties,
        this.multipleOf,
        this.not,
        this.oneOf,
        this.pattern,
        this.patternProperties,
        this.properties,
        this.propertyNames,
        this.readOnly,
        this.required,
        this.then,
        this.title,
        this.type,
        this.uniqueItems,
        this.writeOnly,
    });

    factory CoreSchemaMetaSchema.fromJson(Map<String, dynamic> json) => CoreSchemaMetaSchema(
        comment: json["\u0024comment"],
        id: json["\u0024id"],
        ref: json["\u0024ref"],
        schema: json["\u0024schema"],
        additionalItems: json["additionalItems"],
        additionalProperties: json["additionalProperties"],
        allOf: json["allOf"] == null ? [] : List<dynamic>.from(json["allOf"]!.map((x) => x)),
        anyOf: json["anyOf"] == null ? [] : List<dynamic>.from(json["anyOf"]!.map((x) => x)),
        coreSchemaMetaSchemaConst: json["const"],
        contains: json["contains"],
        contentEncoding: json["contentEncoding"],
        contentMediaType: json["contentMediaType"],
        coreSchemaMetaSchemaDefault: json["default"],
        definitions: Map.from(json["definitions"]!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        dependencies: Map.from(json["dependencies"]!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        description: json["description"],
        coreSchemaMetaSchemaElse: json["else"],
        coreSchemaMetaSchemaEnum: json["enum"] == null ? [] : List<dynamic>.from(json["enum"]!.map((x) => x)),
        examples: json["examples"] == null ? [] : List<dynamic>.from(json["examples"]!.map((x) => x)),
        exclusiveMaximum: json["exclusiveMaximum"]?.toDouble(),
        exclusiveMinimum: json["exclusiveMinimum"]?.toDouble(),
        format: json["format"],
        coreSchemaMetaSchemaIf: json["if"],
        items: json["items"],
        maximum: json["maximum"]?.toDouble(),
        maxItems: json["maxItems"]?.toDouble(),
        maxLength: json["maxLength"]?.toDouble(),
        maxProperties: json["maxProperties"]?.toDouble(),
        minimum: json["minimum"]?.toDouble(),
        minItems: json["minItems"]?.toDouble(),
        minLength: json["minLength"]?.toDouble(),
        minProperties: json["minProperties"]?.toDouble(),
        multipleOf: json["multipleOf"]?.toDouble(),
        not: json["not"],
        oneOf: json["oneOf"] == null ? [] : List<dynamic>.from(json["oneOf"]!.map((x) => x)),
        pattern: json["pattern"],
        patternProperties: Map.from(json["patternProperties"]!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        properties: Map.from(json["properties"]!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        propertyNames: json["propertyNames"],
        readOnly: json["readOnly"],
        required: json["required"] == null ? [] : List<String>.from(json["required"]!.map((x) => x)),
        then: json["then"],
        title: json["title"],
        type: json["type"],
        uniqueItems: json["uniqueItems"],
        writeOnly: json["writeOnly"],
    );

    Map<String, dynamic> toJson() => {
        "\u0024comment": comment,
        "\u0024id": id,
        "\u0024ref": ref,
        "\u0024schema": schema,
        "additionalItems": additionalItems,
        "additionalProperties": additionalProperties,
        "allOf": allOf == null ? [] : List<dynamic>.from(allOf!.map((x) => x)),
        "anyOf": anyOf == null ? [] : List<dynamic>.from(anyOf!.map((x) => x)),
        "const": coreSchemaMetaSchemaConst,
        "contains": contains,
        "contentEncoding": contentEncoding,
        "contentMediaType": contentMediaType,
        "default": coreSchemaMetaSchemaDefault,
        "definitions": Map.from(definitions!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "dependencies": Map.from(dependencies!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "description": description,
        "else": coreSchemaMetaSchemaElse,
        "enum": coreSchemaMetaSchemaEnum == null ? [] : List<dynamic>.from(coreSchemaMetaSchemaEnum!.map((x) => x)),
        "examples": examples == null ? [] : List<dynamic>.from(examples!.map((x) => x)),
        "exclusiveMaximum": exclusiveMaximum,
        "exclusiveMinimum": exclusiveMinimum,
        "format": format,
        "if": coreSchemaMetaSchemaIf,
        "items": items,
        "maximum": maximum,
        "maxItems": maxItems,
        "maxLength": maxLength,
        "maxProperties": maxProperties,
        "minimum": minimum,
        "minItems": minItems,
        "minLength": minLength,
        "minProperties": minProperties,
        "multipleOf": multipleOf,
        "not": not,
        "oneOf": oneOf == null ? [] : List<dynamic>.from(oneOf!.map((x) => x)),
        "pattern": pattern,
        "patternProperties": Map.from(patternProperties!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "properties": Map.from(properties!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "propertyNames": propertyNames,
        "readOnly": readOnly,
        "required": required == null ? [] : List<dynamic>.from(required!.map((x) => x)),
        "then": then,
        "title": title,
        "type": type,
        "uniqueItems": uniqueItems,
        "writeOnly": writeOnly,
    };
}

enum SimpleTypes {
    ARRAY,
    BOOLEAN,
    INTEGER,
    NULL,
    NUMBER,
    OBJECT,
    STRING
}

final simpleTypesValues = EnumValues({
    "array": SimpleTypes.ARRAY,
    "boolean": SimpleTypes.BOOLEAN,
    "integer": SimpleTypes.INTEGER,
    "null": SimpleTypes.NULL,
    "number": SimpleTypes.NUMBER,
    "object": SimpleTypes.OBJECT,
    "string": SimpleTypes.STRING
});


///inserts a simple divider
class Divider {
    
    ///Show field depending on value of other field
    ShowOnProperty? showOn;
    DividerType type;

    Divider({
        this.showOn,
        required this.type,
    });

    factory Divider.fromJson(Map<String, dynamic> json) => Divider(
        showOn: json["showOn"] == null ? null : ShowOnProperty.fromJson(json["showOn"]),
        type: dividerTypeValues.map[json["type"]]!,
    );

    Map<String, dynamic> toJson() => {
        "showOn": showOn?.toJson(),
        "type": dividerTypeValues.reverse[type],
    };
}

enum DividerType {
    DIVIDER
}

final dividerTypeValues = EnumValues({
    "Divider": DividerType.DIVIDER
});


///Options for text fields
class FieldSpecificOptions {
    
    ///Different color variants
    ColorVariant1? buttonVariant;
    
    ///Choose how an enum should be displayed
    DisplayAs? displayAs;
    
    ///If the text in a enums select field is supposed to differ from the keys, they can be
    ///specified as properties of this object. The value in the enum must be used as property
    ///name
    Map<String, String>? enumTitles;
    
    ///Radiobutton-/Checkbox group will be stacked if set to true
    bool? stacked;
    
    ///Will be rendered as tags-Field
    FieldSpecificOptionsTags? tags;
    
    ///The accepted File Types
    String? acceptedFileType;
    
    ///Allows the upload of multiple files with fileupload
    bool? allowMultipleFiles;
    
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

    FieldSpecificOptions({
        this.buttonVariant,
        this.displayAs,
        this.enumTitles,
        this.stacked,
        this.tags,
        this.acceptedFileType,
        this.allowMultipleFiles,
        this.autocomplete,
        this.format,
        this.multi,
        this.range,
        this.textAlign,
    });

    factory FieldSpecificOptions.fromJson(Map<String, dynamic> json) => FieldSpecificOptions(
        buttonVariant: colorVariant1Values.map[json["buttonVariant"]]!,
        displayAs: displayAsValues.map[json["displayAs"]]!,
        enumTitles: Map.from(json["enumTitles"]!).map((k, v) => MapEntry<String, String>(k, v)),
        stacked: json["stacked"],
        tags: json["tags"] == null ? null : FieldSpecificOptionsTags.fromJson(json["tags"]),
        acceptedFileType: json["acceptedFileType"],
        allowMultipleFiles: json["allowMultipleFiles"],
        autocomplete: autocompleteValues.map[json["autocomplete"]]!,
        format: formatValues.map[json["format"]]!,
        multi: json["multi"],
        range: json["range"],
        textAlign: textAlignValues.map[json["textAlign"]]!,
    );

    Map<String, dynamic> toJson() => {
        "buttonVariant": colorVariant1Values.reverse[buttonVariant],
        "displayAs": displayAsValues.reverse[displayAs],
        "enumTitles": Map.from(enumTitles!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "stacked": stacked,
        "tags": tags?.toJson(),
        "acceptedFileType": acceptedFileType,
        "allowMultipleFiles": allowMultipleFiles,
        "autocomplete": autocompleteValues.reverse[autocomplete],
        "format": formatValues.reverse[format],
        "multi": multi,
        "range": range,
        "textAlign": textAlignValues.reverse[textAlign],
    };
}


///Will be rendered as tags-Field
class FieldSpecificOptionsTags {
    
    ///Set to true to render the field as tags field
    bool? enabled;
    bool? pills;
    
    ///Different color variants
    ColorVariant1? variant;

    FieldSpecificOptionsTags({
        this.enabled,
        this.pills,
        this.variant,
    });

    factory FieldSpecificOptionsTags.fromJson(Map<String, dynamic> json) => FieldSpecificOptionsTags(
        enabled: json["enabled"],
        pills: json["pills"],
        variant: colorVariant1Values.map[json["variant"]]!,
    );

    Map<String, dynamic> toJson() => {
        "enabled": enabled,
        "pills": pills,
        "variant": colorVariant1Values.reverse[variant],
    };
}

class FileUploadOptions {
    
    ///The accepted File Types
    String? acceptedFileType;
    
    ///Allows the upload of multiple files with fileupload
    bool? allowMultipleFiles;

    FileUploadOptions({
        this.acceptedFileType,
        this.allowMultipleFiles,
    });

    factory FileUploadOptions.fromJson(Map<String, dynamic> json) => FileUploadOptions(
        acceptedFileType: json["acceptedFileType"],
        allowMultipleFiles: json["allowMultipleFiles"],
    );

    Map<String, dynamic> toJson() => {
        "acceptedFileType": acceptedFileType,
        "allowMultipleFiles": allowMultipleFiles,
    };
}


///Some HTML to be rendered in the form
class HtmlRenderer {
    String htmlData;
    
    ///Show field depending on value of other field
    ShowOnProperty? showOn;
    HtmlRendererType? type;

    HtmlRenderer({
        required this.htmlData,
        this.showOn,
        this.type,
    });

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

enum HtmlRendererType {
    HTML
}

final htmlRendererTypeValues = EnumValues({
    "HTML": HtmlRendererType.HTML
});


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
        autocomplete: autocompleteValues.map[json["autocomplete"]]!,
        format: formatValues.map[json["format"]]!,
        multi: json["multi"],
        range: json["range"],
        textAlign: textAlignValues.map[json["textAlign"]]!,
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

    Now({
        this.type,
    });

    factory Now.fromJson(Map<String, dynamic> json) => Now(
        type: nowTypeValues.map[json["type"]]!,
    );

    Map<String, dynamic> toJson() => {
        "type": nowTypeValues.reverse[type],
    };
}

enum NowType {
    NOW
}

final nowTypeValues = EnumValues({
    "now": NowType.NOW
});

class OptionsClass {
    OptionsClass();

    factory OptionsClass.fromJson(Map<String, dynamic> json) => OptionsClass(
    );

    Map<String, dynamic> toJson() => {
    };
}


///Rita Rule
///See https://educorvi.github.io/rita/rita-core/docs/schema/#/rule
class Rule {
    
    ///A comment about what the rule does
    String? comment;
    String id;
    dynamic rule;

    Rule({
        this.comment,
        required this.id,
        required this.rule,
    });

    factory Rule.fromJson(Map<String, dynamic> json) => Rule(
        comment: json["comment"],
        id: json["id"],
        rule: json["rule"],
    );

    Map<String, dynamic> toJson() => {
        "comment": comment,
        "id": id,
        "rule": rule,
    };
}

class TagOptions {
    
    ///Will be rendered as tags-Field
    FieldSpecificOptionsTags? tags;

    TagOptions({
        this.tags,
    });

    factory TagOptions.fromJson(Map<String, dynamic> json) => TagOptions(
        tags: json["tags"] == null ? null : FieldSpecificOptionsTags.fromJson(json["tags"]),
    );

    Map<String, dynamic> toJson() => {
        "tags": tags?.toJson(),
    };
}


///Schema for the UI Schema
class UiSchema {
    
    ///The Metaschema of the UI Schema
    String? schema;
    Layout layout;
    
    ///Version of the UI Schema. Changes in a major version are backwards compatible. So a
    ///parser for version z.x must be compatible with all versions z.y where y is <=x.
    String version;

    UiSchema({
        this.schema,
        required this.layout,
        required this.version,
    });

    factory UiSchema.fromJson(Map<String, dynamic> json) => UiSchema(
        schema: json["\u0024schema"],
        layout: Layout.fromJson(json["layout"]),
        version: json["version"],
    );

    Map<String, dynamic> toJson() => {
        "\u0024schema": schema,
        "layout": layout.toJson(),
        "version": version,
    };
}


///The different layouts
class Layout {
    
    ///The ID of the layout
    String? id;
    
    ///May contain a schema reference to the ui schema
    String? schema;
    List<LayoutElement> elements;
    
    ///Additional options
    LayoutOptions? options;
    
    ///Show field depending on value of other field
    ShowOnProperty? showOn;
    LayoutType type;

    Layout({
        this.id,
        this.schema,
        required this.elements,
        this.options,
        this.showOn,
        required this.type,
    });

    factory Layout.fromJson(Map<String, dynamic> json) => Layout(
        id: json["\u0024id"],
        schema: json["\u0024schema"],
        elements: List<LayoutElement>.from(json["elements"].map((x) => LayoutElement.fromJson(x))),
        options: json["options"] == null ? null : LayoutOptions.fromJson(json["options"]),
        showOn: json["showOn"] == null ? null : ShowOnProperty.fromJson(json["showOn"]),
        type: layoutTypeValues.map[json["type"]]!,
    );

    Map<String, dynamic> toJson() => {
        "\u0024id": id,
        "\u0024schema": schema,
        "elements": List<dynamic>.from(elements.map((x) => x.toJson())),
        "options": options?.toJson(),
        "showOn": showOn?.toJson(),
        "type": layoutTypeValues.reverse[type],
    };
}


///The elements of the layout
///
///Different types of layout elements
///
///Used to put a button into the form
///
///Used to group buttons
///
///Contains a form element, e. g. a text input
///
///inserts a simple divider
///
///The different layouts
///
///Some HTML to be rendered in the form
class LayoutElement {
    TheButtonsType? buttonType;
    
    ///Options for the button
    ///
    ///Gives multiple options to configure the element
    ///
    ///Additional options
    dynamic options;
    
    ///Show field depending on value of other field
    ShowOnProperty? showOn;
    
    ///The buttons text
    String? text;
    LayoutElementType? type;
    
    ///The buttons in the button group
    List<Button>? buttons;
    
    ///A json pointer referring to the form element in the forms json schema
    String? scope;
    
    ///The ID of the layout
    String? id;
    
    ///May contain a schema reference to the ui schema
    String? schema;
    List<LayoutElement>? elements;
    String? htmlData;

    LayoutElement({
        this.buttonType,
        this.options,
        this.showOn,
        this.text,
        this.type,
        this.buttons,
        this.scope,
        this.id,
        this.schema,
        this.elements,
        this.htmlData,
    });

    factory LayoutElement.fromJson(Map<String, dynamic> json) => LayoutElement(
        buttonType: theButtonsTypeValues.map[json["buttonType"]]!,
        options: json["options"],
        showOn: json["showOn"] == null ? null : ShowOnProperty.fromJson(json["showOn"]),
        text: json["text"],
        type: layoutElementTypeValues.map[json["type"]]!,
        buttons: json["buttons"] == null ? [] : List<Button>.from(json["buttons"]!.map((x) => Button.fromJson(x))),
        scope: json["scope"],
        id: json["\u0024id"],
        schema: json["\u0024schema"],
        elements: json["elements"] == null ? [] : List<LayoutElement>.from(json["elements"]!.map((x) => LayoutElement.fromJson(x))),
        htmlData: json["htmlData"],
    );

    Map<String, dynamic> toJson() => {
        "buttonType": theButtonsTypeValues.reverse[buttonType],
        "options": options,
        "showOn": showOn?.toJson(),
        "text": text,
        "type": layoutElementTypeValues.reverse[type],
        "buttons": buttons == null ? [] : List<dynamic>.from(buttons!.map((x) => x.toJson())),
        "scope": scope,
        "\u0024id": id,
        "\u0024schema": schema,
        "elements": elements == null ? [] : List<dynamic>.from(elements!.map((x) => x.toJson())),
        "htmlData": htmlData,
    };
}


///Options for the button
///
///Additional options
class TentacledOptions {
    
    ///The layout's CSS classes
    String? cssClass;
    
    ///Specifies that the form-data should not be validated on submission
    bool? formnovalidate;
    
    ///Options that are passed to the submit function. This will not change the behaviour of
    ///VueJsonForm itself, but can bes used by the application/the webcomponent to change the
    ///behaviour of the submit function.
    SubmitOptions? submitOptions;
    
    ///Different color variants
    ColorVariant1? variant;
    
    ///Display the buttons vertical
    bool? vertical;
    
    ///Will be rendered as tags-Field
    PurpleTags? tags;
    
    ///The accepted File Types
    String? acceptedFileType;
    
    ///Allows the upload of multiple files with fileupload
    bool? allowMultipleFiles;
    
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
    
    ///Adds a label for groups (only for type=Group)
    String? label;

    TentacledOptions({
        this.cssClass,
        this.formnovalidate,
        this.submitOptions,
        this.variant,
        this.vertical,
        this.tags,
        this.acceptedFileType,
        this.allowMultipleFiles,
        this.autocomplete,
        this.format,
        this.multi,
        this.range,
        this.textAlign,
        this.label,
    });

    factory TentacledOptions.fromJson(Map<String, dynamic> json) => TentacledOptions(
        cssClass: json["cssClass"],
        formnovalidate: json["formnovalidate"],
        submitOptions: json["submitOptions"] == null ? null : SubmitOptions.fromJson(json["submitOptions"]),
        variant: colorVariant1Values.map[json["variant"]]!,
        vertical: json["vertical"],
        tags: json["tags"] == null ? null : PurpleTags.fromJson(json["tags"]),
        acceptedFileType: json["acceptedFileType"],
        allowMultipleFiles: json["allowMultipleFiles"],
        autocomplete: autocompleteValues.map[json["autocomplete"]]!,
        format: formatValues.map[json["format"]]!,
        multi: json["multi"],
        range: json["range"],
        textAlign: textAlignValues.map[json["textAlign"]]!,
        label: json["label"],
    );

    Map<String, dynamic> toJson() => {
        "cssClass": cssClass,
        "formnovalidate": formnovalidate,
        "submitOptions": submitOptions?.toJson(),
        "variant": colorVariant1Values.reverse[variant],
        "vertical": vertical,
        "tags": tags?.toJson(),
        "acceptedFileType": acceptedFileType,
        "allowMultipleFiles": allowMultipleFiles,
        "autocomplete": autocompleteValues.reverse[autocomplete],
        "format": formatValues.reverse[format],
        "multi": multi,
        "range": range,
        "textAlign": textAlignValues.reverse[textAlign],
        "label": label,
    };
}

enum LayoutElementType {
    BUTTON,
    BUTTONGROUP,
    CONTROL,
    DIVIDER,
    GROUP,
    HORIZONTAL_LAYOUT,
    HTML,
    VERTICAL_LAYOUT
}

final layoutElementTypeValues = EnumValues({
    "Button": LayoutElementType.BUTTON,
    "Buttongroup": LayoutElementType.BUTTONGROUP,
    "Control": LayoutElementType.CONTROL,
    "Divider": LayoutElementType.DIVIDER,
    "Group": LayoutElementType.GROUP,
    "HorizontalLayout": LayoutElementType.HORIZONTAL_LAYOUT,
    "HTML": LayoutElementType.HTML,
    "VerticalLayout": LayoutElementType.VERTICAL_LAYOUT
});


///Additional options
class LayoutOptions {
    
    ///The layout's CSS classes
    String? cssClass;
    
    ///Adds a label for groups (only for type=Group)
    String? label;

    LayoutOptions({
        this.cssClass,
        this.label,
    });

    factory LayoutOptions.fromJson(Map<String, dynamic> json) => LayoutOptions(
        cssClass: json["cssClass"],
        label: json["label"],
    );

    Map<String, dynamic> toJson() => {
        "cssClass": cssClass,
        "label": label,
    };
}

enum LayoutType {
    GROUP,
    HORIZONTAL_LAYOUT,
    VERTICAL_LAYOUT
}

final layoutTypeValues = EnumValues({
    "Group": LayoutType.GROUP,
    "HorizontalLayout": LayoutType.HORIZONTAL_LAYOUT,
    "VerticalLayout": LayoutType.VERTICAL_LAYOUT
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
