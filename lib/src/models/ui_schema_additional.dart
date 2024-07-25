class ControlFormattingOptions {

  ///Will be appended to field
  String? append;

  ///The Controls CSS classes
  String? cssClass;

  ///Disables the field
  bool? disabled;

  ///Sets the visibility of the field to hidden. For example useful in combination with a
  ///DateTime field with default:"$now" to create a hidden timestamp.
  bool? hidden;

  ///Defines whether the fields label is shown
  bool? label;

  ///Will be shown as placeholder in form fields, if supported by field
  String? placeholder;

  ControlFormattingOptions({
    this.append,
    this.cssClass,
    this.disabled,
    this.hidden,
    this.label,
    this.placeholder,
  });

  factory ControlFormattingOptions.fromJson(Map<String, dynamic> json) => ControlFormattingOptions(
    append: json["append"],
    cssClass: json["cssClass"],
    disabled: json["disabled"],
    hidden: json["hidden"],
    label: json["label"],
    placeholder: json["placeholder"],
  );

  Map<String, dynamic> toJson() => {
    "append": append,
    "cssClass": cssClass,
    "disabled": disabled,
    "hidden": hidden,
    "label": label,
    "placeholder": placeholder,
  };
}