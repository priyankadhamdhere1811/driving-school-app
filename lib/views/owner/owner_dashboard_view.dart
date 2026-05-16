import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/payment_model.dart';
import '../../models/reminder_model.dart';
import '../../models/student_model.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/payment_provider.dart';
import '../../providers/reminder_provider.dart';
import '../../providers/student_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';
import '../../widgets/owner/owner_section_card.dart';
import '../../widgets/owner/owner_stat_card.dart';
import '../../widgets/owner/owner_status_badge.dart';

class OwnerDashboardView extends StatelessWidget {
  const OwnerDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _DashboardContent();
  }
}

class _DashboardContent extends StatefulWidget {
  const _DashboardContent();

  @override
  State<_DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<_DashboardContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<StudentProvider>().fetchStudents();
        context.read<PaymentProvider>().fetchPayments();
        context.read<AttendanceProvider>().fetchAttendance();
        context.read<ReminderProvider>().fetchReminders();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.ownerDashboardPadding,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.ownerMaxContentWidth,
          ),
          child: Consumer4<
            StudentProvider,
            PaymentProvider,
            AttendanceProvider,
            ReminderProvider
          >(
            builder: (
              context,
              studentProvider,
              paymentProvider,
              attendanceProvider,
              reminderProvider,
              child,
            ) {
              final students = studentProvider.students;
              final payments = paymentProvider.payments;
              final cards = _buildMetricCards(students, attendanceProvider);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _HeaderBlock(),
                  const SizedBox(height: AppSpacing.sectionX),
                  _MetricCards(cards: cards),
                  const SizedBox(height: AppSpacing.sectionX),
                  _DashboardSections(
                    recentPayments: _recentPaymentRows(payments, students),
                    duePayments: _upcomingDueRows(students),
                    reminders: reminderProvider.reminders,
                    paymentsLoading: paymentProvider.isLoading,
                    studentsLoading: studentProvider.isLoading,
                    remindersLoading: reminderProvider.isLoading,
                    paymentsError: paymentProvider.errorMessage,
                    studentsError: studentProvider.errorMessage,
                    remindersError: reminderProvider.errorMessage,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _MetricCards extends StatelessWidget {
  final List<_MetricData> cards;

  const _MetricCards({required this.cards});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 760 ? 2 : 1;
        final spacing = columns == 1 ? AppSpacing.md : AppSpacing.xl;
        final cardWidth = columns == 1 ? width : (width - spacing) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children:
              cards
                  .map(
                    (card) => SizedBox(
                      width: cardWidth,
                      child: OwnerStatCard(
                        width: double.infinity,
                        title: card.title,
                        value: card.value,
                        subtitle: card.subtitle,
                        icon: card.icon,
                        color: card.color,
                      ),
                    ),
                  )
                  .toList(),
        );
      },
    );
  }
}

class _HeaderBlock extends StatelessWidget {
  const _HeaderBlock();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.card),
      decoration: _cardDecoration(radius: AppSpacing.ownerHeroCardRadius),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Good morning, Owner', style: AppTextStyles.ownerPageTitle),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Here is a quick view of students, payments, attendance, and enquiries.',
            style: AppTextStyles.sectionSubtitle,
          ),
        ],
      ),
    );
  }
}

class _DashboardSections extends StatelessWidget {
  final List<_InfoRow> recentPayments;
  final List<_InfoRow> duePayments;
  final List<ReminderModel> reminders;
  final bool paymentsLoading;
  final bool studentsLoading;
  final bool remindersLoading;
  final String? paymentsError;
  final String? studentsError;
  final String? remindersError;

  const _DashboardSections({
    required this.recentPayments,
    required this.duePayments,
    required this.reminders,
    required this.paymentsLoading,
    required this.studentsLoading,
    required this.remindersLoading,
    required this.paymentsError,
    required this.studentsError,
    required this.remindersError,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 920;
        final recentPaymentsCard = _InfoPanel(
          title: 'Recent Payments',
          rows: recentPayments,
          isLoading: paymentsLoading,
          errorMessage: paymentsError,
          emptyMessage: 'No recent payments found.',
        );
        final duePaymentsCard = _InfoPanel(
          title: 'Upcoming Due Payments',
          rows: duePayments,
          isLoading: studentsLoading,
          errorMessage: studentsError,
          emptyMessage: 'No upcoming dues found.',
        );
        final remindersCard = _ReminderPanel(
          reminders: reminders,
          isLoading: remindersLoading,
          errorMessage: remindersError,
        );

        if (!isWide) {
          return Column(
            children: [
              recentPaymentsCard,
              const SizedBox(height: AppSpacing.xl),
              duePaymentsCard,
              const SizedBox(height: AppSpacing.xl),
              remindersCard,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: recentPaymentsCard),
            const SizedBox(width: AppSpacing.xl),
            Expanded(child: duePaymentsCard),
            const SizedBox(width: AppSpacing.xl),
            Expanded(child: remindersCard),
          ],
        );
      },
    );
  }
}

class _InfoPanel extends StatelessWidget {
  final String title;
  final List<_InfoRow> rows;
  final bool isLoading;
  final String? errorMessage;
  final String emptyMessage;

  const _InfoPanel({
    required this.title,
    required this.rows,
    this.isLoading = false,
    this.errorMessage,
    this.emptyMessage = 'No records found.',
  });

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (isLoading) {
      child = const _InlineMessage(message: 'Loading...');
    } else if (errorMessage != null) {
      child = _InlineMessage(message: errorMessage!, isError: true);
    } else if (rows.isEmpty) {
      child = _InlineMessage(message: emptyMessage);
    } else {
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [...rows.map((row) => _InfoListTile(row: row))],
      );
    }

    return OwnerSectionCard(
      title: title,
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: child,
    );
  }
}

class _ReminderPanel extends StatelessWidget {
  final List<ReminderModel> reminders;
  final bool isLoading;
  final String? errorMessage;

  const _ReminderPanel({
    required this.reminders,
    required this.isLoading,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (isLoading) {
      child = const Text(
        'Loading reminders...',
        style: TextStyle(color: AppColors.textGray),
      );
    } else if (errorMessage != null) {
      child = Text(
        errorMessage!,
        style: const TextStyle(color: AppColors.darkRed),
      );
    } else if (reminders.isEmpty) {
      child = const Text(
        'No reminders yet.',
        style: TextStyle(color: AppColors.textGray),
      );
    } else {
      child = _ReminderList(reminders: reminders);
    }

    return OwnerSectionCard(
      title: 'Payment Reminders',
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: child,
    );
  }
}

class _ReminderList extends StatelessWidget {
  final List<ReminderModel> reminders;

  const _ReminderList({required this.reminders});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 720 ? 2 : 1;
        final spacing = AppSpacing.md;
        final tileWidth =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children:
              reminders
                  .map(
                    (reminder) => SizedBox(
                      width: tileWidth,
                      child: _ReminderTile(reminder: reminder),
                    ),
                  )
                  .toList(),
        );
      },
    );
  }
}

class _ReminderTile extends StatelessWidget {
  final ReminderModel reminder;

  const _ReminderTile({required this.reminder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 420;

        final details = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              reminder.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              reminder.message.isEmpty ? 'No message added' : reminder.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.textGray, height: 1.35),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Due ${reminder.dueDateText}',
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        );

        final actions = Column(
          crossAxisAlignment:
              isCompact ? CrossAxisAlignment.stretch : CrossAxisAlignment.end,
          children: [
            Align(
              alignment:
                  isCompact ? Alignment.centerLeft : Alignment.centerRight,
              child: OwnerStatusBadge(status: reminder.status),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: isCompact ? double.infinity : 128,
              height: 40,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none_outlined, size: 18),
                label: const Text('Reminder'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textDark,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  textStyle: AppTextStyles.button,
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppSpacing.radiusMd,
                  ),
                ),
              ),
            ),
          ],
        );

        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.ownerCardTint,
            borderRadius: AppSpacing.radiusMd,
            border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
          ),
          child:
              isCompact
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      details,
                      const SizedBox(height: AppSpacing.md),
                      actions,
                    ],
                  )
                  : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: details),
                      const SizedBox(width: AppSpacing.md),
                      actions,
                    ],
                  ),
        );
      },
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

class _InfoListTile extends StatelessWidget {
  final _InfoRow row;

  const _InfoListTile({required this.row});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.title,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  row.subtitle,
                  style: const TextStyle(color: AppColors.textGray),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                row.value,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                row.status,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InlineMessage extends StatelessWidget {
  final String message;
  final bool isError;

  const _InlineMessage({required this.message, this.isError = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: TextStyle(
        color: isError ? AppColors.darkRed : AppColors.textGray,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

List<_MetricData> _buildMetricCards(
  List<StudentModel> students,
  AttendanceProvider attendanceProvider,
) {
  final pendingAmount = students.fold<num>(
    0,
    (total, student) => total + student.remainingFees,
  );
  final presentToday = _presentStudentIdsToday(attendanceProvider, students);
  final attendancePercent =
      students.isEmpty
          ? 0
          : ((presentToday.length / students.length) * 100).round();
  final endingSoon = students.where(_isCourseEndingSoon).length;

  return [
    _MetricData(
      'Total Students',
      students.length.toString(),
      'Active records',
      Icons.people_outline,
      AppColors.primary,
    ),
    _MetricData(
      'Pending Payments',
      _formatAmount(pendingAmount),
      '${students.where((student) => student.remainingFees > 0).length} dues open',
      Icons.account_balance_wallet_outlined,
      AppColors.accent,
    ),
    _MetricData(
      "Today's Attendance",
      '${presentToday.length} / ${students.length}',
      '$attendancePercent% present',
      Icons.fact_check_outlined,
      AppColors.ctaGreen,
    ),
    _MetricData(
      'Courses Ending Soon',
      endingSoon.toString(),
      'Next 7 days',
      Icons.event_available_outlined,
      AppColors.darkRed,
    ),
    const _MetricData(
      'New Enquiries',
      '16',
      '5 need callback',
      Icons.mark_email_unread_outlined,
      AppColors.primary,
    ),
  ];
}

List<_InfoRow> _recentPaymentRows(
  List<PaymentModel> payments,
  List<StudentModel> students,
) {
  final studentsById = {for (final student in students) student.id: student};
  final sortedPayments = [...payments]..sort((a, b) {
    final aDate = a.paymentDate ?? DateTime.fromMillisecondsSinceEpoch(0);
    final bDate = b.paymentDate ?? DateTime.fromMillisecondsSinceEpoch(0);
    return bDate.compareTo(aDate);
  });

  return sortedPayments.take(4).map((payment) {
    final student = studentsById[payment.studentId];
    return _InfoRow(
      student?.fullName ?? 'Unknown Student',
      payment.paymentMethod.isEmpty
          ? _formatDate(payment.paymentDate)
          : payment.paymentMethod,
      payment.amountText,
      'Paid',
    );
  }).toList();
}

List<_InfoRow> _upcomingDueRows(List<StudentModel> students) {
  final dueStudents =
      students.where((student) => student.remainingFees > 0).toList()
        ..sort((a, b) {
          final aDate = a.nextPaymentDate ?? DateTime(9999);
          final bDate = b.nextPaymentDate ?? DateTime(9999);
          return aDate.compareTo(bDate);
        });

  return dueStudents.take(4).map((student) {
    return _InfoRow(
      student.fullName,
      _dueDateLabel(student.nextPaymentDate),
      student.remainingFeesText,
      _dueStatus(student),
    );
  }).toList();
}

Set<String> _presentStudentIdsToday(
  AttendanceProvider attendanceProvider,
  List<StudentModel> students,
) {
  final studentIds = students.map((student) => student.id).toSet();
  return attendanceProvider.attendanceRecords
      .where((record) {
        final date = record.attendanceDate;
        final now = DateTime.now();

        return record.isPresent &&
            date != null &&
            date.year == now.year &&
            date.month == now.month &&
            date.day == now.day &&
            studentIds.contains(record.studentId);
      })
      .map((record) => record.studentId)
      .toSet();
}

bool _isCourseEndingSoon(StudentModel student) {
  final startDate = student.startDate;
  final durationDays = _durationInDays(student.duration);
  if (startDate == null || durationDays == null) {
    return false;
  }

  final today = _dateOnly(DateTime.now());
  final endDate = _dateOnly(startDate.add(Duration(days: durationDays)));
  final nextWeek = today.add(const Duration(days: 7));
  return !endDate.isBefore(today) && !endDate.isAfter(nextWeek);
}

int? _durationInDays(String duration) {
  final value = int.tryParse(
    RegExp(r'\d+').firstMatch(duration)?.group(0) ?? '',
  );
  if (value == null) {
    return null;
  }

  final lowerDuration = duration.toLowerCase();
  if (lowerDuration.contains('month')) {
    return value * 30;
  }
  if (lowerDuration.contains('week')) {
    return value * 7;
  }
  return value;
}

String _dueStatus(StudentModel student) {
  final nextPaymentDate = student.nextPaymentDate;
  if (nextPaymentDate != null &&
      _dateOnly(nextPaymentDate).isBefore(_dateOnly(DateTime.now()))) {
    return 'Overdue';
  }

  return 'Pending';
}

String _dueDateLabel(DateTime? date) {
  if (date == null) {
    return 'No due date';
  }

  return 'Due ${_formatDate(date)}';
}

String _formatDate(DateTime? date) {
  if (date == null) {
    return '-';
  }

  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final day = date.day.toString().padLeft(2, '0');
  return '$day ${months[date.month - 1]} ${date.year}';
}

String _formatAmount(num value) {
  final amount =
      value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(2);
  return 'Rs $amount';
}

DateTime _dateOnly(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

class _MetricData {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _MetricData(
    this.title,
    this.value,
    this.subtitle,
    this.icon,
    this.color,
  );
}

class _InfoRow {
  final String title;
  final String subtitle;
  final String value;
  final String status;

  const _InfoRow(this.title, this.subtitle, this.value, this.status);
}
