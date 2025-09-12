import 'package:flutter/material.dart';
import '../../models/ui_schema.g.dart' as ui;

class FormDivider extends StatelessWidget {
  final ui.Divider divider;

  const FormDivider({
    super.key,
    required this.divider,
  });

  @override
  Widget build(BuildContext context) {
    return const Divider();
  }
}
