import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:flutter_json_forms/src/rendering/renderer_scope.dart';
import 'package:flutter_json_forms/src/rendering/ui_element_contexts.dart';

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
    return RendererScope.of(context).buildUiWizard(
      context,
      UiWizardContext(
        wizard: widget.wizard,
        currentStep: _currentStep,
        formKeys: _formKeys,
        onNormalizeStep: (newStep) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            setState(() => _currentStep = newStep);
          });
        },
        onNext: _onNext,
        goToStep: _goToStep,
        onStepTapped: _onStepTapped,
      ),
    );
  }

  Future<void> _onStepTapped(int tappedStep, int stepCount) async {
    if (tappedStep == _currentStep) return;

    if (tappedStep < _currentStep) {
      setState(() => _currentStep = tappedStep);
      return;
    }

    if (tappedStep > _maxStepReached + 1) return;

    final formKey = _formKeys[_currentStep];
    if (formKey != null && formKey.currentState != null) {
      if (formKey.currentState!.validate()) {
        setState(() {
          _currentStep = tappedStep;
          if (_currentStep > _maxStepReached) _maxStepReached = _currentStep;
        });
      }
    } else {
      setState(() {
        _currentStep = tappedStep;
        if (_currentStep > _maxStepReached) _maxStepReached = _currentStep;
      });
    }
  }

  void _goToStep(int step, int stepCount) {
    if (stepCount == 0) return;
    final normalized = _normalize(step, stepCount);
    if (normalized == _currentStep) return;
    setState(() => _currentStep = normalized);
  }

  Future<void> _onNext(int activeStep, int stepCount) async {
    final formKey = _formKeys[activeStep];
    if (formKey != null && formKey.currentState != null) {
      if (formKey.currentState!.validate()) {
        setState(() {
          _goToStep(activeStep + 1, stepCount);
          if (_currentStep > _maxStepReached) _maxStepReached = _currentStep;
        });
      }
    } else {
      setState(() {
        _goToStep(activeStep + 1, stepCount);
        if (_currentStep > _maxStepReached) _maxStepReached = _currentStep;
      });
    }
  }

  int _normalize(int step, int stepCount) {
    if (stepCount <= 0 || step <= 0) return 0;
    if (step >= stepCount) return stepCount - 1;
    return step;
  }
}
