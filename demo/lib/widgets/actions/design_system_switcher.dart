import 'package:flutter/material.dart';
import 'package:flutter_json_forms_demo/constants/constants.dart';
import 'package:flutter_json_forms_demo/notifiers/form_theme_notifier.dart';

class DesignSystemIcon extends StatelessWidget {
  final DesignSystem designSystem;

  const DesignSystemIcon({
    super.key,
    required this.designSystem,
  });

  @override
  Widget build(BuildContext context) {
    switch (designSystem) {
      case DesignSystem.googleMaterial:
        return const Icon(Icons.palette);
      case DesignSystem.uvCooperativeDesign:
        return const Icon(Icons.brush);
    }
  }
}

class DesignSystemSwitcher extends StatelessWidget {
  final FormThemeNotifier notifier;

  const DesignSystemSwitcher({
    super.key,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: notifier,
      builder: (context, child) {
        return IconButton(
          icon: DesignSystemIcon(designSystem: notifier.designSystem),
          onPressed: _cycleDesignSystem,
          tooltip: _getTooltip(notifier.designSystem),
        );
      },
    );
  }

  void _cycleDesignSystem() {
    switch (notifier.designSystem) {
      case DesignSystem.googleMaterial:
        notifier.setDesignSystem(DesignSystem.uvCooperativeDesign);
        break;
      case DesignSystem.uvCooperativeDesign:
        notifier.setDesignSystem(DesignSystem.googleMaterial);
        break;
    }
  }

  String _getTooltip(DesignSystem system) {
    switch (system) {
      case DesignSystem.googleMaterial:
        return 'Material Design (tap for UV)';
      case DesignSystem.uvCooperativeDesign:
        return 'UV Design (tap for Material)';
    }
  }
}
