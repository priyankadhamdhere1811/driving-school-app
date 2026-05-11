import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';

class OwnerActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool primary;
  final Color? color;

  const OwnerActionButton({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
    this.primary = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (primary) {
      return FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: filledStyle(color ?? AppColors.primary),
      );
    }

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: outlinedStyle(),
    );
  }

  static ButtonStyle filledStyle(Color color) {
    return FilledButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      minimumSize: const Size(0, 44),
      textStyle: AppTextStyles.button,
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.radiusMd),
    );
  }

  static ButtonStyle outlinedStyle() {
    return OutlinedButton.styleFrom(
      foregroundColor: AppColors.textDark,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      minimumSize: const Size(0, 44),
      textStyle: AppTextStyles.button,
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.radiusMd),
    );
  }
}
