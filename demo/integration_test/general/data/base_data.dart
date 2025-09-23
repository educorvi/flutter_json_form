class BaseData {
  static final jsonSchema = {
    "name": "registration",
    "title": "Registration",
    "type": "object",
    "description": "A simple registration form example",
    "\$schema": "http://json-schema.org/draft-07/schema#",
    "properties": {
      "name": {"type": "string", "title": "Name"},
      "newsletter": {"type": "boolean", "default": true, "title": "Newsletter Json Title"},
      "email": {"type": "string", "format": "email"},
      "timeMissingInUiSchema": {"type": "string", "format": "date-time"}
    },
    "required": ["name", "email"]
  };

  static final uiSchema = {
    "version": "2.0",
    "\$schema": "https://educorvi.github.io/vue-json-form/schemas/ui.schema.json",
    "layout": {
      "type": "Group",
      "options": {"label": "Registration Form"},
      "elements": [
        {
          "type": "Control",
          "scope": "#/properties/name",
          "options": {"placeholder": "Full Name"}
        },
        {
          "type": "Control",
          "scope": "#/properties/newsletter",
          "options": {"label": "Sign up for newsletter"}
        },
        {
          "type": "Control",
          "scope": "#/properties/email",
          "showOn": {"path": "#/properties/newsletter", "type": "EQUALS", "referenceValue": true},
        },
        {
          "type": "Button",
          "buttonType": "submit",
          "text": "Sign Up",
          "options": {
            "variant": "primary",
            "submitOptions": {"action": "save"}
          }
        }
      ]
    }
  };
}
