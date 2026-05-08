import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_spacing.dart';
import '../../../utils/app_text_styles.dart';

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

    return Scaffold(
      backgroundColor: AppColors.softBackground,
      appBar: AppBar(
        title: const Text('Students'),
        backgroundColor: AppColors.card,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.sectionX),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _PageHeader(),
                const SizedBox(height: AppSpacing.sectionX),
                const _SearchAndFilters(),
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
      decoration: _cardDecoration(),
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
                    Text('Students', style: AppTextStyles.sectionTitle),
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

class _SearchAndFilters extends StatelessWidget {
  const _SearchAndFilters();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: _cardDecoration(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 520;

          return Wrap(
            spacing: AppSpacing.xl,
            runSpacing: AppSpacing.xl,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: isNarrow ? constraints.maxWidth : 360,
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by name, mobile, area, or course',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              SizedBox(
                width:
                    isNarrow
                        ? constraints.maxWidth
                        : constraints.maxWidth - 380,
                child: Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: const [
                    _FilterChip(label: 'All', selected: true),
                    _FilterChip(label: 'Active'),
                    _FilterChip(label: 'Completed'),
                    _FilterChip(label: 'Pending Payment'),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _FilterChip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: selected,
      onSelected: (_) {},
      label: Text(label),
      selectedColor: const Color(0xFFFFEBEE),
      checkmarkColor: AppColors.primary,
      side: BorderSide(
        color:
            selected ? AppColors.primary : Colors.black.withValues(alpha: 0.08),
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
          headingTextStyle: const TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w900,
          ),
          dataTextStyle: const TextStyle(color: AppColors.textDark),
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
                        DataCell(_StatusBadge(status: student.status)),
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
              _StatusBadge(status: student.status),
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

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color =
        status == 'Completed'
            ? AppColors.ctaGreen
            : status == 'Pending Payment'
            ? AppColors.accent
            : AppColors.primary;

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
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: AppColors.card,
    borderRadius: AppSpacing.radiusXl,
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
