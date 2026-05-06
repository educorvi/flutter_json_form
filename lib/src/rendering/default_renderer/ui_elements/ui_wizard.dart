import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/form_context.dart';
import 'package:flutter_json_forms/src/rendering/helpers/wizard_helpers.dart';
import 'package:flutter_json_forms/src/rendering/ui_element_contexts.dart';

/// Renders a [UiWizardContext] as a Material [Stepper] wrapped in a
/// [FormWizardScope] so that wizard-navigation buttons inside each step can
/// advance or retreat the wizard.
///
/// All pure computation (visible pages, step titles, page content) is
/// delegated to [WizardHelpers].
Widget buildDefaultWizard(
  BuildContext context,
  UiWizardContext ctx,
  ScrollPhysics physics,
) {
  final formContext = FormContext.of(context)!;
  final visiblePages = WizardHelpers.visiblePages(ctx.wizard, formContext);

  if (visiblePages.isEmpty) return const SizedBox.shrink();

  final stepCount = visiblePages.length;
  final activeStep = WizardHelpers.normalizeStep(ctx.currentStep, stepCount);

  if (activeStep != ctx.currentStep) {
    ctx.onNormalizeStep(activeStep);
  }

  final hasNext = activeStep < stepCount - 1;
  final hasPrevious = activeStep > 0;

  for (var i = 0; i < stepCount; i++) {
    ctx.formKeys.putIfAbsent(i, () => GlobalKey<FormState>());
  }

  final steps = List<Step>.generate(stepCount, (i) {
    final page = visiblePages[i];
    return Step(
      title: Text(WizardHelpers.resolveStepTitle(ctx.wizard, page.originalIndex)),
      content: WizardHelpers.buildPageContent(context, page.layout, i == activeStep, ctx.formKeys[i]!),
      isActive: i <= activeStep,
      state: WizardHelpers.stepState(i, activeStep, i < activeStep),
    );
  });

  return FormWizardScope(
    currentStep: activeStep,
    totalSteps: stepCount,
    nextPage: hasNext ? () => ctx.onNext(activeStep, stepCount) : null,
    previousPage: hasPrevious ? () => ctx.goToStep(activeStep - 1, stepCount) : null,
    child: Stepper(
      currentStep: activeStep,
      steps: steps,
      onStepContinue: hasNext ? () => ctx.onNext(activeStep, stepCount) : null,
      onStepCancel: hasPrevious ? () => ctx.goToStep(activeStep - 1, stepCount) : null,
      onStepTapped: (i) => ctx.onStepTapped(i, stepCount),
      physics: physics,
      controlsBuilder: (_, __) => const SizedBox.shrink(),
    ),
  );
}
