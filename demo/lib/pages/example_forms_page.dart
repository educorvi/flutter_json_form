import 'package:flutter/material.dart';
import 'package:flutter_json_forms_demo/constants/constants.dart';
import 'package:flutter_json_forms_demo/widgets/form_selector.dart';

class ExampleFormsPage extends StatelessWidget {
  const ExampleFormsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: LayoutConstants.paddingAll,
      children: [
        Center(
          child: SizedBox(
            width: LayoutConstants.maxPageWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Example Forms',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                LayoutConstants.gapM,
                FormSelector(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
