import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class OwnerStatusBadge extends StatelessWidget {
  final String status;

  const OwnerStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    return switch (status) {
      'New' => AppColors.darkRed,
      'Contacted' => AppColors.accent,
      'Converted' => AppColors.ctaGreen,
      'Completed' || 'Paid' => AppColors.ctaGreen,
      'Pending Payment' || 'Pending' => AppColors.accent,
      'Overdue' => AppColors.darkRed,
      'Absent' => AppColors.textGray,
      _ => AppColors.primary,
    };
  }
}
