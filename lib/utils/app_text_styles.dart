import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  static const appBarTitle = TextStyle(
    color: AppColors.textDark,
    fontSize: 20,
    fontWeight: FontWeight.w800,
  );

  static const sectionTitle = TextStyle(
    fontSize: 30,
    height: 1.15,
    fontWeight: FontWeight.w800,
    color: AppColors.textDark,
  );

  static const sectionSubtitle = TextStyle(
    fontSize: 16,
    height: 1.5,
    color: AppColors.textGray,
  );

  static const ownerPageTitle = sectionTitle;

  static const ownerSectionTitle = TextStyle(
    fontSize: 18,
    height: 1.25,
    fontWeight: FontWeight.w900,
    color: AppColors.textDark,
  );

  static const ownerCardTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w900,
    color: AppColors.textDark,
  );

  static const ownerMetricValue = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w900,
    color: AppColors.textDark,
  );

  static const ownerLabel = TextStyle(color: AppColors.textGray);

  static const ownerValue = TextStyle(
    color: AppColors.textDark,
    fontWeight: FontWeight.w800,
  );

  static const tableHeader = TextStyle(
    color: AppColors.textDark,
    fontWeight: FontWeight.w900,
  );

  static const tableBody = TextStyle(color: AppColors.textDark);

  static const button = TextStyle(fontWeight: FontWeight.w800, fontSize: 14);
}
