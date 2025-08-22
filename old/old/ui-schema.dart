// To parse this JSON data, do
//
//     final uiSchema = uiSchemaFromJson(jsonString);

import 'dart:convert';

UiSchemaModel uiSchemaFromJson(String str) => UiSchemaModel.fromJson(json.decode(str));

String uiSchemaToJson(UiSchemaModel data) => json.encode(data.toJson());


///Schema for the UI Schema
///
///The different Layouts
///
///A wizard that contains the form spread over multiple pages
class UiSchemaModel {
    
    ///May contain a schema reference to the uischema
    String? schema;
    
    ///The elements of the layout
    List<LayoutElement>? elements;
    String? label;
    
    ///Additional Options
    UiSchemaOptions? options;
    ShowOnProperty? showOn;
    UiSchemaType type;
    List<WizardPage>? pages;

    UiSchemaModel({
        this.schema,
        this.elements,
        this.label,
        this.options,
        this.showOn,
        required this.type,
        this.pages,
    });

    factory UiSchemaModel.fromJson(Map<String, dynamic> json) => UiSchemaModel(
        schema: json["\u0024schema"],
        elements: json["elements"] == null ? [] : List<LayoutElement>.from(json["elements"]!.map((x) => LayoutElement.fromJson(x))),
        label: json["label"],
        options: json["options"] == null ? null : UiSchemaOptions.fromJson(json["options"]),
        showOn: json["showOn"] == null ? null : ShowOnProperty.fromJson(json["showOn"]),
        type: uiSchemaTypeValues.map[json["type"]]!,
        pages: json["pages"] == null ? [] : List<WizardPage>.from(json["pages"]!.map((x) => WizardPage.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "\u0024schema": schema,
        "elements": elements == null ? [] : List<dynamic>.from(elements!.map((x) => x.toJson())),
        "label": label,
        "options": options?.toJson(),
        "showOn": showOn?.toJson(),
        "type": uiSchemaTypeValues.reverse[type],
        "pages": pages == null ? [] : List<dynamic>.from(pages!.map((x) => x.toJson())),
    };
}


///Contains a form element, e. g. a text input
///
///The different Layouts
///
///Some HTML to be rendered in the form
class Control {
    
    ///Format for string fields
    Format? format;
    
    ///Gives multiple options to configure the element
    ///
    ///Additional Options
    Options? options;
    
    ///A json pointer referring to the form element in the forms json schema
    String? scope;
    ShowOnProperty? showOn;
    ContentType? type;
    
    ///May contain a schema reference to the uischema
    String? schema;
    
    ///The elements of the layout
    List<LayoutElement>? elements;
    String? label;
    String? htmlData;

    Control({
        this.format,
        this.options,
        this.scope,
        this.showOn,
        this.type,
        this.schema,
        this.elements,
        this.label,
        this.htmlData,
    });

    factory Control.fromJson(Map<String, dynamic> json) => Control(
        format: formatValues.map[json["format"]],
        options: json["options"] == null ? null : Options.fromJson(json["options"]),
        scope: json["scope"],
        showOn: json["showOn"] == null ? null : ShowOnProperty.fromJson(json["showOn"]),
        type: contentTypeValues.map[json["type"]]!,
        schema: json["\u0024schema"],
        elements: json["elements"] == null ? [] : List<LayoutElement>.from(json["elements"]!.map((x) => LayoutElement.fromJson(x))),
        label: json["label"],
        htmlData: json["htmlData"],
    );

    Map<String, dynamic> toJson() => {
        "format": formatValues.reverse[format],
        "options": options?.toJson(),
        "scope": scope,
        "showOn": showOn?.toJson(),
        "type": contentTypeValues.reverse[type],
        "\u0024schema": schema,
        "elements": elements == null ? [] : List<dynamic>.from(elements!.map((x) => x.toJson())),
        "label": label,
        "htmlData": htmlData,
    };
}

class WizardPage {
    Control content;
    
    ///You can use this for example, if you want to use the last page for a submit button
    bool? hideNext;
    
    ///Changes the text of the next button
    String? nextText;
    String title;

    WizardPage({
        required this.content,
        this.hideNext,
        this.nextText,
        required this.title,
    });

    factory WizardPage.fromJson(Map<String, dynamic> json) => WizardPage(
        content: Control.fromJson(json["content"]),
        hideNext: json["hideNext"],
        nextText: json["nextText"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "content": content.toJson(),
        "hideNext": hideNext,
        "nextText": nextText,
        "title": title,
    };
}


///Contains a form element, e. g. a text input
///
///The different Layouts
///
///Some HTML to be rendered in the form
///
///inserts a simple divider
///
///A wizard that contains the form spread over multiple pages
///
///Used to put a button into the form
///
///Used to group buttons
class LayoutElement {
    
    ///Format for string fields
    Format? format;
    
    ///Gives multiple options to configure the element
    ///
    ///Additional Options
    Options? options;
    
    ///A json pointer referring to the form element in the forms json schema
    String? scope;
    ShowOnProperty? showOn;
    LayoutelementType? type;
    
    ///May contain a schema reference to the uischema
    String? schema;
    
    ///The elements of the layout
    List<LayoutElement>? elements;
    String? label;
    String? htmlData;
    List<WizardPage>? pages;
    
    ///Submit or Reset
    TheButtonsType? buttonType;
    
    ///Settings if native form submit is used
    NativeSubmitSettings? nativeSubmitSettings;
    
    ///The buttons text
    String? text;
    BootstrapButtonVariants? variant;
    
    ///The buttons in the button group
    List<Button>? buttons;
    
    ///Display the buttons vertical
    bool? vertical;

    LayoutElement({
        this.format,
        this.options,
        this.scope,
        this.showOn,
        this.type,
        this.schema,
        this.elements,
        this.label,
        this.htmlData,
        this.pages,
        this.buttonType,
        this.nativeSubmitSettings,
        this.text,
        this.variant,
        this.buttons,
        this.vertical,
    });

    factory LayoutElement.fromJson(Map<String, dynamic> json) => LayoutElement(
        format: formatValues.map[json["format"]],
        options: json["options"] == null ? null : Options.fromJson(json["options"]),
        scope: json["scope"],
        showOn: json["showOn"] == null ? null : ShowOnProperty.fromJson(json["showOn"]),
        type: layoutelementTypeValues.map[json["type"]],
        schema: json["\u0024schema"],
        elements: json["elements"] == null ? [] : List<LayoutElement>.from(json["elements"]!.map((x) => LayoutElement.fromJson(x))),
        label: json["label"],
        htmlData: json["htmlData"],
        pages: json["pages"] == null ? [] : List<WizardPage>.from(json["pages"]!.map((x) => WizardPage.fromJson(x))),
        buttonType: theButtonsTypeValues.map[json["buttonType"]],
        nativeSubmitSettings: json["nativeSubmitSettings"] == null ? null : NativeSubmitSettings.fromJson(json["nativeSubmitSettings"]),
        text: json["text"],
        variant: bootstrapButtonVariantsValues.map[json["variant"]],
        buttons: json["buttons"] == null ? [] : List<Button>.from(json["buttons"]!.map((x) => Button.fromJson(x))),
        vertical: json["vertical"],
    );

    Map<String, dynamic> toJson() => {
        "format": formatValues.reverse[format],
        "options": options?.toJson(),
        "scope": scope,
        "showOn": showOn?.toJson(),
        "type": layoutelementTypeValues.reverse[type],
        "\u0024schema": schema,
        "elements": elements == null ? [] : List<dynamic>.from(elements!.map((x) => x.toJson())),
        "label": label,
        "htmlData": htmlData,
        "pages": pages == null ? [] : List<dynamic>.from(pages!.map((x) => x.toJson())),
        "buttonType": theButtonsTypeValues.reverse[buttonType],
        "nativeSubmitSettings": nativeSubmitSettings?.toJson(),
        "text": text,
        "variant": bootstrapButtonVariantsValues.reverse[variant],
        "buttons": buttons == null ? [] : List<dynamic>.from(buttons!.map((x) => x.toJson())),
        "vertical": vertical,
    };
}


///Format for string fields
enum Format {
    COLOR,
    DATE,
    DATE_TIME,
    EMAIL,
    PASSWORD,
    SEARCH,
    TEL,
    TIME,
    URL
}

final formatValues = EnumValues({
    "color": Format.COLOR,
    "date": Format.DATE,
    "date-time": Format.DATE_TIME,
    "email": Format.EMAIL,
    "password": Format.PASSWORD,
    "search": Format.SEARCH,
    "tel": Format.TEL,
    "time": Format.TIME,
    "url": Format.URL
});


///Gives multiple options to configure the element
///
///Additional Options
class Options {
    
    ///The accepted File Types
    String? acceptedFileType;
    
    ///Allows the upload of multiple files with fileupload
    bool? allowMultipleFiles;
    
    ///Will be appended to field
    String? append;
    
    ///Specifies what should be autocompleted by the browser. Possible values are listed here:
    ///https://developer.mozilla.org/en-US/docs/Web/HTML/Attributes/autocomplete#values
    AutocompleteValues? autocomplete;
    
    ///Render fields that support it (Radiobuttons, Checkboxgroups) as Buttons
    dynamic buttons;
    
    ///The Controls CSS classes
    ///
    ///The Layouts CSS classes
    String? cssClass;
    
    ///Will be shown as placeholder in file upload field when file drag and drop
    String? dropPlaceholder;
    
    ///If the text in a enums select field is supposed to differ from the keys, they can be
    ///specified as properties of this object. The value in the enum must be used as property
    ///name
    Map<String, dynamic>? enumTitles;
    
    ///Sets the visibility of the field to hidden. For example useful in combination with a
    ///DateTime field with default:"$now" to create a hidden timestamp.
    bool? hidden;
    
    ///Defines whether the fields label is activated
    bool? label;
    
    ///If set true, textarea will be shown instead of textfield.
    ///Alternatively can be set to the number of wanted lines
    dynamic multi;
    
    ///Will be shown as placeholder in form fields, if supported by field
    String? placeholder;
    
    ///If set to true, a group of radiobuttons will be shown instead of the select field
    bool? radiobuttons;
    
    ///If set to true, numberfield will appear as star-rating-field
    bool? rating;
    
    ///Radiobutton-/Checkbox group will be stacked if set to true
    bool? stacked;
    
    ///If set to true, the checkbox(-group) it was specified for will be rendered as switch(es)
    bool? optionsSwitch;
    
    ///Will be rendered as tags-Field
    Tags? tags;
    
    ///Set the text-align of input fields
    TextAlign? textAlign;

    Options({
        this.acceptedFileType,
        this.allowMultipleFiles,
        this.append,
        this.autocomplete,
        this.buttons,
        this.cssClass,
        this.dropPlaceholder,
        this.enumTitles,
        this.hidden,
        this.label,
        this.multi,
        this.placeholder,
        this.radiobuttons,
        this.rating,
        this.stacked,
        this.optionsSwitch,
        this.tags,
        this.textAlign,
    });

    factory Options.fromJson(Map<String, dynamic> json) => Options(
        acceptedFileType: json["acceptedFileType"],
        allowMultipleFiles: json["allowMultipleFiles"],
        append: json["append"],
        autocomplete: autocompleteValuesValues.map[json["autocomplete"]],
        buttons: json["buttons"],
        cssClass: json["cssClass"],
        dropPlaceholder: json["drop-placeholder"],
        enumTitles: Map.from(json["enumTitles"] ?? {}).map((k, v) => MapEntry<String, dynamic>(k, v)),
        hidden: json["hidden"],
        label: json["label"],
        multi: json["multi"],
        placeholder: json["placeholder"],
        radiobuttons: json["radiobuttons"],
        rating: json["rating"],
        stacked: json["stacked"],
        optionsSwitch: json["switch"],
        tags: json["tags"] == null ? null : Tags.fromJson(json["tags"]),
        textAlign: textAlignValues.map[json["textAlign"]],
    );

    Map<String, dynamic> toJson() => {
        "acceptedFileType": acceptedFileType,
        "allowMultipleFiles": allowMultipleFiles,
        "append": append,
        "autocomplete": autocompleteValuesValues.reverse[autocomplete],
        "buttons": buttons,
        "cssClass": cssClass,
        "drop-placeholder": dropPlaceholder,
        "enumTitles": Map.from(enumTitles!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "hidden": hidden,
        "label": label,
        "multi": multi,
        "placeholder": placeholder,
        "radiobuttons": radiobuttons,
        "rating": rating,
        "stacked": stacked,
        "switch": optionsSwitch,
        "tags": tags?.toJson(),
        "textAlign": textAlignValues.reverse[textAlign],
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


///The Variants, that Bootstrap allows you to have
enum BootstrapButtonVariants {
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

final bootstrapButtonVariantsValues = EnumValues({
    "danger": BootstrapButtonVariants.DANGER,
    "dark": BootstrapButtonVariants.DARK,
    "info": BootstrapButtonVariants.INFO,
    "light": BootstrapButtonVariants.LIGHT,
    "outline-danger": BootstrapButtonVariants.OUTLINE_DANGER,
    "outline-dark": BootstrapButtonVariants.OUTLINE_DARK,
    "outline-info": BootstrapButtonVariants.OUTLINE_INFO,
    "outline-light": BootstrapButtonVariants.OUTLINE_LIGHT,
    "outline-primary": BootstrapButtonVariants.OUTLINE_PRIMARY,
    "outline-secondary": BootstrapButtonVariants.OUTLINE_SECONDARY,
    "outline-success": BootstrapButtonVariants.OUTLINE_SUCCESS,
    "outline-warning": BootstrapButtonVariants.OUTLINE_WARNING,
    "primary": BootstrapButtonVariants.PRIMARY,
    "secondary": BootstrapButtonVariants.SECONDARY,
    "success": BootstrapButtonVariants.SUCCESS,
    "warning": BootstrapButtonVariants.WARNING
});


///Will be rendered as tags-Field
class Tags {
    bool? enabled;
    bool? pills;
    BootstrapButtonVariants? variant;

    Tags({
        this.enabled,
        this.pills,
        this.variant,
    });

    factory Tags.fromJson(Map<String, dynamic> json) => Tags(
        enabled: json["enabled"],
        pills: json["pills"],
        variant: bootstrapButtonVariantsValues.map[json["variant"]],
    );

    Map<String, dynamic> toJson() => {
        "enabled": enabled,
        "pills": pills,
        "variant": bootstrapButtonVariantsValues.reverse[variant],
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


///Show field depending on value of other field
class ShowOnProperty {
    
    ///The value the field from scope is compared against
    dynamic referenceValue;
    
    ///The field this field depends on
    String scope;
    
    ///Condition to be applied
    ShowOnType type;

    ShowOnProperty({
        required this.referenceValue,
        required this.scope,
        required this.type,
    });

    factory ShowOnProperty.fromJson(Map<String, dynamic> json) => ShowOnProperty(
        referenceValue: json["referenceValue"],
        scope: json["scope"],
        type: showOnTypeValues.map[json["type"]]!,
    );

    Map<String, dynamic> toJson() => {
        "referenceValue": referenceValue,
        "scope": scope,
        "type": showOnTypeValues.reverse[type],
    };
}


///Condition to be applied
enum ShowOnType {
    EQUALS,
    GREATER,
    GREATER_OR_EQUAL,
    LONGER,
    NOT_EQUALS,
    SMALLER,
    SMALLER_OR_EQUAL
}

final showOnTypeValues = EnumValues({
    "EQUALS": ShowOnType.EQUALS,
    "GREATER": ShowOnType.GREATER,
    "GREATER_OR_EQUAL": ShowOnType.GREATER_OR_EQUAL,
    "LONGER": ShowOnType.LONGER,
    "NOT_EQUALS": ShowOnType.NOT_EQUALS,
    "SMALLER": ShowOnType.SMALLER,
    "SMALLER_OR_EQUAL": ShowOnType.SMALLER_OR_EQUAL
});

enum ContentType {
    CONTROL,
    GROUP,
    HORIZONTAL_LAYOUT,
    HTML,
    VERTICAL_LAYOUT
}

final contentTypeValues = EnumValues({
    "Control": ContentType.CONTROL,
    "Group": ContentType.GROUP,
    "HorizontalLayout": ContentType.HORIZONTAL_LAYOUT,
    "HTML": ContentType.HTML,
    "VerticalLayout": ContentType.VERTICAL_LAYOUT
});


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
    
    ///Settings if native form submit is used
    NativeSubmitSettings? nativeSubmitSettings;
    
    ///The buttons text
    String text;
    ButtonType type;
    BootstrapButtonVariants? variant;

    Button({
        required this.buttonType,
        this.nativeSubmitSettings,
        required this.text,
        required this.type,
        this.variant,
    });

    factory Button.fromJson(Map<String, dynamic> json) => Button(
        buttonType: theButtonsTypeValues.map[json["buttonType"]]!,
        nativeSubmitSettings: json["nativeSubmitSettings"] == null ? null : NativeSubmitSettings.fromJson(json["nativeSubmitSettings"]),
        text: json["text"],
        type: buttonTypeValues.map[json["type"]]!,
        variant: bootstrapButtonVariantsValues.map[json["variant"]],
    );

    Map<String, dynamic> toJson() => {
        "buttonType": theButtonsTypeValues.reverse[buttonType],
        "nativeSubmitSettings": nativeSubmitSettings?.toJson(),
        "text": text,
        "type": buttonTypeValues.reverse[type],
        "variant": bootstrapButtonVariantsValues.reverse[variant],
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
        formenctype: formenctypeValues.map[json["formenctype"]],
        formmethod: formmethodValues.map[json["formmethod"]],
        formtarget: formtargetValues.map[json["formtarget"]],
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

enum LayoutelementType {
    BUTTON,
    BUTTONGROUP,
    CONTROL,
    DIVIDER,
    GROUP,
    HORIZONTAL_LAYOUT,
    HTML,
    VERTICAL_LAYOUT,
    WIZARD
}

final layoutelementTypeValues = EnumValues({
    "Button": LayoutelementType.BUTTON,
    "Buttongroup": LayoutelementType.BUTTONGROUP,
    "Control": LayoutelementType.CONTROL,
    "Divider": LayoutelementType.DIVIDER,
    "Group": LayoutelementType.GROUP,
    "HorizontalLayout": LayoutelementType.HORIZONTAL_LAYOUT,
    "HTML": LayoutelementType.HTML,
    "VerticalLayout": LayoutelementType.VERTICAL_LAYOUT,
    "Wizard": LayoutelementType.WIZARD
});


///Additional Options
class UiSchemaOptions {
    
    ///The Layouts CSS classes
    String? cssClass;

    UiSchemaOptions({
        this.cssClass,
    });

    factory UiSchemaOptions.fromJson(Map<String, dynamic> json) => UiSchemaOptions(
        cssClass: json["cssClass"],
    );

    Map<String, dynamic> toJson() => {
        "cssClass": cssClass,
    };
}

enum UiSchemaType {
    GROUP,
    HORIZONTAL_LAYOUT,
    VERTICAL_LAYOUT,
    WIZARD
}

final uiSchemaTypeValues = EnumValues({
    "Group": UiSchemaType.GROUP,
    "HorizontalLayout": UiSchemaType.HORIZONTAL_LAYOUT,
    "VerticalLayout": UiSchemaType.VERTICAL_LAYOUT,
    "Wizard": UiSchemaType.WIZARD
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
