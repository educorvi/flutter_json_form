# Roadmap release v1.0.0

A Roadmap on how the development of the app will proceed. This document is used to keep track of the development process and to provide a list of features that are planned to be implemented.

## 1. Bugfixes

Currently there are some smaller bugs which have to be addressed.
- [ ] the json form library being used is throwing errors for some elements
- [x] the form renderers state can't be reset properly
- [x] Reordering elements breaks dependencies. Could be that rita dependencies have to be evaluated again here after reordering so that the correct elements are shown/hidden
- [ ] showOn dependencies depending on other showOn dependencies have minor issues
- [x] ritaDependencies are not working correctly for arrays within arrays resulting in the ui elements only updating when the user explicitly taps on the element
- [x] Render Form async and provide loading spinner: Currently for huge forms, the whole UI lags as heavy lifting is done synchronically so the main ui isolate hangs which is very bad practice. When this is adjusted, also provide the possibility for the user to provide an own loading widget.
- [ ] Initial value in arrays not working as initialValue is still buggy, currently an extra method is used because initialValue is set with latest values. Investigate this

- Effort: 2.5 `Personenarbeitstage`

## 2. Automated Tests

Currently manual test are done to check if the form renderer does what it should. Before the first release at least a skeleton for testing should be created so in the future tests can be added easily

- Effort: 1.5 `Personenarbeitstag`

## 3. Check if all options of the UI Schema are supported in the renderer

Most features of the UI schema work, but there was no systematical approach to implement them all. A ui Schema which includes all options should be created and the flutter implementation should be compared with the reference VueJs implementation

- Effort: 2.5 `Personenarbeitstage`

## 3.5 Logging
- add logging 

## 4. Polish demo application

- improve demo application by creating a nice example json and ui schema and also creating a theme as an exmaple

- Effort: 0.5 `Personenarbeitstage`

## 5. Check accessibility features are mostly working (`Barrierefreiheit`)

- don't use * for required but an image with a label
- check labels are available for buttons and other elements for screen reader to function

- Effort: 0.5 `Personenarbeitstage`


## 6. Publishing the Package, cleaning up the code, making GitHub repo public and improving documentation

The final step for the project is to create more documentation on how to use the library, make it publicly available on Github and publishing the package to pub.dev

- Effort: 1 `Personenarbeitstag`


Total: ~ 10 Personenarbeitstage Effort until a first version of flutter json forms can be released

## 7. Allow more theming capabilities

Most of the UI can be themed as native Flutter widgets are used and a theme inherited Widget can be provided to adjust the looks. Other part sof the styling can be configured using the uiSchema. But there are other elements like the padding and widgets used for objects, arrays or groups, the padding for single elements, the alignment within columns and rows etc. Currently the customization options there are very limited and even tough not all options have to be available at the beginning, there should be provided substantially more options for the user

- Effort: 1 `Personenarbeitstag`


## Future features

- [ ] Resizable Textfield (see: https://medium.com/@paramjeet.singh0199/how-to-create-an-expandable-textfield-in-flutter-27d9787540cc). Vue Json Forms uses textfields which can be manually resized (when setting "multi": true in the ui schema)
- [ ] "date", "time" etc: show a hint of the current date or time so the field is not empty (Vue Json Forms does this)
- [ ] Rita Implementation in web version is buggy (Only used for demo application but should be investigated (web uses custom code))
- [ ] when removing an array element, the old value of the element is still present so when a new element is created, fields are shown even when no values from the old element are present
