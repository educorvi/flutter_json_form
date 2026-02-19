import 'package:flutter/material.dart';
import 'package:flutter_json_forms_demo/constants/constants.dart';
import 'package:flutter_json_forms_demo/data/form_preset_data.dart';

import 'form_file/example_form_file.dart';
import 'form_file/form_file_base.dart';

class FormSelector extends StatefulWidget {
  final int initialSelectionIndex;

  const FormSelector({super.key, this.initialSelectionIndex = 0});

  @override
  State<FormSelector> createState() => FormSelectorState();
}

class FormSelectorState extends State<FormSelector> {
  late final List<FormFile> formFiles;
  late FormFile formFile;

  @override
  void initState() {
    super.initState();
    // Create formFiles once in state, so they persist across rebuilds
    formFiles = [
      ExampleFormFile(name: "Registration", filename: "registration", formData: getRegistration()),
      ExampleFormFile(name: "Showcase", filename: "showcase"),
      ExampleFormFile(name: "Wizard", filename: "wizard"),
      ExampleFormFile(name: "Specification", filename: "specification"),
      ExampleFormFile(name: "Druckvorlage", filename: "druckvorlage"),
      ExampleFormFile(name: "Reproduce", filename: "reproduce"),
      ExampleFormFile(name: "Json Schema", filename: "jsonSchema"),
      ExampleFormFile(
          name: "Reisekostenantrag mit Prozessautomatisierung", filename: "reisekostenantrag_paut", formData: getFormDataReisekostenantrag()),
      ExampleFormFile(name: "5 Sicherheitsregeln", filename: "fiverules", formData: getFormDataFiverules()),
      ExampleFormFile(name: "Gefährdungsbeurteilung für Kleinbetriebe", filename: "gfk1", formData: getFormDataGfk1()),
    ];
    formFile = formFiles[widget.initialSelectionIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MergeSemantics(
            child: DropdownMenu<FormFile>(
          label: const Text('Select Form'),
          initialSelection: formFiles[widget.initialSelectionIndex],
          width: LayoutConstants.maxPageWidth,
          dropdownMenuEntries: formFiles
              .map((formFile) => DropdownMenuEntry<FormFile>(
                    value: formFile,
                    label: formFile.name,
                  ))
              .toList(),
          onSelected: (value) {
            if (value != null) {
              setState(() {
                formFile = value;
              });
            }
          },
        )),
        LayoutConstants.gapM,
        SafeArea(
          child: formFile.getForm(),
        )
      ],
    );
  }
}
