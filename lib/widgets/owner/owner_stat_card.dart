import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';

class OwnerStatCard extends StatelessWidget {
  final double width;
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color color;

  const OwnerStatCard({
    super.key,
    required this.width,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppSpacing.ownerCardRadius,
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
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: AppSpacing.radiusMd,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(value, style: AppTextStyles.ownerMetricValue),
          const SizedBox(height: AppSpacing.xs),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(subtitle!, style: const TextStyle(color: AppColors.textGray)),
          ],
        ],
      ),
    );
  }
}
