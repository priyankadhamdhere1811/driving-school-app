import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_spacing.dart';
import '../../../utils/app_text_styles.dart';

class AttendanceView extends StatelessWidget {
  const AttendanceView({super.key});

  static const _students = [
    _AttendanceStudent(
      name: 'Amit Sharma',
      course: 'Beginner Driving',
      batch: 'Morning Batch',
      mobile: '+91 98765 11111',
      status: 'Present',
      attendancePercent: '92%',
      lastAttended: '08 May 2026',
    ),
    _AttendanceStudent(
      name: 'Neha Singh',
      course: 'Advanced Course',
      batch: 'Evening Batch',
      mobile: '+91 98765 22222',
      status: 'Absent',
      attendancePercent: '76%',
      lastAttended: '07 May 2026',
    ),
    _AttendanceStudent(
      name: 'Vikram Patel',
      course: 'Licence Assistance',
      batch: 'Morning Batch',
      mobile: '+91 98765 33333',
      status: 'Present',
      attendancePercent: '88%',
      lastAttended: '08 May 2026',
    ),
    _AttendanceStudent(
      name: 'Priya Nair',
      course: 'Beginner Driving',
      batch: 'Weekend Batch',
      mobile: '+91 98765 44444',
      status: 'Present',
      attendancePercent: '84%',
      lastAttended: '08 May 2026',
    ),
    _AttendanceStudent(
      name: 'Rohan Das',
      course: 'Advanced Course',
      batch: 'Evening Batch',
      mobile: '+91 98765 55555',
      status: 'Absent',
      attendancePercent: '68%',
      lastAttended: '06 May 2026',
    ),
    _AttendanceStudent(
      name: 'Sara Khan',
      course: 'Beginner Driving',
      batch: 'Morning Batch',
      mobile: '+91 98765 66666',
      status: 'Present',
      attendancePercent: '95%',
      lastAttended: '08 May 2026',
    ),
    _AttendanceStudent(
      name: 'Karan Mehta',
      course: 'Weekend Batch',
      batch: 'Weekend Batch',
      mobile: '+91 98765 77777',
      status: 'Present',
      attendancePercent: '81%',
      lastAttended: '08 May 2026',
    ),
    _AttendanceStudent(
      name: 'Anjali Rao',
      course: 'Licence Assistance',
      batch: 'Evening Batch',
      mobile: '+91 98765 88888',
      status: 'Absent',
      attendancePercent: '72%',
      lastAttended: '05 May 2026',
    ),
  ];

  static const _batches = [
    _BatchData('Morning Batch', '34', '29', '85%'),
    _BatchData('Evening Batch', '28', '21', '75%'),
    _BatchData('Weekend Batch', '18', '16', '89%'),
  ];

  static const _trendCards = [
    _TrendData('Week 1', '82%', Icons.trending_up),
    _TrendData('Week 2', '86%', Icons.show_chart),
    _TrendData('Week 3', '79%', Icons.trending_down),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PageHeader(),
              SizedBox(height: AppSpacing.sectionX),
              _SummaryCards(),
              SizedBox(height: AppSpacing.sectionX),
              _SearchAndFilters(),
              SizedBox(height: AppSpacing.sectionX),
              _AttendanceRecords(students: _students),
              SizedBox(height: AppSpacing.sectionX),
              _AttendanceCalendarSection(),
              SizedBox(height: AppSpacing.sectionX),
              _BatchOverviewSection(batches: _batches),
              SizedBox(height: AppSpacing.sectionX),
              _AttendanceAnalytics(trends: _trendCards),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader();

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 700;

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
                        : constraints.maxWidth - 370,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Attendance', style: AppTextStyles.sectionTitle),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      'Track daily student attendance and batch participation.',
                      style: AppTextStyles.sectionSubtitle,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: isNarrow ? constraints.maxWidth : 340,
                child: _HeaderActions(isNarrow: isNarrow),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HeaderActions extends StatelessWidget {
  final bool isNarrow;

  const _HeaderActions({required this.isNarrow});

  @override
  Widget build(BuildContext context) {
    final markAttendance = FilledButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.fact_check_outlined),
      label: const Text('Mark Attendance'),
      style: _filledButtonStyle(AppColors.primary),
    );
    final exportAttendance = OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.file_download_outlined),
      label: const Text('Export Attendance'),
      style: _outlinedButtonStyle(),
    );

    if (isNarrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          markAttendance,
          const SizedBox(height: AppSpacing.sm),
          exportAttendance,
        ],
      );
    }

    return Wrap(
      alignment: WrapAlignment.end,
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.sm,
      children: [
        SizedBox(width: 164, child: markAttendance),
        SizedBox(width: 164, child: exportAttendance),
      ],
    );
  }
}

class _SummaryCards extends StatelessWidget {
  const _SummaryCards();

  @override
  Widget build(BuildContext context) {
    final cards = [
      const _SummaryData(
        'Total Active Students',
        '128',
        Icons.people_outline,
        AppColors.primary,
      ),
      const _SummaryData(
        'Present Today',
        '94',
        Icons.check_circle_outline,
        AppColors.ctaGreen,
      ),
      const _SummaryData(
        'Absent Today',
        '34',
        Icons.cancel_outlined,
        AppColors.accent,
      ),
      const _SummaryData(
        'Attendance Percentage',
        '73%',
        Icons.analytics_outlined,
        AppColors.darkRed,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns =
            width >= 1040
                ? 4
                : width >= 680
                ? 2
                : 1;
        final gap = width < 680 ? AppSpacing.md : AppSpacing.xl;
        final cardWidth = (width - (gap * (columns - 1))) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children:
              cards
                  .map((card) => _SummaryCard(width: cardWidth, data: card))
                  .toList(),
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final double width;
  final _SummaryData data;

  const _SummaryCard({required this.width, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: _SoftCard(
        padding: const EdgeInsets.all(AppSpacing.xl),
        radius: AppSpacing.radiusLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: data.color.withValues(alpha: 0.1),
                borderRadius: AppSpacing.radiusMd,
              ),
              child: Icon(data.icon, color: data.color),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              data.value,
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              data.label,
              style: const TextStyle(
                color: AppColors.textGray,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchAndFilters extends StatelessWidget {
  const _SearchAndFilters();

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 600;

          return Wrap(
            spacing: AppSpacing.xl,
            runSpacing: AppSpacing.xl,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: isNarrow ? constraints.maxWidth : 360,
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by student name or mobile',
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
                    _FilterChip(label: 'Present'),
                    _FilterChip(label: 'Absent'),
                    _FilterChip(label: 'Morning Batch'),
                    _FilterChip(label: 'Evening Batch'),
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

class _AttendanceRecords extends StatelessWidget {
  final List<_AttendanceStudent> students;

  const _AttendanceRecords({required this.students});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 980) {
          return _AttendanceTable(students: students);
        }

        return _AttendanceCardList(students: students);
      },
    );
  }
}

class _AttendanceTable extends StatelessWidget {
  final List<_AttendanceStudent> students;

  const _AttendanceTable({required this.students});

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingTextStyle: const TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w900,
          ),
          dataTextStyle: const TextStyle(color: AppColors.textDark),
          columns: const [
            DataColumn(label: Text('Student Name')),
            DataColumn(label: Text('Course')),
            DataColumn(label: Text('Batch')),
            DataColumn(label: Text('Mobile')),
            DataColumn(label: Text("Today's Status")),
            DataColumn(label: Text('Attendance %')),
            DataColumn(label: Text('Last Attended')),
            DataColumn(label: Text('Actions')),
          ],
          rows:
              students
                  .map(
                    (student) => DataRow(
                      cells: [
                        DataCell(
                          Text(
                            student.name,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                        DataCell(Text(student.course)),
                        DataCell(Text(student.batch)),
                        DataCell(Text(student.mobile)),
                        DataCell(_StatusBadge(status: student.status)),
                        DataCell(Text(student.attendancePercent)),
                        DataCell(Text(student.lastAttended)),
                        DataCell(
                          IconButton(
                            tooltip: 'Update attendance',
                            onPressed: () {},
                            icon: const Icon(Icons.edit_calendar_outlined),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}

class _AttendanceCardList extends StatelessWidget {
  final List<_AttendanceStudent> students;

  const _AttendanceCardList({required this.students});

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          students
              .map(
                (student) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                  child: _AttendanceCard(student: student),
                ),
              )
              .toList(),
    );
  }
}

class _AttendanceCard extends StatelessWidget {
  final _AttendanceStudent student;

  const _AttendanceCard({required this.student});

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      radius: AppSpacing.radiusLg,
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
                  color: AppColors.textDark,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              _StatusBadge(status: student.status),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _InfoLine('Course', student.course),
          _InfoLine('Batch', student.batch),
          _InfoLine('Mobile', student.mobile),
          _InfoLine('Attendance', student.attendancePercent),
          _InfoLine('Last Attended', student.lastAttended),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit_calendar_outlined),
              label: const Text('Update'),
              style: _filledButtonStyle(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _AttendanceCalendarSection extends StatelessWidget {
  const _AttendanceCalendarSection();

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Monthly Attendance Calendar',
      icon: Icons.calendar_month_outlined,
      trailing: const Text(
        '82% monthly attendance',
        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w900),
      ),
      child: const _CalendarGrid(),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cellGap = constraints.maxWidth < 420 ? 6.0 : AppSpacing.sm;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: cellGap,
            crossAxisSpacing: cellGap,
          ),
          itemCount: 31,
          itemBuilder: (context, index) {
            final day = index + 1;
            final isCurrentDay = day == 8;
            final isPresent = day % 6 != 0 && day % 7 != 0;

            return DecoratedBox(
              decoration: BoxDecoration(
                color: isPresent ? AppColors.primary : const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(10),
                border:
                    isCurrentDay
                        ? Border.all(color: AppColors.darkRed, width: 2)
                        : null,
              ),
              child: Center(
                child: Text(
                  '$day',
                  style: TextStyle(
                    color: isPresent ? Colors.white : AppColors.textGray,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _BatchOverviewSection extends StatelessWidget {
  final List<_BatchData> batches;

  const _BatchOverviewSection({required this.batches});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns =
            width >= 920
                ? 3
                : width >= 620
                ? 2
                : 1;
        final gap = width < 620 ? AppSpacing.md : AppSpacing.xl;
        final cardWidth = (width - (gap * (columns - 1))) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children:
              batches
                  .map((batch) => _BatchCard(width: cardWidth, batch: batch))
                  .toList(),
        );
      },
    );
  }
}

class _BatchCard extends StatelessWidget {
  final double width;
  final _BatchData batch;

  const _BatchCard({required this.width, required this.batch});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: _SoftCard(
        padding: const EdgeInsets.all(AppSpacing.xl),
        radius: AppSpacing.radiusLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              batch.name,
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            _InfoLine('Total students', batch.totalStudents),
            _InfoLine('Present count', batch.presentCount),
            _InfoLine('Attendance', batch.attendancePercent),
          ],
        ),
      ),
    );
  }
}

class _AttendanceAnalytics extends StatelessWidget {
  final List<_TrendData> trends;

  const _AttendanceAnalytics({required this.trends});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Attendance Analytics',
      icon: Icons.analytics_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _ProgressLine(
            label: 'Weekly attendance progress',
            valueLabel: '78% this week',
            value: 0.78,
          ),
          const SizedBox(height: AppSpacing.xl),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final columns =
                  width >= 760
                      ? 3
                      : width >= 500
                      ? 2
                      : 1;
              final gap = width < 500 ? AppSpacing.md : AppSpacing.xl;
              final cardWidth = (width - (gap * (columns - 1))) / columns;

              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children:
                    trends
                        .map(
                          (trend) => _TrendCard(width: cardWidth, trend: trend),
                        )
                        .toList(),
              );
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          const _OverallRateCard(),
        ],
      ),
    );
  }
}

class _ProgressLine extends StatelessWidget {
  final String label;
  final String valueLabel;
  final double value;

  const _ProgressLine({
    required this.label,
    required this.valueLabel,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.xs,
          alignment: WrapAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(valueLabel, style: const TextStyle(color: AppColors.textGray)),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 10,
            backgroundColor: const Color(0xFFFFEBEE),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ],
    );
  }
}

class _TrendCard extends StatelessWidget {
  final double width;
  final _TrendData trend;

  const _TrendCard({required this.width, required this.trend});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7F7),
        borderRadius: AppSpacing.radiusMd,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(trend.icon, color: AppColors.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trend.label,
                  style: const TextStyle(color: AppColors.textGray),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  trend.value,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OverallRateCard extends StatelessWidget {
  const _OverallRateCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7F7),
        borderRadius: AppSpacing.radiusLg,
        border: Border.all(color: AppColors.border),
      ),
      child: const Text(
        'Overall attendance rate: 83% across all active batches this month.',
        style: TextStyle(
          color: AppColors.textDark,
          fontWeight: FontWeight.w800,
          height: 1.4,
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final Widget? trailing;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          child,
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
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 126,
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
                    fontWeight: FontWeight.w800,
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
    final isPresent = status == 'Present';
    final color = isPresent ? AppColors.primary : AppColors.textGray;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color:
            isPresent
                ? AppColors.primary.withValues(alpha: 0.1)
                : Colors.grey.shade200,
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
}

class _SoftCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius radius;

  const _SoftCard({
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.card),
    this.radius = AppSpacing.radiusXl,
  });

  @override
  Widget build(BuildContext context) {
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
      child: child,
    );
  }
}

ButtonStyle _filledButtonStyle(Color color) {
  return FilledButton.styleFrom(
    backgroundColor: color,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
    textStyle: AppTextStyles.button,
    shape: const RoundedRectangleBorder(borderRadius: AppSpacing.radiusMd),
  );
}

ButtonStyle _outlinedButtonStyle() {
  return OutlinedButton.styleFrom(
    foregroundColor: AppColors.textDark,
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
    textStyle: AppTextStyles.button,
    shape: const RoundedRectangleBorder(borderRadius: AppSpacing.radiusMd),
  );
}

class _AttendanceStudent {
  final String name;
  final String course;
  final String batch;
  final String mobile;
  final String status;
  final String attendancePercent;
  final String lastAttended;

  const _AttendanceStudent({
    required this.name,
    required this.course,
    required this.batch,
    required this.mobile,
    required this.status,
    required this.attendancePercent,
    required this.lastAttended,
  });
}

class _BatchData {
  final String name;
  final String totalStudents;
  final String presentCount;
  final String attendancePercent;

  const _BatchData(
    this.name,
    this.totalStudents,
    this.presentCount,
    this.attendancePercent,
  );
}

class _SummaryData {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryData(this.label, this.value, this.icon, this.color);
}

class _TrendData {
  final String label;
  final String value;
  final IconData icon;

  const _TrendData(this.label, this.value, this.icon);
}
