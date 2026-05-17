import 'package:flutter/material.dart';

import '../views/owner/attendance/attendance_view.dart';
import '../views/owner/enquiries/owner_enquiries_view.dart';
import '../views/owner/layout/owner_layout.dart';
import '../views/owner/owner_dashboard_view.dart';
import '../views/owner/payments/payments_view.dart';
import '../views/owner/students/add_student_view.dart';
import '../views/owner/students/edit_student_view.dart';
import '../views/owner/students/student_details_view.dart';
import '../views/owner/students/student_list_view.dart';
import '../views/public/home_view.dart';

class AppRoutes {
  static const home = '/';
  static const ownerDashboard = '/owner/dashboard';
  static const ownerStudents = '/owner/students';
  static const addStudent = '/owner/students/add';
  static const studentDetails = '/owner/students/:id';
  static const editStudent = '/owner/students/:id/edit';
  static const payments = '/owner/payments';
  static const attendance = '/owner/attendance';
  static const enquiries = '/owner/enquiries';
  static const reviews = '/owner/reviews';
  static const settings = '/owner/settings';

  static Map<String, WidgetBuilder> get routes {
    return {
      home: (context) => const HomeView(),
      ownerDashboard:
          (context) => const OwnerLayout(
            title: 'Owner Dashboard',
            child: OwnerDashboardView(),
          ),
      ownerStudents:
          (context) =>
              const OwnerLayout(title: 'Students', child: StudentListView()),
      addStudent:
          (context) =>
              const OwnerLayout(title: 'Add Student', child: AddStudentView()),
      payments:
          (context) =>
              const OwnerLayout(title: 'Payments', child: PaymentsView()),
      attendance:
          (context) =>
              const OwnerLayout(title: 'Attendance', child: AttendanceView()),
      enquiries:
          (context) => const OwnerLayout(
            title: 'Enquiries',
            child: OwnerEnquiriesView(),
          ),
      reviews:
          (context) => const OwnerLayout(
            title: 'Reviews',
            child: _OwnerPlaceholder(title: 'Reviews'),
          ),
      settings:
          (context) => const OwnerLayout(
            title: 'Settings',
            child: _OwnerPlaceholder(title: 'Settings'),
          ),
    };
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? '');

    if (uri.pathSegments.length == 4 &&
        uri.pathSegments[0] == 'owner' &&
        uri.pathSegments[1] == 'students' &&
        uri.pathSegments[3] == 'edit') {
      final studentId = Uri.decodeComponent(uri.pathSegments[2]);

      return MaterialPageRoute(
        settings: settings,
        builder:
            (context) => OwnerLayout(
              title: 'Edit Student',
              child: EditStudentView(studentId: studentId),
            ),
      );
    }

    if (uri.pathSegments.length == 3 &&
        uri.pathSegments[0] == 'owner' &&
        uri.pathSegments[1] == 'students') {
      final studentId = Uri.decodeComponent(uri.pathSegments[2]);

      if (studentId == 'add') {
        return MaterialPageRoute(
          settings: settings,
          builder:
              (context) => const OwnerLayout(
                title: 'Add Student',
                child: AddStudentView(),
              ),
        );
      }

      return MaterialPageRoute(
        settings: settings,
        builder:
            (context) => OwnerLayout(
              title: 'Student Details',
              child: StudentDetailsView(studentId: studentId),
            ),
      );
    }

    return null;
  }
}

class _OwnerPlaceholder extends StatelessWidget {
  final String title;

  const _OwnerPlaceholder({required this.title});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            child: Text('$title screen coming soon.'),
          ),
        ),
      ),
    );
  }
}
