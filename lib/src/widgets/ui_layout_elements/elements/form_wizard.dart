import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/form_context.dart';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:flutter_json_forms/src/widgets/ui_layout_elements/elements/form_layout.dart';
import 'package:flutter_json_forms/src/widgets/shared/common.dart';

class FormWizard extends StatefulWidget {
  final ui.Wizard wizard;

  const FormWizard.fromLayout({super.key, required this.wizard});

  @override
  State<FormWizard> createState() => _FormWizardState();
}

class _FormWizardState extends State<FormWizard> {
  int _currentStep = 0;
  int _maxStepReached = 0;
  final Map<int, GlobalKey<FormState>> _formKeys = {};

  @override
  Widget build(BuildContext context) {
    final formContext = FormContext.of(context)!;
    final visiblePages = _visiblePages(formContext);

    if (visiblePages.isEmpty) {
      return const SizedBox.shrink();
    }

    final stepCount = visiblePages.length;
    final activeStep = _normalizeStep(_currentStep, stepCount);

    if (activeStep != _currentStep) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() => _currentStep = activeStep);
      });
    }

    final steps = List<Step>.generate(stepCount, (index) {
      final page = visiblePages[index];
      _formKeys.putIfAbsent(index, () => GlobalKey<FormState>());
      return Step(
        title: Text(_resolveTitle(page.originalIndex)),
        content: index == activeStep ? _buildPageContent(context, page.layout, true, _formKeys[index]!) : const SizedBox.shrink(),
        isActive: index <= activeStep,
        state: _stepStateFor(index, activeStep),
      );
    });

    final hasNext = activeStep < stepCount - 1;
    final hasPrevious = activeStep > 0;
    final nextCallback = hasNext ? () => _onNext(activeStep, stepCount) : null;
    final previousCallback = hasPrevious ? () => _goToStep(activeStep - 1, stepCount) : null;

    return FormWizardScope(
      currentStep: activeStep,
      totalSteps: stepCount,
      nextPage: nextCallback,
      previousPage: previousCallback,
      child: Stepper(
        currentStep: activeStep,
        steps: steps,
        onStepContinue: nextCallback,
        onStepCancel: previousCallback,
        onStepTapped: (index) => _onStepTapped(index, stepCount),
        physics: const NeverScrollableScrollPhysics(),
        controlsBuilder: (_, __) => const SizedBox.shrink(),
      ),
    );
  }

  Future<void> _onStepTapped(int tappedStep, int stepCount) async {
    if (tappedStep == _currentStep) return;

    // Always allow going back
    if (tappedStep < _currentStep) {
      setState(() => _currentStep = tappedStep);
      return;
    }

    // Only allow going forward to maxStepReached+1
    if (tappedStep > _maxStepReached + 1) return;

    // Validate current step before moving forward
    final formKey = _formKeys[_currentStep];
    if (formKey != null && formKey.currentState != null) {
      if (formKey.currentState!.validate()) {
        setState(() {
          _currentStep = tappedStep;
          if (_currentStep > _maxStepReached) {
            _maxStepReached = _currentStep;
          }
        });
      }
    } else {
      setState(() {
        _currentStep = tappedStep;
        if (_currentStep > _maxStepReached) {
          _maxStepReached = _currentStep;
        }
      });
    }
  }

  List<_WizardPage> _visiblePages(FormContext formContext) {
    final pages = <_WizardPage>[];
    for (var i = 0; i < widget.wizard.pages.length; i++) {
      final pageLayout = widget.wizard.pages[i];
      final isVisible = formContext.elementShown(
        showOn: pageLayout.showOn,
        parentIsShown: true,
      );
      if (isVisible) {
        pages.add(_WizardPage(originalIndex: i, layout: pageLayout));
      }
    }
    return pages;
  }

  void _goToStep(int step, int stepCount) {
    if (stepCount == 0) return;
    final normalized = _normalizeStep(step, stepCount);
    if (normalized == _currentStep) return;
    setState(() => _currentStep = normalized);
  }

  Future<void> _onNext(int activeStep, int stepCount) async {
    final formKey = _formKeys[activeStep];
    if (formKey != null && formKey.currentState != null) {
      if (formKey.currentState!.validate()) {
        setState(() {
          _goToStep(activeStep + 1, stepCount);
          if (_currentStep > _maxStepReached) {
            _maxStepReached = _currentStep;
          }
        });
      }
    } else {
      setState(() {
        _goToStep(activeStep + 1, stepCount);
        if (_currentStep > _maxStepReached) {
          _maxStepReached = _currentStep;
        }
      });
    }
  }

  int _normalizeStep(int step, int stepCount) {
    if (stepCount <= 0 || step <= 0) {
      return 0;
    }
    if (step >= stepCount) {
      return stepCount - 1;
    }
    return step;
  }

  Widget _buildPageContent(BuildContext context, ui.Layout layout, bool isCurrent, GlobalKey<FormState> formKey) {
    final pageContent = FormLayout.fromLayout(
      layout: layout,
      nestingLevel: -1,
      isShownFromParent: isCurrent,
    );
    if (!isCurrent) return const SizedBox.shrink();
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: withCss(context, pageContent, cssClass: layout.options?.cssClass),
    );
  }

  StepState _stepStateFor(int index, int activeStep) {
    if (index < activeStep) {
      return StepState.complete;
    }
    if (index == activeStep) {
      return StepState.editing;
    }
    return StepState.indexed;
  }

  String _resolveTitle(int pageIndex) {
    final titles = widget.wizard.options?.pageTitles;
    if (titles != null && pageIndex >= 0 && pageIndex < titles.length) {
      return titles[pageIndex];
    }
    return 'Step ${pageIndex + 1}';
  }
}

class _WizardPage {
  final int originalIndex;
  final ui.Layout layout;

  const _WizardPage({required this.originalIndex, required this.layout});
}

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
