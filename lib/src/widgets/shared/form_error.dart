import 'package:flutter/material.dart';

class FormError extends StatelessWidget {
  final String message;

  const FormError(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Error: $message",
      style: const TextStyle(color: Colors.red),
    );
  }
}
