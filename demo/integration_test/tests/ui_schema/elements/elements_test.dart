import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;

import '../../../utils/test_utils.dart';
import 'elements_data.dart';

void main() {
	IntegrationTestWidgetsFlutterBinding.ensureInitialized();

	group('UI Schema Element Tests', () {
		testWidgets('HTML renderer renders markup and respects showOn rules', (tester) async {
			// GIVEN: an HTML renderer that is gated by a boolean toggle
			await pumpForm(
				tester,
				jsonSchema: UiSchemaElementsData.jsonSchema,
				uiSchema: UiSchemaElementsData.htmlRendererUiSchema,
			);

			final htmlFinder = find.text('Welcome to the layout elements demo');

			// THEN: the HTML renderer starts hidden
			expect(htmlFinder, findsNothing);

			// WHEN: the toggle is enabled
			await _toggleBoolean(tester, 'showHtml');

			// THEN: the HTML headline becomes visible
			expect(htmlFinder, findsOneWidget);
		});

		testWidgets('Divider element can be toggled via showOn', (tester) async {
			// GIVEN: a divider that depends on a toggle
			await pumpForm(
				tester,
				jsonSchema: UiSchemaElementsData.jsonSchema,
				uiSchema: UiSchemaElementsData.dividerUiSchema,
			);

			final dividerFinder = find.byType(Divider);

			// THEN: divider is initially hidden
			expectShowOnHidden(tester, dividerFinder);

			// WHEN: the toggle is enabled
			await _toggleBoolean(tester, 'showDivider');

			// THEN: the divider appears
			expectShowOnVisible(tester, dividerFinder);
		});

		testWidgets('Button group defaults to horizontal layout and honors showOn', (tester) async {
			// GIVEN: a horizontal button group guarded by showOn
			await pumpForm(
				tester,
				jsonSchema: UiSchemaElementsData.jsonSchema,
				uiSchema: UiSchemaElementsData.buttonGroupHorizontalUiSchema,
			);

			final primary = find.text('Primary Action');
			final secondary = find.text('Secondary Action');

			// THEN: buttons start hidden
			expect(primary, findsNothing);

			// WHEN: the toggle is enabled
			await _toggleBoolean(tester, 'showButtonGroup');

			// THEN: both buttons show and stay on the same horizontal line
			expect(primary, findsOneWidget);
			expectWidgetToBeInHorizontalLayout(tester, [primary, secondary]);
		});

		testWidgets('Button group renders vertically when requested', (tester) async {
			// GIVEN: a vertical button group configuration
			await pumpForm(
				tester,
				jsonSchema: UiSchemaElementsData.jsonSchema,
				uiSchema: UiSchemaElementsData.buttonGroupVerticalUiSchema,
			);

			final primary = find.text('Primary Action');
			final secondary = find.text('Secondary Action');

			// WHEN: the toggle is enabled
			await _toggleBoolean(tester, 'showButtonGroup');

			// THEN: buttons render in a column
			expect(primary, findsOneWidget);
			expectWidgetsInVerticalOrder(tester, [primary, secondary]);
		});

		testWidgets('Button renders even without text and respects showOn', (tester) async {
			// GIVEN: a button without text
			await pumpForm(
				tester,
				jsonSchema: UiSchemaElementsData.jsonSchema,
				uiSchema: UiSchemaElementsData.buttonUiSchema(buttonType: ui.TheButtonsType.SUBMIT),
			);

			final emptyTextFinder = find.text('');

			// THEN: button text starts hidden
			expect(emptyTextFinder, findsNothing);

			// WHEN: the toggle is enabled
			await _toggleBoolean(tester, 'showButton');

			// THEN: the button becomes visible
			expect(emptyTextFinder, findsOneWidget);
			expect(find.byType(FilledButton), findsOneWidget);
		});

		testWidgets('Button displays provided text when shown', (tester) async {
			// GIVEN: a button with a label
			const buttonText = 'Submit Now';
			await pumpForm(
				tester,
				jsonSchema: UiSchemaElementsData.jsonSchema,
				uiSchema: UiSchemaElementsData.buttonUiSchema(
					buttonType: ui.TheButtonsType.SUBMIT,
					text: buttonText,
				),
			);

			// WHEN: the toggle is enabled
			await _toggleBoolean(tester, 'showButton');

			// THEN: the label is rendered on the button
			expect(find.widgetWithText(FilledButton, buttonText), findsOneWidget);
		});

		testWidgets('Outline variant buttons render as OutlinedButton', (tester) async {
			// GIVEN: a button with outline-secondary variant
			const buttonText = 'Secondary Outline';
			await pumpForm(
				tester,
				jsonSchema: UiSchemaElementsData.jsonSchema,
				uiSchema: UiSchemaElementsData.buttonUiSchema(
					buttonType: ui.TheButtonsType.SUBMIT,
					text: buttonText,
					options: ui.ButtonOptions(variant: ui.ColorVariants.OUTLINE_SECONDARY),
				),
			);

			// WHEN: the toggle is enabled
			await _toggleBoolean(tester, 'showButton');

			// THEN: the button uses the outlined style
			expect(find.byType(OutlinedButton), findsOneWidget);
			expect(find.widgetWithText(OutlinedButton, buttonText), findsOneWidget);
		});

		testWidgets('Submit button enforces validation before invoking save callback', (tester) async {
			// GIVEN: a submit button that saves form data
			Map<String, dynamic>? submittedValues;
			const buttonText = 'Save Profile';
			await pumpForm(
				tester,
				jsonSchema: UiSchemaElementsData.jsonSchema,
				uiSchema: UiSchemaElementsData.buttonUiSchema(
					buttonType: ui.TheButtonsType.SUBMIT,
					text: buttonText,
					options: ui.ButtonOptions(
						submitOptions: ui.SubmitOptions(action: 'save'),
					),
				),
				onFormSubmitSaveCallback: (values) => submittedValues = values,
			);

			await _toggleBoolean(tester, 'showButton');
			final buttonFinder = find.widgetWithText(FilledButton, buttonText);

			// WHEN: submitting without filling required data
			await tester.tap(buttonFinder);
			await tester.pumpAndSettle();

			// THEN: callback is not invoked
			expect(submittedValues, isNull);

			// WHEN: required field is filled and button is tapped again
			await enterTextAndSettle(tester, _field('firstName'), 'Alice');
			await tester.tap(buttonFinder);
			await tester.pumpAndSettle();

			// THEN: submitted data includes the provided value
			expect(submittedValues?['firstName'], 'Alice');
		});

		testWidgets('formNoValidate option bypasses validation when true', (tester) async {
			// GIVEN: a submit button configured with formnovalidate
			bool callbackInvoked = false;
			const buttonText = 'Save Without Validation';
			await pumpForm(
				tester,
				jsonSchema: UiSchemaElementsData.jsonSchema,
				uiSchema: UiSchemaElementsData.buttonUiSchema(
					buttonType: ui.TheButtonsType.SUBMIT,
					text: buttonText,
					options: ui.ButtonOptions(
						formnovalidate: true,
						submitOptions: ui.SubmitOptions(action: 'save'),
					),
				),
				onFormSubmitSaveCallback: (_) => callbackInvoked = true,
			);

			await _toggleBoolean(tester, 'showButton');

			// WHEN: the button is tapped without providing the required field
			await tester.tap(find.widgetWithText(FilledButton, buttonText));
			await tester.pumpAndSettle();

			// THEN: the callback still runs because validation was skipped
			expect(callbackInvoked, isTrue);
		});

		testWidgets('Request submit option forwards configuration to callback', (tester) async {
			// GIVEN: a submit button configured to trigger a request action
			Map<String, dynamic>? submittedValues;
			ui.Request? capturedRequest;
			const buttonText = 'Send Request';
			final options = ui.ButtonOptions(
				submitOptions: ui.SubmitOptions(
					action: 'request',
					request: ui.Request(
						url: 'https://example.com/api/forms',
						method: ui.Method.PUT,
						headers: const {'Authorization': 'Bearer token'},
						onSuccessRedirect: '/thanks',
					),
				),
			);

			await pumpForm(
				tester,
				jsonSchema: UiSchemaElementsData.jsonSchema,
				uiSchema: UiSchemaElementsData.buttonUiSchema(
					buttonType: ui.TheButtonsType.SUBMIT,
					text: buttonText,
					options: options,
				),
				onFormRequestCallback: (values, request) {
					submittedValues = values;
					capturedRequest = request;
				},
			);

			await _toggleBoolean(tester, 'showButton');
			await enterTextAndSettle(tester, _field('firstName'), 'Request User');

			// WHEN: the request button is tapped
			await tester.tap(find.widgetWithText(FilledButton, buttonText));
			await tester.pumpAndSettle();

			// THEN: both the form values and request configuration are forwarded
			expect(submittedValues?['firstName'], 'Request User');
			expect(capturedRequest, isNotNull);
			expect(capturedRequest?.url, 'https://example.com/api/forms');
			expect(capturedRequest?.method, ui.Method.PUT);
			expect(capturedRequest?.headers?['Authorization'], 'Bearer token');
			expect(capturedRequest?.onSuccessRedirect, '/thanks');
		});

		testWidgets('Reset button clears edited form fields', (tester) async {
			// GIVEN: a reset button configuration
			const buttonText = 'Reset Form';
			await pumpForm(
				tester,
				jsonSchema: UiSchemaElementsData.jsonSchema,
				uiSchema: UiSchemaElementsData.buttonUiSchema(
					buttonType: ui.TheButtonsType.RESET,
					text: buttonText,
				),
			);

			await _toggleBoolean(tester, 'showButton');
			await enterTextAndSettle(tester, _field('firstName'), 'Bob');
			expect(find.text('Bob'), findsOneWidget);

			// WHEN: the reset button is tapped
			await tester.tap(find.widgetWithText(FilledButton, buttonText));
			await tester.pumpAndSettle();

			// THEN: the field value is cleared
			expect(find.text('Bob'), findsNothing);
		});

		testWidgets('Wizard navigation buttons move between steps and submit data', (tester) async {
			// GIVEN: a simple wizard with navigation buttons gated by showOn
			Map<String, dynamic>? submittedValues;
			await pumpForm(
				tester,
				jsonSchema: UiSchemaElementsData.jsonSchema,
				uiSchema: UiSchemaElementsData.wizardNavigationUiSchema,
				onFormSubmitSaveCallback: (values) => submittedValues = values,
			);

			final nextButtonText = find.text('Go Next');

			// THEN: navigation buttons are initially hidden
			expect(nextButtonText, findsNothing);

			// WHEN: enabling the toggle reveals the buttons
			await _toggleBoolean(tester, 'showButton');
			expect(nextButtonText, findsOneWidget);

			// WHEN: the user completes the first step and taps next
			await enterTextAndSettle(tester, _field('firstName'), 'Wizard User');
			await tester.tap(find.widgetWithText(FilledButton, 'Go Next'));
			await tester.pumpAndSettle();

			// THEN: the second step is shown
			expect(_field('lastName'), findsOneWidget);

			// WHEN: the user navigates back and forth again
			await tester.tap(find.widgetWithText(FilledButton, 'Go Back'));
			await tester.pumpAndSettle();
			expect(_field('firstName'), findsOneWidget);

			await tester.tap(find.widgetWithText(FilledButton, 'Go Next'));
			await tester.pumpAndSettle();

			// WHEN: submitting the wizard on the second step
			await tester.tap(find.widgetWithText(FilledButton, 'Finish Wizard'));
			await tester.pumpAndSettle();

			// THEN: the submit callback receives the data entered on step one
			expect(submittedValues?['firstName'], 'Wizard User');
		});
	});
}

Future<void> _toggleBoolean(WidgetTester tester, String property) async {
	await tester.tap(_field(property));
	await tester.pumpAndSettle();
}

Finder _field(String property) => find.byKey(ValueKey(scopePath([property])));

