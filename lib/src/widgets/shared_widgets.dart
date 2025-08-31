import 'package:flutter/material.dart';

Container getLineContainer({Widget? child}) {
  return Container(
    decoration: const BoxDecoration(
      border: Border(
        left: BorderSide(
          color: Colors.grey,
        ),
      ),
    ),
    child: child,
  );
}
