// To parse this JSON data, do
//
//     final uiSchema1 = uiSchema1FromJson(jsonString);

import 'dart:convert';

UiSchema1 uiSchema1FromJson(String str) => UiSchema1.fromJson(json.decode(str));

String uiSchema1ToJson(UiSchema1 data) => json.encode(data.toJson());


///Schema for the UI Schema
class UiSchema1 {
    
    ///The Metaschema of the UI Schema
    String? schema;
    Layout layout;
    
    ///Version of the UI Schema. Changes in a major version are backwards compatible, so a
    ///parser for version two must be compatible with UI Schemas of version 2.x but not version
    ///1.x!
    String version;

    UiSchema1({
        this.schema,
        required this.layout,
        required this.version,
    });

    factory UiSchema1.fromJson(Map<String, dynamic> json) => UiSchema1(
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
        buttonType: theButtonsTypeValues.map[json["buttonType"]]!,
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
///Options for text fields
///
///Custom options for the control
///
///Additional options
///
///Options for the button
class LayoutElementOptions {
    
    ///The Controls CSS classes
    ///
    ///The layout's CSS classes
    String? cssClass;
    
    ///Settings if native form submit is used
    NativeSubmitSettings? nativeSubmitOptions;

    LayoutElementOptions({
        this.cssClass,
        this.nativeSubmitOptions,
    });

    factory LayoutElementOptions.fromJson(Map<String, dynamic> json) => LayoutElementOptions(
        cssClass: json["cssClass"],
        nativeSubmitOptions: json["nativeSubmitOptions"] == null ? null : NativeSubmitSettings.fromJson(json["nativeSubmitOptions"]),
    );

    Map<String, dynamic> toJson() => {
        "cssClass": cssClass,
        "nativeSubmitOptions": nativeSubmitOptions?.toJson(),
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
