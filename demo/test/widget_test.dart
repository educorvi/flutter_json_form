import 'package:flutter/material.dart';
import 'package:flutter_json_forms_demo/widgets/form_file/form_file_base.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_json_forms_demo/main.dart';

void main() {
  group('Flutter Json Forms Demo App', () {
    testWidgets('Showcase is present in the form selector dropdown', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      // Find the dropdown menu
      final dropdownFinder = find.byType(DropdownMenu<FormFile>);
      expect(dropdownFinder, findsOneWidget);

      // Tap to open the dropdown
      await tester.tap(dropdownFinder);
      await tester.pump();

      // Now check that "Showcase" is present as an option in the dropdown
      final showcaseOptionFinder = find.text('Showcase').last;
      expect(showcaseOptionFinder, findsOneWidget);
    });

    testWidgets('Form selector dropdown works and can select another form', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      // Find the form selector dropdown
      final dropdownFinder = find.byType(DropdownMenu<FormFile>);
      expect(dropdownFinder, findsOneWidget);

      // Tap to open the dropdown
      await tester.tap(dropdownFinder);
      await tester.pump();

      // Select another form (e.g., 'Reproduce')
      expect(find.text('Reproduce'), findsWidgets);
      await tester.tap(find.text('Reproduce').last);
      await tester.pump();
      // The form should now show 'Reproduce'
      expect(find.text('Reproduce'), findsWidgets);
    });

    testWidgets('Custom file upload buttons for JSON and UI schema are present', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      // Check for custom file upload buttons
      expect(find.text('JSON Schema'), findsOneWidget);
      expect(find.text('UI Schema'), findsOneWidget);
    });

    // testWidgets('Custom file upload buttons can be tapped', (WidgetTester tester) async {
    //   await tester.pumpWidget(const MyApp());
    //   // Simulate tap on JSON Schema upload button
    //   await tester.tap(find.text('JSON Schema'));
    //   await tester.pump();
    //   // Simulate tap on UI Schema upload button
    //   await tester.tap(find.text('UI Schema'));
    //   await tester.pump();
    //   // No crash expected
    // });
  });
}

// class MockFilePicker extends Mock with MockPlatformInterfaceMixin implements FilePicker {
//   @override
//   Future<bool?> clearTemporaryFiles() {
//     // TODO: implement clearTemporaryFiles
//     throw UnimplementedError();
//   }

//   @override
//   Future<String?> getDirectoryPath({String? dialogTitle, bool lockParentWindow = false, String? initialDirectory}) {
//     // TODO: implement getDirectoryPath
//     throw UnimplementedError();
//   }

//   @override
//   Future<List<String>?> pickFileAndDirectoryPaths({String? initialDirectory, FileType type = FileType.any, List<String>? allowedExtensions}) {
//     // TODO: implement pickFileAndDirectoryPaths
//     throw UnimplementedError();
//   }

//   @override
//   Future<FilePickerResult?> pickFiles({String? dialogTitle, String? initialDirectory, FileType type = FileType.any, List<String>? allowedExtensions, Function(FilePickerStatus p1)? onFileLoading, bool allowCompression = false, int compressionQuality = 0, bool allowMultiple = false, bool withData = false, bool withReadStream = false, bool lockParentWindow = false, bool readSequential = false}) {
//     // TODO: implement pickFiles
//     throw UnimplementedError();
//   }

//   @override
//   Future<String?> saveFile({String? dialogTitle, String? fileName, String? initialDirectory, FileType type = FileType.any, List<String>? allowedExtensions, Uint8List? bytes, bool lockParentWindow = false}) {
//     // TODO: implement saveFile
//     throw UnimplementedError();
//   }
// }

// void main() {
//   late MockFilePicker mockFilePicker;

//   setUp(() {
//     mockFilePicker = MockFilePicker();
//     FilePicker.platform = mockFilePicker;
//   });

//   testWidgets('...', (WidgetTester tester) async {
//     when(() => mockFilePicker.pickFiles(type: FileType.image))
//       .thenAnswer((_) async => null); // or your desired FilePickerResult

//     // ...test code...
//   });
// }
