import 'package:flutter/material.dart';

class FormNotImplemented extends StatelessWidget {
  final String type;

  const FormNotImplemented(this.type, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "TODO implement $type",
      style: const TextStyle(color: Colors.red),
    );
  }
}
