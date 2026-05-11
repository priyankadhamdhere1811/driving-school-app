import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_spacing.dart';
import '../../../utils/app_text_styles.dart';

class StudentDetailsView extends StatelessWidget {
  const StudentDetailsView({super.key});

  static const _student = _StudentDetails(
    initials: 'AS',
    name: 'Amit Sharma',
    course: 'Beginner Driving',
    status: 'Active',
    mobile: '+91 98765 11111',
    alternateMobile: '+91 98765 22222',
    area: 'Main Road',
    address: '24, Shanti Nagar, Near City Hospital, Main Road',
    startDate: '08 May 2026',
    duration: '30 days',
    preferredBatch: 'Morning Batch',
    totalFees: 'Rs 5,000',
    paidAmount: 'Rs 2,000',
    remainingFees: 'Rs 3,000',
    attendancePercent: '82%',
    classesAttended: '18',
    missedClasses: '4',
    notes:
        'Prefers morning practice sessions. Needs extra attention during reverse parking and slope start practice.',
  );

  static const _payments = [
    _PaymentRecord('08 May 2026', 'Rs 1,000', 'Cash', 'Paid'),
    _PaymentRecord('12 May 2026', 'Rs 500', 'UPI', 'Paid'),
    _PaymentRecord('18 May 2026', 'Rs 500', 'Cash', 'Paid'),
    _PaymentRecord('25 May 2026', 'Rs 3,000', 'UPI', 'Pending'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeaderSection(student: _student),
              SizedBox(height: AppSpacing.sectionX),
              _QuickStatsRow(student: _student),
              SizedBox(height: AppSpacing.sectionX),
              _MainSections(student: _student, payments: _payments),
              SizedBox(height: AppSpacing.sectionX),
              _BottomActions(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final _StudentDetails student;

  const _HeaderSection({required this.student});

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 680;

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
                        : constraints.maxWidth - 360,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundColor: const Color(0xFFFFEBEE),
                      child: Text(
                        student.initials,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xl),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(student.name, style: AppTextStyles.sectionTitle),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            student.course,
                            style: AppTextStyles.sectionSubtitle,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _StatusBadge(status: student.status),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: isNarrow ? constraints.maxWidth : 320,
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
    final edit = OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.edit_outlined),
      label: const Text('Edit Student'),
      style: _outlinedButtonStyle(),
    );
    final payment = FilledButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.payments_outlined),
      label: const Text('Record Payment'),
      style: _filledButtonStyle(AppColors.primary),
    );

    if (isNarrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [payment, const SizedBox(height: AppSpacing.sm), edit],
      );
    }

    return Wrap(
      alignment: WrapAlignment.end,
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.sm,
      children: [
        SizedBox(width: 142, child: edit),
        SizedBox(width: 166, child: payment),
      ],
    );
  }
}

class _QuickStatsRow extends StatelessWidget {
  final _StudentDetails student;

  const _QuickStatsRow({required this.student});

  @override
  Widget build(BuildContext context) {
    final stats = [
      _StatData('Total Fees', student.totalFees, Icons.payments_outlined),
      _StatData('Paid Amount', student.paidAmount, Icons.done_all_outlined),
      _StatData(
        'Remaining Fees',
        student.remainingFees,
        Icons.receipt_long_outlined,
      ),
      _StatData(
        'Attendance',
        student.attendancePercent,
        Icons.fact_check_outlined,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns =
            width >= 940
                ? 4
                : width >= 620
                ? 2
                : 1;
        final gap = width < 620 ? AppSpacing.md : AppSpacing.xl;
        final cardWidth = (width - (gap * (columns - 1))) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children:
              stats
                  .map((stat) => _StatCard(width: cardWidth, stat: stat))
                  .toList(),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final double width;
  final _StatData stat;

  const _StatCard({required this.width, required this.stat});

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
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: AppSpacing.radiusMd,
              ),
              child: Icon(stat.icon, color: AppColors.primary),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              stat.value,
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              stat.label,
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

class _MainSections extends StatelessWidget {
  final _StudentDetails student;
  final List<_PaymentRecord> payments;

  const _MainSections({required this.student, required this.payments});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 900;
        final leftColumn = Column(
          children: [
            _InformationSection(student: student),
            const SizedBox(height: AppSpacing.sectionX),
            _NotesSection(notes: student.notes),
          ],
        );
        final rightColumn = Column(
          children: [
            _PaymentHistorySection(payments: payments),
            const SizedBox(height: AppSpacing.sectionX),
            _AttendanceSection(student: student),
          ],
        );

        if (!isWide) {
          return Column(
            children: [
              leftColumn,
              const SizedBox(height: AppSpacing.sectionX),
              rightColumn,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: leftColumn),
            const SizedBox(width: AppSpacing.sectionX),
            Expanded(child: rightColumn),
          ],
        );
      },
    );
  }
}

class _InformationSection extends StatelessWidget {
  final _StudentDetails student;

  const _InformationSection({required this.student});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Information',
      icon: Icons.person_outline,
      child: Column(
        children: [
          _InfoLine('Mobile number', student.mobile),
          _InfoLine('Alternate mobile', student.alternateMobile),
          _InfoLine('Area/Village', student.area),
          _InfoLine('Address', student.address),
          _InfoLine('Start date', student.startDate),
          _InfoLine('Duration', student.duration),
          _InfoLine('Preferred batch', student.preferredBatch),
        ],
      ),
    );
  }
}

class _PaymentHistorySection extends StatelessWidget {
  final List<_PaymentRecord> payments;

  const _PaymentHistorySection({required this.payments});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Payment History',
      icon: Icons.account_balance_wallet_outlined,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 560) {
            return Column(
              children:
                  payments
                      .map((payment) => _PaymentListTile(payment: payment))
                      .toList(),
            );
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingTextStyle: const TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.w900,
              ),
              dataTextStyle: const TextStyle(color: AppColors.textDark),
              columns: const [
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Amount')),
                DataColumn(label: Text('Method')),
                DataColumn(label: Text('Status')),
              ],
              rows:
                  payments
                      .map(
                        (payment) => DataRow(
                          cells: [
                            DataCell(Text(payment.date)),
                            DataCell(Text(payment.amount)),
                            DataCell(Text(payment.method)),
                            DataCell(_StatusBadge(status: payment.status)),
                          ],
                        ),
                      )
                      .toList(),
            ),
          );
        },
      ),
    );
  }
}

class _AttendanceSection extends StatelessWidget {
  final _StudentDetails student;

  const _AttendanceSection({required this.student});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Attendance',
      icon: Icons.fact_check_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpacing.xl,
            runSpacing: AppSpacing.md,
            children: [
              _MiniMetric(
                label: 'Classes attended',
                value: student.classesAttended,
              ),
              _MiniMetric(
                label: 'Missed classes',
                value: student.missedClasses,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: const LinearProgressIndicator(
              value: 0.82,
              minHeight: 10,
              backgroundColor: Color(0xFFFFEBEE),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${student.attendancePercent} attendance completed',
            style: const TextStyle(
              color: AppColors.textGray,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const _CalendarPlaceholder(),
        ],
      ),
    );
  }
}

class _NotesSection extends StatelessWidget {
  final String notes;

  const _NotesSection({required this.notes});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Notes',
      icon: Icons.notes_outlined,
      child: Text(
        notes,
        style: const TextStyle(
          color: AppColors.textDark,
          height: 1.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions();

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 480;
          final reminder = OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.alarm_outlined),
            label: const Text('Send Reminder'),
            style: _outlinedButtonStyle(),
          );
          final completed = FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Mark Completed'),
            style: _filledButtonStyle(AppColors.ctaGreen),
          );

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                reminder,
                const SizedBox(height: AppSpacing.sm),
                completed,
              ],
            );
          }

          return Wrap(
            alignment: WrapAlignment.end,
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            children: [
              SizedBox(width: 170, child: reminder),
              SizedBox(width: 180, child: completed),
            ],
          );
        },
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
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
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 420;

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
                width: 150,
                child: Text(
                  label,
                  style: const TextStyle(color: AppColors.textGray),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
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

class _PaymentListTile extends StatelessWidget {
  final _PaymentRecord payment;

  const _PaymentListTile({required this.payment});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7F7),
        borderRadius: AppSpacing.radiusMd,
        border: Border.all(color: AppColors.border),
      ),
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
                payment.date,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w900,
                ),
              ),
              _StatusBadge(status: payment.status),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${payment.amount} • ${payment.method}',
            style: const TextStyle(color: AppColors.textGray),
          ),
        ],
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  final String label;
  final String value;

  const _MiniMetric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7F7),
        borderRadius: AppSpacing.radiusMd,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textGray)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarPlaceholder extends StatelessWidget {
  const _CalendarPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7F7),
        borderRadius: AppSpacing.radiusMd,
        border: Border.all(color: AppColors.border),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisSpacing: AppSpacing.sm,
          crossAxisSpacing: AppSpacing.sm,
        ),
        itemCount: 28,
        itemBuilder: (context, index) {
          final isPresent = index % 5 != 0;

          return DecoratedBox(
            decoration: BoxDecoration(
              color: isPresent ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isPresent ? AppColors.primary : AppColors.border,
              ),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: isPresent ? Colors.white : AppColors.textGray,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
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
        status == 'Completed' || status == 'Paid'
            ? AppColors.ctaGreen
            : status == 'Pending Payment' || status == 'Pending'
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

class _StudentDetails {
  final String initials;
  final String name;
  final String course;
  final String status;
  final String mobile;
  final String alternateMobile;
  final String area;
  final String address;
  final String startDate;
  final String duration;
  final String preferredBatch;
  final String totalFees;
  final String paidAmount;
  final String remainingFees;
  final String attendancePercent;
  final String classesAttended;
  final String missedClasses;
  final String notes;

  const _StudentDetails({
    required this.initials,
    required this.name,
    required this.course,
    required this.status,
    required this.mobile,
    required this.alternateMobile,
    required this.area,
    required this.address,
    required this.startDate,
    required this.duration,
    required this.preferredBatch,
    required this.totalFees,
    required this.paidAmount,
    required this.remainingFees,
    required this.attendancePercent,
    required this.classesAttended,
    required this.missedClasses,
    required this.notes,
  });
}

class _PaymentRecord {
  final String date;
  final String amount;
  final String method;
  final String status;

  const _PaymentRecord(this.date, this.amount, this.method, this.status);
}

class _StatData {
  final String label;
  final String value;
  final IconData icon;

  const _StatData(this.label, this.value, this.icon);
}
