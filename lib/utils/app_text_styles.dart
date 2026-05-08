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

  static const button = TextStyle(fontWeight: FontWeight.w800);
}
