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
    final defaultStyle = style ?? DefaultTextStyle.of(context).style;
    return Row(
      children: [
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: label, style: defaultStyle),
                if (required)
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: Semantics(
                      label: 'required',
                      child: Text(
                        '*',
                        style: defaultStyle.copyWith(fontWeight: FontWeight.bold),
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
