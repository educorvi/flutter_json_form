import 'package:flutter/material.dart';

/// Builds an animated cross fade widget that shows/hides a child based on visibility
Widget buildAnimatedVisibility({required Widget child, required bool isVisible}) {
  return AnimatedCrossFade(
    duration: const Duration(milliseconds: 400),
    sizeCurve: Curves.easeInOut,
    firstChild: child,
    secondChild: Container(),
    crossFadeState: isVisible ? CrossFadeState.showFirst : CrossFadeState.showSecond,
  );
}
