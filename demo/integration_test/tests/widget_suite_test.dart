import 'package:integration_test/integration_test.dart';

import '../../../test/widget/basic/base_form_test.dart' as basic_base_form;
import '../../../test/widget/json_schema/array/array_test.dart' as json_schema_array;
import '../../../test/widget/json_schema/elements_test.dart' as json_schema_elements;
import '../../../test/widget/json_schema/object/object_test.dart' as json_schema_object;
import '../../../test/widget/ui_schema/elements/control/elements_test.dart' as ui_schema_control_elements;
import '../../../test/widget/ui_schema/elements/control/object/object_test.dart' as ui_schema_control_object;
import '../../../test/widget/ui_schema/elements/elements_test.dart' as ui_schema_elements;
import '../../../test/widget/ui_schema/layout/layout_test.dart' as ui_schema_layout;
import '../../../test/widget/ui_schema/layout/wizard_test.dart' as ui_schema_wizard;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  basic_base_form.main();
  json_schema_array.main();
  json_schema_elements.main();
  json_schema_object.main();
  ui_schema_control_elements.main();
  ui_schema_control_object.main();
  ui_schema_elements.main();
  ui_schema_layout.main();
  ui_schema_wizard.main();
}
