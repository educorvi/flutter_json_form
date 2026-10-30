library;

export 'src/form_builder.dart' show FlutterJsonForm, FlutterJsonFormState;

export 'src/json_validator.dart' show setupDynamicJsonFormValidation;

// export 'src/process_form_values.dart' show processFormValuesEllaV1, processFormValuesEllaV2;

// TODO maybe export function for creating a default uiSchema for a json Schema

export 'package:form_builder_validators/form_builder_validators.dart' show FormBuilderLocalizations;

// Rendering abstraction layer
export 'src/rendering/render_context.dart' show RenderContext;
export 'src/rendering/helpers/render_helpers.dart' show RenderHelpers, mapEnumValuesToTitles;
export 'src/rendering/json_form_renderer.dart' show JsonFormRenderer;
export 'src/rendering/ui_element_contexts.dart'
    show UiLayoutContext, UiButtonContext, UiButtonGroupContext, UiDividerContext, UiHtmlContext, UiWizardContext;
export 'src/rendering/data_element_contexts.dart' show ArrayAddButtonContext, ArrayReorderButtonContext, ArrayDeleteButtonContext, ArrayItemContext;
export 'src/rendering/renderer_scope.dart' show RendererScope;

// Default renderer implementation using material widgets
// customizable with different configs for the elements
export 'src/rendering/default_renderer/default_json_form_renderer.dart'
    show
        DefaultJsonFormRenderer,
        TextFieldConfig,
        ColorPickerConfig,
        VerticalLayoutConfig,
        HorizontalLayoutConfig,
        GroupLayoutConfig,
        ButtonGroupConfig,
        WizardConfig;

// Reusable logic helpers for custom renderer implementations
export 'src/rendering/helpers/array_helpers.dart' show ArrayHelpers;
export 'src/rendering/helpers/object_helpers.dart' show ObjectHelpers;
