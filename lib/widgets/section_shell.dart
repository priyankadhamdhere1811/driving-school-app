import 'package:flutter/material.dart';

import '../utils/app_spacing.dart';

class SectionShell extends StatelessWidget {
  final Widget child;

  const SectionShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sectionX,
        vertical: AppSpacing.sectionY,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          child: child,
        ),
      ),
    );
  }
}
