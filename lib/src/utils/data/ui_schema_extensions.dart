import '../../models/ui_schema.g.dart' as ui;

extension UnifiedElementsAccessLayoutElement on ui.LayoutElement {
  ui.Options? get asControlOptions => this is ui.Control ? (this as ui.Control).options : null;

  String? get asCssClass {
    switch (this) {
      case ui.Button():
        return (this as ui.Button).options?.cssClass;
      case ui.Layout():
        return (this as ui.Layout).options?.cssClass;
      case ui.Control():
        return (this as ui.Control).options?.formattingOptions?.cssClass;
      default:
        return null;
    }
  }

  List<ui.LayoutElement>? get asElements {
    if (this is ui.Layout) {
      return (this as ui.Layout).elements;
    }
    return null;
  }
}
