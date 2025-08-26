import 'package:flutter/material.dart';

Container getLineContainer({Widget? child}) {
  return Container(
    decoration: const BoxDecoration(
      border: Border(
        left: BorderSide(
          color: Colors.grey, // Change this color to match your design
          width: 2.0, // Change this width to match your design
        ),
      ),
    ),
    child: child,
  );
}
