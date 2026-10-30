import 'package:flutter/material.dart';

/// TODO: should not be needed. Investigate when we get to the stae where we need this element and try to remove the need for it.
/// A loading placeholder widget used when FormContext is temporarily unavailable
/// during operations like reordering or complex rebuilds.
class FormElementLoading extends StatelessWidget {
  final double height;
  final String message;

  const FormElementLoading({
    super.key,
    this.height = 100,
    this.message = "Loading...",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      // decoration: BoxDecoration(
      //   color: Colors.grey.withValues(alpha: 0.1),
      //   borderRadius: BorderRadius.circular(4),
      // ),
      // child: Center(
      //   child: Text(
      //     message,
      //     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
      //           color: Colors.grey,
      //         ),
      //   ),
      // ),
    );
  }
}
