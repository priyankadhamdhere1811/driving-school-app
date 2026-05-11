import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_spacing.dart';
import '../../../utils/app_text_styles.dart';
import '../../../widgets/owner/owner_search_filter_bar.dart';
import '../../../widgets/owner/owner_status_badge.dart';

class StudentListView extends StatelessWidget {
  const StudentListView({super.key});

  @override
  Widget build(BuildContext context) {
    final students = [
      const _StudentData(
        name: 'Amit Sharma',
        mobile: '+91 98765 11111',
        area: 'Main Road',
        course: 'Beginner Driving',
        duration: '30 days',
        totalFees: 'Rs 5,000',
        remainingFees: 'Rs 0',
        status: 'Active',
      ),
      const _StudentData(
        name: 'Neha Singh',
        mobile: '+91 98765 22222',
        area: 'Market Area',
        course: 'Advanced Course',
        duration: '15 days',
        totalFees: 'Rs 3,500',
        remainingFees: 'Rs 1,000',
        status: 'Pending Payment',
      ),
      const _StudentData(
        name: 'Vikram Patel',
        mobile: '+91 98765 33333',
        area: 'Station Road',
        course: 'Licence Assistance',
        duration: '20 days',
        totalFees: 'Rs 4,500',
        remainingFees: 'Rs 0',
        status: 'Completed',
      ),
    ];

    return SingleChildScrollView(
      padding: AppSpacing.ownerPagePadding,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.ownerMaxContentWidth,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _PageHeader(),
              const SizedBox(height: AppSpacing.sectionX),
              const OwnerSearchFilterBar(
                hintText: 'Search by name, mobile, area, or course',
                filters: ['All', 'Active', 'Completed', 'Pending Payment'],
                breakpoint: 520,
              ),
              const SizedBox(height: AppSpacing.sectionX),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth >= 900) {
                    return _StudentTable(students: students);
                  }

                  return _StudentCardsList(students: students);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StudentCardsList extends StatelessWidget {
  final List<_StudentData> students;

  const _StudentCardsList({required this.students});

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          students
              .map(
                (student) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                  child: _StudentCard(student: student),
                ),
              )
              .toList(),
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.card),
      decoration: _cardDecoration(radius: AppSpacing.ownerHeroCardRadius),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 620;

          return Wrap(
            spacing: AppSpacing.xl,
            runSpacing: AppSpacing.xl,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width:
                    isNarrow
                        ? constraints.maxWidth
                        : constraints.maxWidth - 190,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Students', style: AppTextStyles.ownerPageTitle),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      'Manage learner details, fees, course status, and follow-ups.',
                      style: AppTextStyles.sectionSubtitle,
                    ),
                  ],
                ),
              ),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.person_add_alt_1),
                label: const Text('Add Student'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxl,
                    vertical: AppSpacing.lg,
                  ),
                  minimumSize: const Size(0, 44),
                  textStyle: AppTextStyles.button,
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppSpacing.radiusMd,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StudentTable extends StatelessWidget {
  final List<_StudentData> students;

  const _StudentTable({required this.students});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: _cardDecoration(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingTextStyle: AppTextStyles.tableHeader,
          dataTextStyle: AppTextStyles.tableBody,
          headingRowHeight: AppSpacing.tableHeadingRowHeight,
          dataRowMinHeight: AppSpacing.tableDataRowMinHeight,
          dataRowMaxHeight: AppSpacing.tableDataRowMaxHeight,
          columns: const [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Mobile')),
            DataColumn(label: Text('Area')),
            DataColumn(label: Text('Course')),
            DataColumn(label: Text('Duration')),
            DataColumn(label: Text('Total Fees')),
            DataColumn(label: Text('Remaining')),
            DataColumn(label: Text('Status')),
          ],
          rows:
              students
                  .map(
                    (student) => DataRow(
                      cells: [
                        DataCell(Text(student.name)),
                        DataCell(Text(student.mobile)),
                        DataCell(Text(student.area)),
                        DataCell(Text(student.course)),
                        DataCell(Text(student.duration)),
                        DataCell(Text(student.totalFees)),
                        DataCell(Text(student.remainingFees)),
                        DataCell(OwnerStatusBadge(status: student.status)),
                      ],
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}

class _StudentCard extends StatelessWidget {
  final _StudentData student;

  const _StudentCard({required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                student.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textDark,
                ),
              ),
              OwnerStatusBadge(status: student.status),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _InfoLine('Mobile', student.mobile),
          _InfoLine('Area', student.area),
          _InfoLine('Course', student.course),
          _InfoLine('Duration', student.duration),
          _InfoLine('Total Fees', student.totalFees),
          _InfoLine('Remaining Fees', student.remainingFees),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLine(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 360;

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: AppColors.textGray)),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            );
          }

          return Row(
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  label,
                  style: const TextStyle(color: AppColors.textGray),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

BoxDecoration _cardDecoration({
  BorderRadius radius = AppSpacing.ownerCardRadius,
}) {
  return BoxDecoration(
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
  );
}

class _StudentData {
  final String name;
  final String mobile;
  final String area;
  final String course;
  final String duration;
  final String totalFees;
  final String remainingFees;
  final String status;

  const _StudentData({
    required this.name,
    required this.mobile,
    required this.area,
    required this.course,
    required this.duration,
    required this.totalFees,
    required this.remainingFees,
    required this.status,
  });
}
