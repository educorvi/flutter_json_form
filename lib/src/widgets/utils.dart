import 'package:flutter/material.dart';

Color getAlternatingColor(BuildContext context, int nestingLevel) {
  return nestingLevel % 2 == 1 ? Theme.of(context).colorScheme.surfaceContainerLow : Theme.of(context).colorScheme.surfaceContainerHigh;
}