import 'package:flutter_test/flutter_test.dart';
import 'base_data.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../utils/test_utils.dart';

void main() {
  ensureWidgetTestBinding();

  group('Base Form Test', () {
    group('Json Schema Test', () {
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
        expect(find.formFieldText('Newsletter'), findsOneWidget);
        expect(find.formFieldText('Email'), findsOneWidget);
        expect(find.formFieldText('TimeMissingInUiSchema'), findsOneWidget);
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
        expect(isTextFieldRequired(tester, 'Email'), isTrue); // required
        expect(isTextFieldRequired(tester, 'TimeMissingInUiSchema'), isFalse); // not required
      });

      testWidgets('Follows a11y guidelines', (tester) async {
        await checkAccessibilityGuidelines(
          tester,
          (tester) => init(tester),
        );
      });
    });

    group('Ui Schema Test', () {
      Future<void> init(WidgetTester tester) async {
        await pumpForm(tester, jsonSchema: BaseData.jsonSchema, uiSchema: BaseData.uiSchema);
      }

      testWidgets('Form header loads successfully', (tester) async {
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
        expect(find.formFieldText('Newsletter'), findsOneWidget);
        expect(find.formFieldText('Email'), findsOneWidget);
        expect(find.formFieldText('ElementMissingInUiSchema'), findsNothing); // element missing in ui schema is not shown
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
        await init(tester);

        /// THEN
        expect(isTextFieldRequired(tester, 'Name'), isTrue); // required
        expect(isTextFieldRequired(tester, 'Newsletter'), isFalse); // not required
        expect(isTextFieldRequired(tester, 'Email'), isTrue); // required
      });

      testWidgets("Simple ShowOn Rule is working", (tester) async {
        /// GIVEN
        await init(tester);

        /// THEN
        expectShowOnVisible(tester, find.formFieldText('Email')); // shown

        /// WHEN
        final switchFinder = find.byType(FormBuilderSwitch);
        expect(switchFinder, findsOneWidget);
        await tester.tap(switchFinder);
        await tester.pumpAndSettle();

        /// THEN
        expectShowOnHidden(tester, find.formFieldText('Email')); // email is now hidden
      });

      testWidgets('Follows a11y guidelines', (tester) async {
        /// GIVEN
        final SemanticsHandle handle = tester.ensureSemantics();
        await init(tester);

        // THEN
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

      testWidgets('Follows a11y guidelines', (tester) async {
        await checkAccessibilityGuidelines(tester, (tester) => init(tester));
      });
    });
    // TODO add testing for dynamic data as well and check commented out contrast. Also create reusable function. Maybe it isn`t good to just use these ui and json schemas for accessabilty as they were created for another puprose. Dont knpow yet if they are sufficient Or: use these test and also add dedicated accessibilty tests
  });
}
