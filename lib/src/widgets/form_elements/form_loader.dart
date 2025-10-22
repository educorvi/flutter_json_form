import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Creates a skeleton form while loading
class FormLoader extends StatelessWidget {
  final int itemCount;
  final double spacing;

  const FormLoader({
    super.key,
    this.itemCount = 10,
    this.spacing = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Loading indicator at top
            const Bone.text(words: 2, fontSize: 24),
            SizedBox(height: spacing),

            // Form fields skeleton
            for (int i = 0; i < itemCount; i++) ...[
              const Bone.text(words: 1, fontSize: 18),
              const SizedBox(height: 16),
              const Bone.text(words: 4, fontSize: 14),
              SizedBox(height: spacing),
            ],

            // Button skeleton
            const Bone.button(width: 120, height: 48),
            SizedBox(height: spacing / 2),
          ],
        ),
      ),
    );
  }
}
