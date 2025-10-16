import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'data/base_data.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Base Form Test', () {
    group('Json Schema Test', () {
      // setUpAll(() async {
      //   await pumpForm(tester, BaseData.jsonSchema);
      // });

      // bool _isPumped = false;

      // Future<void> ensurePumped(WidgetTester tester) async {
      //   if (!_isPumped) {
      //     await pumpForm(tester, jsonSchema: BaseData.jsonSchema);
      //     _isPumped = true;
      //   }
      // }

      Future<void> init(WidgetTester tester) async {
        await pumpForm(tester, jsonSchema: BaseData.jsonSchema);
      }

      testWidgets('Form loads successfully', (tester) async {
        /// GIVEN
        await init(tester);

        /// THEN
        expect(find.formFieldText('Registration'), findsOneWidget);
        expect(find.formFieldText('A simple registration form example'), findsOneWidget);
      });

      testWidgets('Basic form fields load successfully', (tester) async {
        /// GIVEN
        await init(tester);

        /// THEN
        // field titles get generated from schema titles and property names
        expect(find.formFieldText('Name'), findsOneWidget);
        expect(find.formFieldText('Newsletter Json Title'), findsOneWidget);
        expect(find.formFieldText('email'), findsOneWidget);
        expect(find.formFieldText('timeMissingInUiSchema'), findsOneWidget);
        // input fields get generated from schema types
        expect(find.byType(FormBuilderTextField), findsNWidgets(2));
        expect(find.byType(FormBuilderSwitch), findsOneWidget);
        expect(find.byType(FormBuilderDateTimePicker), findsOneWidget);
      });

      testWidgets('Default values are set correctly', (tester) async {
        /// GIVEN
        await init(tester);

        /// THEN
        final switchFinder = find.byType(FormBuilderSwitch);
        expect(switchFinder, findsOneWidget);
        final switchWidget = tester.widget<FormBuilderSwitch>(switchFinder);
        expect(switchWidget.initialValue, isTrue);
      });

      testWidgets('Required fields are marked correctly', (tester) async {
        /// GIVEN
        await init(tester);

        /// THEN
        expect(isTextFieldRequired(tester, 'Name'), isTrue); // required
        expect(isTextFieldRequired(tester, 'Newsletter Json Title'), isFalse); // not required
        expect(isTextFieldRequired(tester, 'email'), isTrue); // required
        expect(isTextFieldRequired(tester, 'timeMissingInUiSchema'), isFalse); // not required
      });
    });

    group('Ui Schema Test', () {
      Future<void> init(WidgetTester tester) async {
        await pumpForm(tester, jsonSchema: BaseData.jsonSchema, uiSchema: BaseData.uiSchema);
      }

      testWidgets('Form loads successfully', (tester) async {
        /// GIVEN
        await init(tester);

        /// THEN
        expect(find.formFieldText('Registration'), findsOneWidget);
        expect(find.formFieldText('A simple registration form example'), findsOneWidget);
      });

      testWidgets('Basic form fields load successfully', (tester) async {
        /// GIVEN
        await init(tester);

        /// THEN
        // filed titles get generated from schema titles and property names
        expect(find.formFieldText('Name'), findsOneWidget);
        expect(find.formFieldText('Sign up for newsletter'), findsOneWidget);
        expect(find.formFieldText('email'), findsOneWidget);
        expect(find.formFieldText('elementMissingInUiSchema'), findsNothing); // element missing in ui schema is not shown
        // input fields get generated from schema types
        expect(find.byType(FormBuilderTextField), findsNWidgets(2));
        expect(find.byType(FormBuilderSwitch), findsOneWidget);
        expect(find.byType(FormBuilderDateTimePicker), findsNothing);
      });

      testWidgets('Default values are set correctly', (tester) async {
        /// GIVEN
        await init(tester);

        /// THEN
        final switchFinder = find.byType(FormBuilderSwitch);
        expect(switchFinder, findsOneWidget);
        final switchWidget = tester.widget<FormBuilderSwitch>(switchFinder);
        expect(switchWidget.initialValue, isTrue);
      });

      testWidgets('Required fields are marked correctly', (tester) async {
        /// GIVEN
        await pumpForm(tester, jsonSchema: BaseData.jsonSchema, uiSchema: BaseData.uiSchema);

        /// THEN
        expect(isTextFieldRequired(tester, 'Name'), isTrue); // required
        expect(isTextFieldRequired(tester, 'Sign up for newsletter'), isFalse); // not required
        expect(isTextFieldRequired(tester, 'email'), isTrue); // required
      });

      testWidgets("Simple ShowOn Rule is working", (tester) async {
        /// GIVEN
        await init(tester);

        /// THEN
        expect(isWidgetCrossFadeVisible(tester, find.formFieldText('email')), isTrue); // shown

        /// WHEN
        final switchFinder = find.byType(FormBuilderSwitch);
        expect(switchFinder, findsOneWidget);
        await tester.tap(switchFinder);
        await tester.pumpAndSettle();

        /// THEN
        expect(isWidgetCrossFadeVisible(tester, find.formFieldText('email')), isFalse); // email is now hidden
      });
    });
  });
}
