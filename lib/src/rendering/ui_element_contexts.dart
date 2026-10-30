import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;

/// Context passed to [JsonFormRenderer.buildUiVerticalLayout],
/// [JsonFormRenderer.buildUiHorizontalLayout], and
/// [JsonFormRenderer.buildUiGroup].
///
/// Holds the [ui.Layout] element directly so that custom renderers or helpers
/// can access any property of the UI schema without duplication.
class UiLayoutContext {
  final ui.Layout layout;

  const UiLayoutContext(this.layout);

  String? get label => layout.options?.label;
  String? get description => layout.options?.description;
  String? get cssClass => layout.options?.cssClass;

  /// `true` when there is a non-empty label or description.
  ///
  /// The default renderer sets a [LayoutHeaderScope] based on this value so
  /// that nested data controls can suppress their own header to avoid
  /// duplication.  Custom renderers should do the same.
  bool get hasHeader => (label?.trim().isNotEmpty ?? false) || (description?.trim().isNotEmpty ?? false);
}

/// Context passed to [JsonFormRenderer.buildUiButton].
///
/// Holds the [ui.Button] element directly.  The renderer implementation is
/// responsible for resolving the [onPressed] callback from the button's
/// [buttonType] using [ButtonHelpers.resolveOnPressed].
class UiButtonContext {
  final ui.Button button;

  const UiButtonContext(this.button);
}

/// Context passed to [JsonFormRenderer.buildUiButtonGroup].
///
/// Holds the [ui.Buttongroup] element directly so the renderer implementation
/// can build individual button widgets from [buttonGroup.buttons].
class UiButtonGroupContext {
  final ui.Buttongroup buttonGroup;

  const UiButtonGroupContext(this.buttonGroup);
}

/// Context passed to [JsonFormRenderer.buildUiDivider].
///
/// Holds the [ui.Divider] element so renderers can access any schema
/// properties (e.g. future options) without API changes.
class UiDividerContext {
  final ui.Divider divider;

  const UiDividerContext(this.divider);
}

/// Context passed to [JsonFormRenderer.buildUiHtml].
///
/// Holds the [ui.HtmlRenderer] element directly.
class UiHtmlContext {
  final ui.HtmlRenderer htmlRenderer;

  const UiHtmlContext(this.htmlRenderer);

  /// Convenience getter — forwarded from [htmlRenderer.htmlData].
  String get htmlData => htmlRenderer.htmlData;
}

/// Context passed to [JsonFormRenderer.buildUiWizard].
///
/// Holds the [ui.Wizard] element alongside the stateful navigation
/// information that comes from [FormWizard].  The renderer implementation is
/// responsible for computing visible pages, building step content, and
/// wrapping the output in a [FormWizardScope].
class UiWizardContext {
  /// The raw wizard schema element.
  final ui.Wizard wizard;

  /// The currently active step index (already tracked by [FormWizard] state).
  final int currentStep;

  /// Form keys managed by [FormWizard] state — the implementation should call
  /// `putIfAbsent` to initialise keys for new pages before reading them.
  final Map<int, GlobalKey<FormState>> formKeys;

  /// Called by the implementation when it detects that [currentStep] is
  /// out-of-range (e.g. a previously visible page was hidden).  The
  /// implementation passes the corrected step index so the parent [FormWizard]
  /// can schedule a `setState`.
  final void Function(int newStep) onNormalizeStep;

  /// Advances to the next step.  Called with `(activeStep, totalSteps)`.
  final Future<void> Function(int activeStep, int totalSteps) onNext;

  /// Navigates to an arbitrary step.  Called with `(targetStep, totalSteps)`.
  final void Function(int step, int totalSteps) goToStep;

  /// Called when the user taps a step indicator.  Called with
  /// `(tappedStep, totalSteps)`.
  final Future<void> Function(int tappedStep, int totalSteps) onStepTapped;

  const UiWizardContext({
    required this.wizard,
    required this.currentStep,
    required this.formKeys,
    required this.onNormalizeStep,
    required this.onNext,
    required this.goToStep,
    required this.onStepTapped,
  });
}

// ---------------------------------------------------------------------------
// Wizard scope (InheritedWidget for button navigation)
// ---------------------------------------------------------------------------

/// Propagates wizard navigation callbacks down the widget tree so that
/// [NEXT_WIZARD_PAGE] and [PREVIOUS_WIZARD_PAGE] buttons can advance the
/// wizard without a direct reference to the wizard widget.
class FormWizardScope extends InheritedWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback? nextPage;
  final VoidCallback? previousPage;

  const FormWizardScope({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.nextPage,
    this.previousPage,
    required super.child,
  });

  bool get hasNext => nextPage != null;
  bool get hasPrevious => previousPage != null;

  static FormWizardScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FormWizardScope>();
  }

  @override
  bool updateShouldNotify(FormWizardScope oldWidget) {
    return currentStep != oldWidget.currentStep ||
        totalSteps != oldWidget.totalSteps ||
        hasNext != oldWidget.hasNext ||
        hasPrevious != oldWidget.hasPrevious;
  }
}
