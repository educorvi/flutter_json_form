// To parse this JSON data, do
//
//     final uiSchema = uiSchemaFromJson(jsonString);

import 'dart:convert';

UiSchemaModel uiSchemaFromJson(String str) => UiSchemaModel.fromJson(json.decode(str));

String uiSchemaToJson(UiSchemaModel data) => json.encode(data.toJson());


///Schema for the UI Schema
class UiSchemaModel {
    
    ///The Metaschema of the UI Schema
    String? schema;
    
    ///The different layouts
    Layout layout;
    
    ///Version of the UI Schema. Changes in a major version are backwards compatible, so a
    ///parser for version two must be compatible with UI Schemas of version 2.x but not version
    ///1.x!
    String version;

    UiSchemaModel({
        this.schema,
        required this.layout,
        required this.version,
    });

    factory UiSchemaModel.fromJson(Map<String, dynamic> json) => UiSchemaModel(
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
    
    ///The elements of the layout
    List<LayoutElement> elements;
    
    ///Adds a label for groups (only for type=Group)
    String? label;
    
    ///Additional options
    Options? options;
    
    ///Show field depending on value of other field
    ShowOnProperty? showOn;
    LayoutType type;

    Layout({
        this.id,
        this.schema,
        required this.elements,
        this.label,
        this.options,
        this.showOn,
        required this.type,
    });

    factory Layout.fromJson(Map<String, dynamic> json) => Layout(
        id: json["\u0024id"],
        schema: json["\u0024schema"],
        elements: List<LayoutElement>.from(json["elements"].map((x) => LayoutElement.fromJson(x))),
        label: json["label"],
        options: json["options"] == null ? null : Options.fromJson(json["options"]),
        showOn: json["showOn"] == null ? null : ShowOnProperty.fromJson(json["showOn"]),
        type: layoutTypeValues.map[json["type"]]!,
    );

    Map<String, dynamic> toJson() => {
        "\u0024id": id,
        "\u0024schema": schema,
        "elements": List<dynamic>.from(elements.map((x) => x.toJson())),
        "label": label,
        "options": options?.toJson(),
        "showOn": showOn?.toJson(),
        "type": layoutTypeValues.reverse[type],
    };
}


///Contains a form element, e. g. a text input
///
///The different layouts
///
///Some HTML to be rendered in the form
///
///inserts a simple divider
///
///Used to put a button into the form
///
///Used to group buttons
class LayoutElement {
    
    ///Gives multiple options to configure the element
    ///
    ///Additional options
    ///
    ///Options for the button
    LayoutElementOptions? options;
    
    ///A json pointer referring to the form element in the forms json schema
    String? scope;
    
    ///Show field depending on value of other field
    ShowOnProperty? showOn;
    LayoutElementType? type;
    
    ///The ID of the layout
    String? id;
    
    ///May contain a schema reference to the ui schema
    String? schema;
    
    ///The elements of the layout
    List<LayoutElement>? elements;
    
    ///Adds a label for groups (only for type=Group)
    String? label;
    String? htmlData;
    
    ///Submit or Reset
    TheButtonsType? buttonType;
    
    ///The buttons text
    String? text;
    
    ///The buttons in the button group
    List<Button>? buttons;
    
    ///Display the buttons vertical
    bool? vertical;

    LayoutElement({
        this.options,
        this.scope,
        this.showOn,
        this.type,
        this.id,
        this.schema,
        this.elements,
        this.label,
        this.htmlData,
        this.buttonType,
        this.text,
        this.buttons,
        this.vertical,
    });

    factory LayoutElement.fromJson(Map<String, dynamic> json) => LayoutElement(
        options: json["options"] == null ? null : LayoutElementOptions.fromJson(json["options"]),
        scope: json["scope"],
        showOn: json["showOn"] == null ? null : ShowOnProperty.fromJson(json["showOn"]),
        type: layoutElementTypeValues.map[json["type"]]!,
        id: json["\u0024id"],
        schema: json["\u0024schema"],
        elements: json["elements"] == null ? [] : List<LayoutElement>.from(json["elements"]!.map((x) => LayoutElement.fromJson(x))),
        label: json["label"],
        htmlData: json["htmlData"],
        buttonType: theButtonsTypeValues.map[json["buttonType"]],
        text: json["text"],
        buttons: json["buttons"] == null ? [] : List<Button>.from(json["buttons"]!.map((x) => Button.fromJson(x))),
        vertical: json["vertical"],
    );

    Map<String, dynamic> toJson() => {
        "options": options?.toJson(),
        "scope": scope,
        "showOn": showOn?.toJson(),
        "type": layoutElementTypeValues.reverse[type],
        "\u0024id": id,
        "\u0024schema": schema,
        "elements": elements == null ? [] : List<dynamic>.from(elements!.map((x) => x.toJson())),
        "label": label,
        "htmlData": htmlData,
        "buttonType": theButtonsTypeValues.reverse[buttonType],
        "text": text,
        "buttons": buttons == null ? [] : List<dynamic>.from(buttons!.map((x) => x.toJson())),
        "vertical": vertical,
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


///Used to put a button into the form
class Button {
    
    ///Submit or Reset
    TheButtonsType buttonType;
    
    ///Options for the button
    ButtonOptions? options;
    
    ///The buttons text
    String text;
    ButtonType type;

    Button({
        required this.buttonType,
        this.options,
        required this.text,
        required this.type,
    });

    factory Button.fromJson(Map<String, dynamic> json) => Button(
        buttonType: theButtonsTypeValues.map[json["buttonType"]]!,
        options: json["options"] == null ? null : ButtonOptions.fromJson(json["options"]),
        text: json["text"],
        type: buttonTypeValues.map[json["type"]]!,
    );

    Map<String, dynamic> toJson() => {
        "buttonType": theButtonsTypeValues.reverse[buttonType],
        "options": options?.toJson(),
        "text": text,
        "type": buttonTypeValues.reverse[type],
    };
}


///Options for the button
class ButtonOptions {
    
    ///The layout's CSS classes
    String? cssClass;
    
    ///Settings if native form submit is used
    NativeSubmitSettings? nativeSubmitOptions;

    ButtonOptions({
        this.cssClass,
        this.nativeSubmitOptions,
    });

    factory ButtonOptions.fromJson(Map<String, dynamic> json) => ButtonOptions(
        cssClass: json["cssClass"],
        nativeSubmitOptions: json["nativeSubmitOptions"] == null ? null : NativeSubmitSettings.fromJson(json["nativeSubmitOptions"]),
    );

    Map<String, dynamic> toJson() => {
        "cssClass": cssClass,
        "nativeSubmitOptions": nativeSubmitOptions?.toJson(),
    };
}


///Settings if native form submit is used
class NativeSubmitSettings {
    
    ///Specifies where to send the form-data when a form is submitted
    String? formaction;
    
    ///Specifies how form-data should be encoded before sending it to a server
    Formenctype? formenctype;
    
    ///Specifies how to send the form-data
    Formmethod? formmethod;
    
    ///Specifies where to display the response after submitting the form
    Formtarget? formtarget;

    NativeSubmitSettings({
        this.formaction,
        this.formenctype,
        this.formmethod,
        this.formtarget,
    });

    factory NativeSubmitSettings.fromJson(Map<String, dynamic> json) => NativeSubmitSettings(
        formaction: json["formaction"],
        formenctype: formenctypeValues.map[json["formenctype"]]!,
        formmethod: formmethodValues.map[json["formmethod"]]!,
        formtarget: formtargetValues.map[json["formtarget"]]!,
    );

    Map<String, dynamic> toJson() => {
        "formaction": formaction,
        "formenctype": formenctypeValues.reverse[formenctype],
        "formmethod": formmethodValues.reverse[formmethod],
        "formtarget": formtargetValues.reverse[formtarget],
    };
}


///Specifies how form-data should be encoded before sending it to a server
enum Formenctype {
    APPLICATION_X_WWW_FORM_URLENCODED,
    MULTIPART_FORM_DATA,
    TEXT_PLAIN
}

final formenctypeValues = EnumValues({
    "application/x-www-form-urlencoded": Formenctype.APPLICATION_X_WWW_FORM_URLENCODED,
    "multipart/form-data": Formenctype.MULTIPART_FORM_DATA,
    "text/plain": Formenctype.TEXT_PLAIN
});


///Specifies how to send the form-data
enum Formmethod {
    GET,
    POST
}

final formmethodValues = EnumValues({
    "get": Formmethod.GET,
    "post": Formmethod.POST
});


///Specifies where to display the response after submitting the form
enum Formtarget {
    BLANK,
    PARENT,
    SELF,
    TOP
}

final formtargetValues = EnumValues({
    "_blank": Formtarget.BLANK,
    "_parent": Formtarget.PARENT,
    "_self": Formtarget.SELF,
    "_top": Formtarget.TOP
});

enum ButtonType {
    BUTTON
}

final buttonTypeValues = EnumValues({
    "Button": ButtonType.BUTTON
});


///Gives multiple options to configure the element
///
///Additional options
///
///Options for the button
class LayoutElementOptions {
    
    ///The accepted File Types
    String? acceptedFileType;
    
    ///Allows the upload of multiple files with fileupload
    bool? allowMultipleFiles;
    
    ///Will be appended to field
    String? append;
    AutocompleteValues? autocomplete;
    ColorVariants? buttonVariant;
    
    ///The Controls CSS classes
    ///
    ///The layout's CSS classes
    String? cssClass;
    
    ///Disables the field
    bool? disabled;
    
    ///Choose how an enum should be displayed
    DisplayAs? displayAs;
    
    ///If the text in a enums select field is supposed to differ from the keys, they can be
    ///specified as properties of this object. The value in the enum must be used as property
    ///name
    Map<String, dynamic>? enumTitles;
    
    ///Format for string fields
    Format? format;
    
    ///Sets the visibility of the field to hidden. For example useful in combination with a
    ///DateTime field with default:"$now" to create a hidden timestamp.
    bool? hidden;
    
    ///Defines whether the fields label is shown
    bool? label;
    
    ///If set true, textarea will be shown instead of textfield.
    ///Alternatively can be set to the number of wanted lines
    dynamic multi;
    
    ///Will be shown as placeholder in form fields, if supported by field
    String? placeholder;
    
    ///Radiobutton-/Checkbox group will be stacked if set to true
    bool? stacked;
    
    ///If set to true, the checkbox(-group) it was specified for will be rendered as switch(es)
    bool? optionsSwitch;
    
    ///Will be rendered as tags-Field
    Tags? tags;
    
    ///Settings if native form submit is used
    NativeSubmitSettings? nativeSubmitOptions;

    LayoutElementOptions({
        this.acceptedFileType,
        this.allowMultipleFiles,
        this.append,
        this.autocomplete,
        this.buttonVariant,
        this.cssClass,
        this.disabled,
        this.displayAs,
        this.enumTitles,
        this.format,
        this.hidden,
        this.label,
        this.multi,
        this.placeholder,
        this.stacked,
        this.optionsSwitch,
        this.tags,
        this.nativeSubmitOptions,
    });

    factory LayoutElementOptions.fromJson(Map<String, dynamic> json) => LayoutElementOptions(
        acceptedFileType: json["acceptedFileType"],
        allowMultipleFiles: json["allowMultipleFiles"],
        append: json["append"],
        autocomplete: autocompleteValuesValues.map[json["autocomplete"]],
        buttonVariant: colorVariantsValues.map[json["buttonVariant"]],
        cssClass: json["cssClass"],
        disabled: json["disabled"],
        displayAs: displayAsValues.map[json["displayAs"]],
        enumTitles: json["enumTitles"] == null ? null : Map.from(json["enumTitles"]!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        format: formatValues.map[json["format"]],
        hidden: json["hidden"],
        label: json["label"],
        multi: json["multi"],
        placeholder: json["placeholder"],
        stacked: json["stacked"],
        optionsSwitch: json["switch"],
        tags: json["tags"] == null ? null : Tags.fromJson(json["tags"]),
        nativeSubmitOptions: json["nativeSubmitOptions"] == null ? null : NativeSubmitSettings.fromJson(json["nativeSubmitOptions"]),
    );

    Map<String, dynamic> toJson() => {
        "acceptedFileType": acceptedFileType,
        "allowMultipleFiles": allowMultipleFiles,
        "append": append,
        "autocomplete": autocompleteValuesValues.reverse[autocomplete],
        "buttonVariant": colorVariantsValues.reverse[buttonVariant],
        "cssClass": cssClass,
        "disabled": disabled,
        "displayAs": displayAsValues.reverse[displayAs],
        "enumTitles": Map.from(enumTitles!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "format": formatValues.reverse[format],
        "hidden": hidden,
        "label": label,
        "multi": multi,
        "placeholder": placeholder,
        "stacked": stacked,
        "switch": optionsSwitch,
        "tags": tags?.toJson(),
        "nativeSubmitOptions": nativeSubmitOptions?.toJson(),
    };
}


///Specifies what should be autocompleted by the browser. Possible values are taken from
///https://developer.mozilla.org/en-US/docs/Web/HTML/Attributes/autocomplete#values
enum AutocompleteValues {
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

final autocompleteValuesValues = EnumValues({
    "additional-name": AutocompleteValues.ADDITIONAL_NAME,
    "address-level1": AutocompleteValues.ADDRESS_LEVEL1,
    "address-level2": AutocompleteValues.ADDRESS_LEVEL2,
    "address-level3": AutocompleteValues.ADDRESS_LEVEL3,
    "address-level4": AutocompleteValues.ADDRESS_LEVEL4,
    "address-line1": AutocompleteValues.ADDRESS_LINE1,
    "address-line2": AutocompleteValues.ADDRESS_LINE2,
    "address-line3": AutocompleteValues.ADDRESS_LINE3,
    "bday": AutocompleteValues.BDAY,
    "bday-day": AutocompleteValues.BDAY_DAY,
    "bday-month": AutocompleteValues.BDAY_MONTH,
    "bday-year": AutocompleteValues.BDAY_YEAR,
    "billing": AutocompleteValues.BILLING,
    "cc-additional-name": AutocompleteValues.CC_ADDITIONAL_NAME,
    "cc-csc": AutocompleteValues.CC_CSC,
    "cc-exp": AutocompleteValues.CC_EXP,
    "cc-exp-month": AutocompleteValues.CC_EXP_MONTH,
    "cc-exp-year": AutocompleteValues.CC_EXP_YEAR,
    "cc-family-name": AutocompleteValues.CC_FAMILY_NAME,
    "cc-given-name": AutocompleteValues.CC_GIVEN_NAME,
    "cc-name": AutocompleteValues.CC_NAME,
    "cc-number": AutocompleteValues.CC_NUMBER,
    "cc-type": AutocompleteValues.CC_TYPE,
    "country": AutocompleteValues.COUNTRY,
    "country-name": AutocompleteValues.COUNTRY_NAME,
    "current-password": AutocompleteValues.CURRENT_PASSWORD,
    "email": AutocompleteValues.EMAIL,
    "family-name": AutocompleteValues.FAMILY_NAME,
    "given-name": AutocompleteValues.GIVEN_NAME,
    "honorific-prefix": AutocompleteValues.HONORIFIC_PREFIX,
    "honorific-suffix": AutocompleteValues.HONORIFIC_SUFFIX,
    "impp": AutocompleteValues.IMPP,
    "language": AutocompleteValues.LANGUAGE,
    "name": AutocompleteValues.NAME,
    "new-password": AutocompleteValues.NEW_PASSWORD,
    "nickname": AutocompleteValues.NICKNAME,
    "off": AutocompleteValues.OFF,
    "on": AutocompleteValues.ON,
    "one-time-code": AutocompleteValues.ONE_TIME_CODE,
    "organization": AutocompleteValues.ORGANIZATION,
    "organization-title": AutocompleteValues.ORGANIZATION_TITLE,
    "photo": AutocompleteValues.PHOTO,
    "postal-code": AutocompleteValues.POSTAL_CODE,
    "sex": AutocompleteValues.SEX,
    "shipping": AutocompleteValues.SHIPPING,
    "street-address": AutocompleteValues.STREET_ADDRESS,
    "tel": AutocompleteValues.TEL,
    "tel-area-code": AutocompleteValues.TEL_AREA_CODE,
    "tel-country-code": AutocompleteValues.TEL_COUNTRY_CODE,
    "tel-extension": AutocompleteValues.TEL_EXTENSION,
    "tel-local": AutocompleteValues.TEL_LOCAL,
    "tel-national": AutocompleteValues.TEL_NATIONAL,
    "transaction-amount": AutocompleteValues.TRANSACTION_AMOUNT,
    "transaction-currency": AutocompleteValues.TRANSACTION_CURRENCY,
    "url": AutocompleteValues.URL,
    "username": AutocompleteValues.USERNAME,
    "webauthn": AutocompleteValues.WEBAUTHN
});


///Variants for colors
enum ColorVariants {
    DANGER,
    INFO,
    OUTLINE_DANGER,
    OUTLINE_INFO,
    OUTLINE_PRIMARY,
    OUTLINE_SECONDARY,
    OUTLINE_SUCCESS,
    OUTLINE_WARNING,
    PRIMARY,
    SECONDARY,
    SUCCESS,
    WARNING
}

final colorVariantsValues = EnumValues({
    "danger": ColorVariants.DANGER,
    "info": ColorVariants.INFO,
    "outline-danger": ColorVariants.OUTLINE_DANGER,
    "outline-info": ColorVariants.OUTLINE_INFO,
    "outline-primary": ColorVariants.OUTLINE_PRIMARY,
    "outline-secondary": ColorVariants.OUTLINE_SECONDARY,
    "outline-success": ColorVariants.OUTLINE_SUCCESS,
    "outline-warning": ColorVariants.OUTLINE_WARNING,
    "primary": ColorVariants.PRIMARY,
    "secondary": ColorVariants.SECONDARY,
    "success": ColorVariants.SUCCESS,
    "warning": ColorVariants.WARNING
});


///Choose how an enum should be displayed
enum DisplayAs {
    BUTTONS,
    RADIOBUTTONS,
    SELECT
}

final displayAsValues = EnumValues({
    "buttons": DisplayAs.BUTTONS,
    "radiobuttons": DisplayAs.RADIOBUTTONS,
    "select": DisplayAs.SELECT
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
class Tags {
    
    ///Set to true to render the field as tags field
    bool? enabled;
    bool? pills;
    ColorVariants? variant;

    Tags({
        this.enabled,
        this.pills,
        this.variant,
    });

    factory Tags.fromJson(Map<String, dynamic> json) => Tags(
        enabled: json["enabled"],
        pills: json["pills"],
        variant: colorVariantsValues.map[json["variant"]]!,
    );

    Map<String, dynamic> toJson() => {
        "enabled": enabled,
        "pills": pills,
        "variant": colorVariantsValues.reverse[variant],
    };
}


///Show field depending on value of other field
///
///Legacy Variant of defining ShowOn property
class ShowOnProperty {
    
    ///The value the field from scope is compared against
    dynamic referenceValue;
    
    ///The field this field depends on
    String scope;
    
    ///Condition to be applied
    ShowOnFunctionType type;

    ShowOnProperty({
        required this.referenceValue,
        required this.scope,
        required this.type,
    });

    factory ShowOnProperty.fromJson(Map<String, dynamic> json) => ShowOnProperty(
        referenceValue: json["referenceValue"],
        scope: json["scope"],
        type: showOnFunctionTypeValues.map[json["type"]]!,
    );

    Map<String, dynamic> toJson() => {
        "referenceValue": referenceValue,
        "scope": scope,
        "type": showOnFunctionTypeValues.reverse[type],
    };
}


///Condition to be applied
enum ShowOnFunctionType {
    EQUALS,
    GREATER,
    GREATER_OR_EQUAL,
    LONGER,
    NOT_EQUALS,
    SMALLER,
    SMALLER_OR_EQUAL
}

final showOnFunctionTypeValues = EnumValues({
    "EQUALS": ShowOnFunctionType.EQUALS,
    "GREATER": ShowOnFunctionType.GREATER,
    "GREATER_OR_EQUAL": ShowOnFunctionType.GREATER_OR_EQUAL,
    "LONGER": ShowOnFunctionType.LONGER,
    "NOT_EQUALS": ShowOnFunctionType.NOT_EQUALS,
    "SMALLER": ShowOnFunctionType.SMALLER,
    "SMALLER_OR_EQUAL": ShowOnFunctionType.SMALLER_OR_EQUAL
});

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
class Options {
    
    ///The layout's CSS classes
    String? cssClass;

    Options({
        this.cssClass,
    });

    factory Options.fromJson(Map<String, dynamic> json) => Options(
        cssClass: json["cssClass"],
    );

    Map<String, dynamic> toJson() => {
        "cssClass": cssClass,
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
