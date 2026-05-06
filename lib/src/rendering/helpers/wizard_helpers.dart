import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/form_context.dart';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:flutter_json_forms/src/rendering/helpers/common.dart';
import 'package:flutter_json_forms/src/widgets/elements/form_layout.dart';

/// A resolved wizard page: the original index in [ui.Wizard.pages] together
/// with the [ui.Layout] that defines its content.
typedef WizardPage = ({int originalIndex, ui.Layout layout});

/// Pure-function helpers for multi-step wizard forms.
///
/// State management (current step, max step reached, form keys) stays in the
/// [FormWizard] StatefulWidget.  Only computations that are independent of
/// widget lifecycle live here.
class WizardHelpers {
  WizardHelpers._();

  // ---------------------------------------------------------------------------
  // Visible pages
  // ---------------------------------------------------------------------------

  /// Returns the subset of [wizard.pages] that should currently be visible,
  /// preserving each page's original index so step titles can be resolved
  /// correctly even when pages are hidden.
  static List<WizardPage> visiblePages(
    ui.Wizard wizard,
    FormContext formContext,
  ) {
    return [
      for (var i = 0; i < wizard.pages.length; i++)
        if (formContext.elementShown(showOn: wizard.pages[i].showOn, parentIsShown: true)) (originalIndex: i, layout: wizard.pages[i]),
    ];
  }

  // ---------------------------------------------------------------------------
  // Step title
  // ---------------------------------------------------------------------------

  /// Resolves a human-readable step title for [pageIndex] from the wizard's
  /// [options.pageTitles] list, falling back to "Step N".
  static String resolveStepTitle(ui.Wizard wizard, int pageIndex) {
    final titles = wizard.options?.pageTitles;
    if (titles != null && pageIndex >= 0 && pageIndex < titles.length) {
      return titles[pageIndex];
    }
    return 'Step ${pageIndex + 1}';
  }

  // ---------------------------------------------------------------------------
  // Page content
  // ---------------------------------------------------------------------------

  /// Builds the content widget for a single wizard page.
  ///
  /// When [isCurrent] is `false` an empty [SizedBox] is returned immediately
  /// so inactive pages are not built.  Active pages are wrapped in a [Form]
  /// with [formKey] so per-step validation works.
  static Widget buildPageContent(
    BuildContext context,
    ui.Layout layout,
    bool isCurrent,
    GlobalKey<FormState> formKey,
  ) {
    if (!isCurrent) return const SizedBox.shrink();
    final pageContent = FormLayout.fromLayout(
      layout: layout,
      nestingLevel: -1,
      isShownFromParent: isCurrent,
    );
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: withCss(context, pageContent, cssClass: layout.options?.cssClass),
    );
  }

  // ---------------------------------------------------------------------------
  // Step state
  // ---------------------------------------------------------------------------

  /// Maps wizard indices to the [StepState] enum expected by [Stepper].
  static StepState stepState(int index, int currentStep, bool isCompleted) {
    if (isCompleted) return StepState.complete;
    if (index == currentStep) return StepState.editing;
    return StepState.indexed;
  }

  /// Clamps [step] to the valid range `[0, stepCount - 1]`.
  static int normalizeStep(int step, int stepCount) {
    if (stepCount <= 0 || step <= 0) return 0;
    if (step >= stepCount) return stepCount - 1;
    return step;
  }
}
