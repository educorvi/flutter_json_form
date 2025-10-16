import 'package:flutter/material.dart';

class FormFieldText extends StatelessWidget {
  final String label;
  final bool required;

  const FormFieldText(
    this.label, {
    super.key,
    this.required = false,
    this.style,
  });

  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              style: style ?? DefaultTextStyle.of(context).style,
              children: [
                TextSpan(text: label),
                if (required)
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: Semantics(
                      label: 'required',
                      child: const Text(
                        ' *',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
