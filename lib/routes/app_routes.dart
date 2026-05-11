import 'package:flutter/material.dart';

import '../views/owner/attendance/attendance_view.dart';
import '../views/owner/owner_dashboard_view.dart';
import '../views/owner/payments/payments_view.dart';
import '../views/owner/students/add_student_view.dart';
import '../views/owner/students/student_details_view.dart';
import '../views/owner/students/student_list_view.dart';
import '../views/public/home_view.dart';

class AppRoutes {
  static const home = '/';
  static const ownerDashboard = '/owner/dashboard';
  static const ownerStudents = '/owner/students';
  static const addStudent = '/owner/students/add';
  static const studentDetails = '/owner/students/details';
  static const payments = '/owner/payments';
  static const attendance = '/owner/attendance';

  static Map<String, WidgetBuilder> get routes {
    return {
      home: (context) => const HomeView(),
      ownerDashboard: (context) => const OwnerDashboardView(),
      ownerStudents: (context) => const StudentListView(),
      addStudent: (context) => const AddStudentView(),
      studentDetails: (context) => const StudentDetailsView(),
      payments: (context) => const PaymentsView(),
      attendance: (context) => const AttendanceView(),
    };
  }
}
