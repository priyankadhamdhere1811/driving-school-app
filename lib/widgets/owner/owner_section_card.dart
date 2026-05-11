import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';

class OwnerSectionCard extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final Widget child;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;
  final BorderRadius radius;

  const OwnerSectionCard({
    super.key,
    required this.child,
    this.title,
    this.icon,
    this.trailing,
    this.padding = const EdgeInsets.all(AppSpacing.card),
    this.radius = AppSpacing.ownerCardRadius,
  });

  @override
  Widget build(BuildContext context) {
    final hasHeader = title != null || icon != null || trailing != null;

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: radius,
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasHeader) ...[
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.sm,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (title != null || icon != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: AppColors.primary),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      if (title != null)
                        Text(title!, style: AppTextStyles.ownerCardTitle),
                    ],
                  ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
          child,
        ],
      ),
    );
  }
}
