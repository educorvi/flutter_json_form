import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../../utils/test_utils.dart';
import 'wizard_data.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Wizard layout', () {
    testWidgets('renders wizard and shows the first step by default', (tester) async {
      // GIVEN: the wizard schema and UI schema are rendered
      await _pumpWizard(tester);

      // THEN: the first step should be visible by default
      expect(find.byType(Stepper), findsOneWidget);
      expect(_firstNameField, findsOneWidget);
      expect(_ageField, findsNothing);
      expect(_emailField, findsNothing);
    });

    testWidgets('prevents advancing when current step is invalid', (tester) async {
      // GIVEN: the wizard form is loaded on the first step
      await _pumpWizard(tester);

      // WHEN: the user tries to advance without completing the step
      await tester.tap(_nextButtonFinder());
      await tester.pumpAndSettle();

      // THEN: the wizard should stay on the current step
      expect(_ageField, findsNothing, reason: 'Should remain on first step when it is invalid');

      // WHEN: the user completes the first step and advances
      await enterTextAndSettle(tester, _firstNameField, _validFirstName);
      await tester.tap(_nextButtonFinder());
      await tester.pumpAndSettle();

      // THEN: the next step becomes visible
      expect(_ageField, findsOneWidget, reason: 'Should advance after the step validates');
    });

    testWidgets('submits wizard data successfully once all steps are valid', (tester) async {
      // GIVEN: the wizard is rendered with a submission callback
      Map<String, dynamic>? submittedValues;
      await _pumpWizard(tester, onSubmit: (values) => submittedValues = values);

      // WHEN: every step is completed and the form is submitted
      await _completeFirstTwoSteps(tester);
      await enterTextAndSettle(tester, _emailField, _validEmail);
      await enterTextAndSettle(tester, _notesField, 'Ready to verify');

      await tester.tap(_submitButtonFinder());
      await tester.pumpAndSettle();

      // THEN: submitted values should contain the provided data
      expect(submittedValues, isNotNull, reason: 'Submit callback should receive form values');
      expect(submittedValues?['firstName'], _validFirstName);
      expect(submittedValues?['age'], anyOf(30, 30.0, '30'));
      expect(submittedValues?['email'], _validEmail);
      expect(submittedValues?['notes'], 'Ready to verify');
    });

    testWidgets('allows going back, editing, and proceeding again', (tester) async {
      // GIVEN: the wizard form is rendered and progressed to the last step
      await _pumpWizard(tester);

      await _fillFirstStepAndContinue(tester);
      await _fillSecondStepAndContinue(tester, age: '21');

      expect(_emailField, findsOneWidget);

      // WHEN: the user navigates back and edits previous input
      await tester.tap(_backButtonFinder());
      await tester.pumpAndSettle();

      await enterTextAndSettle(tester, _ageField, '45');
      await tester.tap(_nextButtonFinder());
      await tester.pumpAndSettle();

      // THEN: the wizard returns to the final step with updated data
      expect(_emailField, findsOneWidget, reason: 'Should return to step three after editing step two');
    });

    testWidgets('step taps allow sequential navigation but prevent skipping ahead', (tester) async {
      // GIVEN: the wizard is on the first step with valid data
      await _pumpWizard(tester);

      await enterTextAndSettle(tester, _firstNameField, _validFirstName);
      // WHEN: the user taps the second step header
      await _tapStep(tester, WizardTestData.stepTitles[1]);

      // THEN: step two becomes active
      expect(_ageField, findsOneWidget, reason: 'Should jump to step two when step one is valid');

      // WHEN: the user attempts to skip directly to step three
      await _tapStep(tester, WizardTestData.stepTitles[2]);
      // THEN: access should be blocked until step two is valid
      expect(_emailField, findsNothing, reason: 'Should not reach step three until step two is valid');

      // WHEN: the second step is completed and step three is tapped again
      await enterTextAndSettle(tester, _ageField, _validAge);
      await _tapStep(tester, WizardTestData.stepTitles[2]);
      // THEN: the final step should now be visible
      expect(_emailField, findsOneWidget);
    });

    testWidgets('previously unlocked steps remain accessible unless current step is invalid', (tester) async {
      // GIVEN: the wizard has progressed through the first two steps
      await _pumpWizard(tester);

      await _completeFirstTwoSteps(tester);
      expect(_emailField, findsOneWidget);

      // WHEN: the user revisits prior steps that remain valid
      await _tapStep(tester, WizardTestData.stepTitles[0]);
      expect(_firstNameField, findsOneWidget);

      await _tapStep(tester, WizardTestData.stepTitles[2]);
      expect(_emailField, findsOneWidget, reason: 'Should reach step three because earlier steps stayed valid');

      // WHEN: a previously valid step is made invalid
      await _tapStep(tester, WizardTestData.stepTitles[0]);
      await enterTextAndSettle(tester, _firstNameField, '');

      await _tapStep(tester, WizardTestData.stepTitles[2]);
      // THEN: navigation forward should be blocked and an error displayed
      expect(_emailField, findsNothing, reason: 'Invalid current step should block forward navigation');
      expect(find.text('This field cannot be empty.'), findsOneWidget);

      // WHEN: the user fixes the invalid step
      await enterTextAndSettle(tester, _firstNameField, _validFirstName);
      await _tapStep(tester, WizardTestData.stepTitles[2]);
      // THEN: navigation forward becomes available again
      expect(_emailField, findsOneWidget);
    });

    testWidgets('disables back on first page and next on last page', (tester) async {
      // GIVEN: the wizard starts on the first page
      await _pumpWizard(tester);

      // THEN: the back button should be disabled initially
      final firstBack = tester.widget<OutlinedButton>(_backButtonFinder());
      expect(firstBack.onPressed, isNull, reason: 'Back should be disabled on the first page');

      // WHEN: the wizard advances to the final page
      await _completeFirstTwoSteps(tester);
      // THEN: the next button should be disabled
      final lastNext = tester.widget<FilledButton>(_nextButtonFinder());
      expect(lastNext.onPressed, isNull, reason: 'Next should be disabled on the last page');
    });
  });
}

Future<void> _pumpWizard(WidgetTester tester, {void Function(Map<String, dynamic>?)? onSubmit}) {
  return pumpForm(
    tester,
    jsonSchema: WizardTestData.jsonSchema,
    uiSchema: WizardTestData.uiSchema,
    onFormSubmitSaveCallback: onSubmit,
  );
}

Future<void> _completeFirstTwoSteps(WidgetTester tester) async {
  await _fillFirstStepAndContinue(tester);
  await _fillSecondStepAndContinue(tester);
}

Future<void> _fillFirstStepAndContinue(WidgetTester tester, {String name = _validFirstName}) async {
  await enterTextAndSettle(tester, _firstNameField, name);
  await tester.tap(_nextButtonFinder());
  await tester.pumpAndSettle();
}

Future<void> _fillSecondStepAndContinue(WidgetTester tester, {String age = _validAge}) async {
  await enterTextAndSettle(tester, _ageField, age);
  await tester.tap(_nextButtonFinder());
  await tester.pumpAndSettle();
}

Future<void> _tapStep(WidgetTester tester, String title) async {
  await tester.tap(find.text(title).first);
  await tester.pumpAndSettle();
}

Finder _field(String property) => find.byKey(ValueKey(scopePath([property])));

Finder get _firstNameField => _field('firstName');
Finder get _ageField => _field('age');
Finder get _emailField => _field('email');
Finder get _notesField => _field('notes');

Finder _nextButtonFinder() => find.widgetWithText(FilledButton, 'Next');
Finder _backButtonFinder() => find.widgetWithText(OutlinedButton, 'Back');
Finder _submitButtonFinder() => find.widgetWithText(FilledButton, 'Submit Wizard');

const _validFirstName = 'Alice';
const _validAge = '30';
const _validEmail = 'alice@example.com';
