
# Priority
- [ ] Array options (addButtonText)
- [ ] FieldUploadOptions (maxfilesize, displayAsSingleUploadfield, acceptedfiletype)


- [ ] Async creation or check why it takes so long until widget is rendered initially

- [ ] don't render * for required but other image
- [ ] check for # and not # paths. I think weather the path starts with # or not, it is internally stored without. So the checks in some functions for # should be removed / if this is not possible, every place where a function want to work with a path which has # has to trim it first
- [ ] check for arrays in arrays and objects, there could still be errors
- [x] array elements cant be moved right now
- [x] strange state management
- [x] support append text
- [ ] showOn error: When field is dependent of a value of another field which is not shown, the other field is still shown. But the filed should not be shown
- [x] Space between fields when they are not shown. There is space rendered which is not needed (workaround, dont use .separate builder, but this should be used, elements which are not shown should just not be rendered)
- [ ] support simple css parsing to allow small adjustments to the design of e.g. Groups
- [ ] Support Rendering of form submit, print etc. buttons (and provide a toggle option to render them)


# Theming
- [ ] most theming is supported natively by flutter by providing a Theme Data Object. But some things have to be handled by the library
  - [ ] support for alternative card colors (see getAlternatingColors)
  - [ ] allow the user to specify if the text should be shown within a textbox, or above it
  - [ ] advanced: currently, only css is supported by the ui schema, but for flutter, this has to be adjusted to allow styling of individual fields with a kind of themeData object. This new ui schema should be fully compatible with the existing one but allow additional styling options
  - [ ] All constant values of the form renderer defined in constants.dart (but most likely even more as there are missing some) should be able to defined from the outside. Maybe a simple wrapper with a theme object works so no additional work has to be done, but it should be documented or at least some good default values should be used

# Configuration
- [ ] allow to provide an onError widget to be shown when an error occurs (instead of the default error which shows which fields are invalid in the json)
- [ ] when loading things are done by the flutter app which use the library, it would be nice if the form would already show its loading widget. This should be configurable by some way. There should also be a way to configure the loading widget
- 


# TODOS 2.0:
- default values empty array: `[]` throws error (general: handle default array values)
- everywhere where _evaluateCondition is called, rita has to be called as well. Check this and maybe create shared function
- Object generation in FormElements and FormElements Creation DynamicFormBuilder is similar in many parts. Most likely the whole thing cant be at the same place but maybe use same/similar functions (e.g. for the is visible part where parent check has the be done, on create and so on)
- values in dependent fields which are not shown should be ignored. This leads to a chain of dependencies which have to be analyzed for it to work
- Layouts: Currently the padding is set for every children a list (Row, Column) before and after it. This leads to the first and last children having padding before and after it which should not be there. Ideally a Sized Box is inserted between the children but this has to be calculated at parent list level so it can be determined if an element is shown or not. If it is not shown then no sized box has to be inserted between it. Another way would be to pass to eahc children if it is the last or first or not (like a enum first, middle, last) and then set the padding accordingly but this has the problem that if the last child is not visible, the one before the last one becomes the new last child and the child is not aware of this. So the only really working method is to calculate at row/column level which child is shown and which is not and then put sized boxes between them accordingly.
- State what is currently supported or better: what is not supported out of the json draft schema (e.g Conditional validation with dependentRequired,Conditional validation with dependentSchemas, Conditional validation with if-else) is currently not supported
- store values correctly (string and int notably), the textfield is critical here since it uses string internally
- Allow configuration for example for the array: should delete being shown or use swipe to delete, should reorder be shown or an explicit view for reordering or no reordering,provide custom icons for reorder and delete, or for the whole button or for the whole reordering itself
- Bug on arrays: when adding a new array entry, old entries wont update their state if it is not the default one
