// import 'package:driving_school_app/views/owner/owner_dashboard_view.dart';
// import 'package:driving_school_app/views/owner/students/add_student_view.dart';
import 'package:driving_school_app/views/owner/attendance/attendance_view.dart';
// import 'package:driving_school_app/views/owner/payments/payments_view.dart';
// import 'package:driving_school_app/views/owner/students/student_details_view.dart';
// import 'package:driving_school_app/views/owner/students/student_list_view.dart';
import 'package:flutter/material.dart';
// import 'views/public/home_view.dart';
import 'utils/app_colors.dart';
import 'utils/app_constants.dart';
import 'utils/app_spacing.dart';
import 'utils/app_text_styles.dart';

class DrivingSchoolApp extends StatelessWidget {
  const DrivingSchoolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.accent,
          surface: AppColors.card,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: AppTextStyles.appBarTitle,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: AppSpacing.radiusMd,
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppSpacing.radiusMd,
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppSpacing.radiusMd,
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: AppColors.textDark,
          displayColor: AppColors.textDark,
        ),
        useMaterial3: true,
      ),
      home: const AttendanceView(),
    );
  }
}
