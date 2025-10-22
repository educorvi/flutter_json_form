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

      testWidgets('Follows a11y guidelines', (tester) async {
        await checkAccessibilityGuidelines(
          tester,
          (tester) => pumpForm(tester, jsonSchema: BaseData.jsonSchema),
        );
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

      testWidgets('Follows a11y guidelines', (tester) async {
        /// GIVEN
        final SemanticsHandle handle = tester.ensureSemantics();
        await init(tester);

        // Checks that tappable nodes have a minimum size of 48 by 48 pixels
        // for Android.
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));

        // Checks that tappable nodes have a minimum size of 44 by 44 pixels
        // for iOS.
        await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));

        // Checks that touch targets with a tap or long press action are labeled.
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

        // Checks whether semantic nodes meet the minimum text contrast levels.
        // The recommended text contrast is 3:1 for larger text
        // (18 point and above regular).
        // await expectLater(tester, meetsGuideline(textContrastGuideline));
        handle.dispose();
      });
    });

    testWidgets('Follows a11y guidelines', (tester) async {
      await checkAccessibilityGuidelines(
        tester,
        (tester) => pumpForm(
          tester,
          jsonSchema: BaseData.jsonSchema,
          uiSchema: BaseData.uiSchema,
        ),
      );
    });

    // TODO add testing for dynamic data as well and check commented out contrast. Also create reusable function. Maybe it isn`t good to just use these ui and json schemas for accessabilty as they were created for another puprose. Dont knpow yet if they are sufficient Or: use these test and also add dedicated accessibilty tests
  });
}
