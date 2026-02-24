import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:json_schema/json_schema.dart';

import '../../../utils/test_utils.dart';

class UiSchemaElementsData {
	static const _htmlHeadline = 'Welcome to the layout elements demo';

	static final jsonSchema = JsonSchema.create({
		'type': 'object',
		'properties': {
			'showHtml': {'type': 'boolean', 'title': 'Show HTML Renderer'},
			'showDivider': {'type': 'boolean', 'title': 'Show Divider'},
			'showButtonGroup': {'type': 'boolean', 'title': 'Show Button Group'},
			'showButton': {'type': 'boolean', 'title': 'Show Button'},
			'firstName': {'type': 'string', 'title': 'First Name'},
			'lastName': {'type': 'string', 'title': 'Last Name'},
		},
		'required': ['firstName'],
	});

	static ui.UiSchema htmlRendererUiSchema = getBaseUiSchemaLayout(
		elements: [
			ui.Control(scope: scopePath(['showHtml'])),
			ui.HtmlRenderer(
				htmlData: '<h2>$_htmlHeadline</h2>',
				showOn: _showOn('showHtml'),
			),
		],
	);

	static ui.UiSchema dividerUiSchema = getBaseUiSchemaLayout(
		elements: [
			ui.Control(scope: scopePath(['showDivider'])),
			ui.Divider(showOn: _showOn('showDivider')),
		],
	);

	static ui.UiSchema buttonGroupHorizontalUiSchema = getBaseUiSchemaLayout(
		elements: [
			ui.Control(scope: scopePath(['showButtonGroup'])),
			ui.Buttongroup(
				buttons: _groupButtons(),
				showOn: _showOn('showButtonGroup'),
			),
		],
	);

	static ui.UiSchema buttonGroupVerticalUiSchema = getBaseUiSchemaLayout(
		elements: [
			ui.Control(scope: scopePath(['showButtonGroup'])),
			ui.Buttongroup(
				buttons: _groupButtons(),
				showOn: _showOn('showButtonGroup'),
				options: ui.ButtongroupOptions(vertical: true),
			),
		],
	);

	static ui.UiSchema buttonUiSchema({
		required ui.TheButtonsType buttonType,
		String text = '',
		ui.ButtonOptions? options,
	}) {
		return getBaseUiSchemaLayout(
			elements: [
				ui.Control(scope: scopePath(['firstName'])),
				ui.Control(scope: scopePath(['showButton'])),
				ui.Button(
					buttonType: buttonType,
					text: text,
					options: options,
					showOn: _showOn('showButton'),
				),
			],
		);
	}

	static ui.UiSchema wizardNavigationUiSchema = ui.UiSchema(
		version: '2.0',
		layout: ui.Wizard(
			type: ui.WizardType.WIZARD,
			options: ui.WizardOptions(pageTitles: const ['Step One', 'Step Two']),
			pages: [
				ui.Layout(
					type: ui.LayoutType.VERTICAL_LAYOUT,
					elements: [
						ui.Control(scope: scopePath(['showButton'])),
						ui.Control(scope: scopePath(['firstName'])),
						ui.Button(
							buttonType: ui.TheButtonsType.NEXT_WIZARD_PAGE,
							text: 'Go Next',
							showOn: _showOn('showButton'),
						),
					],
				),
				ui.Layout(
					type: ui.LayoutType.VERTICAL_LAYOUT,
					elements: [
						ui.Control(scope: scopePath(['lastName'])),
						ui.Button(
							buttonType: ui.TheButtonsType.PREVIOUS_WIZARD_PAGE,
							text: 'Go Back',
							showOn: _showOn('showButton'),
						),
						ui.Button(
							buttonType: ui.TheButtonsType.SUBMIT,
							text: 'Finish Wizard',
							showOn: _showOn('showButton'),
							options: ui.ButtonOptions(
								submitOptions: ui.SubmitOptions(action: 'save'),
							),
						),
					],
				),
			],
		),
	);

	static List<ui.Button> _groupButtons() {
		return [
			ui.Button(buttonType: ui.TheButtonsType.SUBMIT, text: 'Primary Action'),
			ui.Button(buttonType: ui.TheButtonsType.RESET, text: 'Secondary Action'),
		];
	}

	static ui.ShowOnProperty _showOn(String property) {
		return ui.ShowOnProperty(
			path: scopePath([property]),
			type: ui.ShowOnFunctionType.EQUALS,
			referenceValue: true,
		);
	}
}

