import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/payment_model.dart';
import '../../../models/student_model.dart';
import '../../../providers/payment_provider.dart';
import '../../../providers/student_provider.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_spacing.dart';
import '../../../utils/app_text_styles.dart';
import '../../../widgets/owner/owner_action_button.dart';
import '../../../widgets/owner/owner_search_filter_bar.dart';
import '../../../widgets/owner/owner_section_card.dart';
import '../../../widgets/owner/owner_stat_card.dart';
import '../../../widgets/owner/owner_status_badge.dart';

class PaymentsView extends StatefulWidget {
  const PaymentsView({super.key});

  @override
  State<PaymentsView> createState() => _PaymentsViewState();
}

class _PaymentsViewState extends State<PaymentsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentProvider>().fetchPayments();
      context.read<StudentProvider>().fetchStudents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.ownerPagePadding,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.ownerMaxContentWidth,
          ),
          child: Consumer2<PaymentProvider, StudentProvider>(
            builder: (context, paymentProvider, studentProvider, child) {
              final payments = paymentProvider.payments;
              final students = studentProvider.students;
              final paymentRows = _buildPaymentRows(students);
              final transactions = _buildTransactions(payments, students);
              final reminders = _buildReminders(students);
              final summary = _SummaryTotals.fromData(payments, students);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _PageHeader(),
                  const SizedBox(height: AppSpacing.sectionX),
                  _SummaryCardsRow(summary: summary),
                  const SizedBox(height: AppSpacing.sectionX),
                  const OwnerSearchFilterBar(
                    hintText: 'Search by student name or mobile',
                    filters: ['All', 'Paid', 'Pending', 'Overdue'],
                  ),
                  const SizedBox(height: AppSpacing.sectionX),
                  if (paymentProvider.isLoading || studentProvider.isLoading)
                    const _LoadingState()
                  else if (paymentProvider.errorMessage != null)
                    _MessageState(message: paymentProvider.errorMessage!)
                  else if (studentProvider.errorMessage != null)
                    _MessageState(message: studentProvider.errorMessage!)
                  else
                    _PaymentsSection(payments: paymentRows),
                  const SizedBox(height: AppSpacing.sectionX),
                  _SecondarySections(
                    transactions: transactions,
                    reminders: reminders,
                  ),
                  const SizedBox(height: AppSpacing.sectionX),
                  _AnalyticsSection(summary: summary),
                ],
              );
            },
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
          final isNarrow = constraints.maxWidth < 640;

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
                        : constraints.maxWidth - 330,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Payments', style: AppTextStyles.ownerPageTitle),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      'Track pending fees, completed payments, and reminders.',
                      style: AppTextStyles.sectionSubtitle,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: isNarrow ? constraints.maxWidth : 300,
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
    final addPayment = FilledButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.add_card_outlined),
      label: const Text('Add Payment'),
      style: OwnerActionButton.filledStyle(AppColors.primary),
    );
    final exportReport = OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.file_download_outlined),
      label: const Text('Export Report'),
      style: OwnerActionButton.outlinedStyle(),
    );

    if (isNarrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          addPayment,
          const SizedBox(height: AppSpacing.sm),
          exportReport,
        ],
      );
    }

    return Wrap(
      alignment: WrapAlignment.end,
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.sm,
      children: [
        SizedBox(width: 138, child: addPayment),
        SizedBox(width: 150, child: exportReport),
      ],
    );
  }
}

class _SummaryCardsRow extends StatelessWidget {
  final _SummaryTotals summary;

  const _SummaryCardsRow({required this.summary});

  @override
  Widget build(BuildContext context) {
    final cards = [
      _SummaryData(
        'Total Collected',
        _formatAmount(summary.totalCollected),
        Icons.account_balance_wallet_outlined,
        AppColors.ctaGreen,
      ),
      _SummaryData(
        'Pending Amount',
        _formatAmount(summary.pendingAmount),
        Icons.receipt_long_outlined,
        AppColors.accent,
      ),
      _SummaryData(
        'Payments This Month',
        summary.paymentsThisMonth.toString(),
        Icons.calendar_month_outlined,
        AppColors.primary,
      ),
      _SummaryData(
        'Overdue Students',
        summary.overdueStudents.toString(),
        Icons.alarm_outlined,
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
                  .map(
                    (card) => SizedBox(
                      width: cardWidth,
                      child: OwnerStatCard(
                        width: double.infinity,
                        title: card.label,
                        value: card.value,
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

class _PaymentsSection extends StatelessWidget {
  final List<_PaymentData> payments;

  const _PaymentsSection({required this.payments});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (payments.isEmpty) {
          return const _MessageState(message: 'No payment records found.');
        }

        if (constraints.maxWidth >= 980) {
          return _PaymentsTable(payments: payments);
        }

        return _PaymentCardsList(payments: payments);
      },
    );
  }
}

class _PaymentsTable extends StatelessWidget {
  final List<_PaymentData> payments;

  const _PaymentsTable({required this.payments});

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingTextStyle: AppTextStyles.tableHeader,
          dataTextStyle: AppTextStyles.tableBody,
          headingRowHeight: AppSpacing.tableHeadingRowHeight,
          dataRowMinHeight: AppSpacing.tableDataRowMinHeight,
          dataRowMaxHeight: AppSpacing.tableDataRowMaxHeight,
          columns: const [
            DataColumn(label: Text('Student Name')),
            DataColumn(label: Text('Course')),
            DataColumn(label: Text('Total Fees')),
            DataColumn(label: Text('Paid')),
            DataColumn(label: Text('Remaining')),
            DataColumn(label: Text('Next Due Date')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Actions')),
          ],
          rows:
              payments
                  .map(
                    (payment) => DataRow(
                      cells: [
                        DataCell(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                payment.studentName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                payment.mobile,
                                style: const TextStyle(
                                  color: AppColors.textGray,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(Text(payment.course)),
                        DataCell(Text(payment.totalFees)),
                        DataCell(Text(payment.paid)),
                        DataCell(Text(payment.remaining)),
                        DataCell(Text(payment.nextDueDate)),
                        DataCell(OwnerStatusBadge(status: payment.status)),
                        DataCell(
                          IconButton(
                            tooltip: 'Record payment',
                            onPressed: () {},
                            icon: const Icon(Icons.add_card_outlined),
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

class _PaymentCardsList extends StatelessWidget {
  final List<_PaymentData> payments;

  const _PaymentCardsList({required this.payments});

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          payments
              .map(
                (payment) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                  child: _PaymentCard(payment: payment),
                ),
              )
              .toList(),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  final _PaymentData payment;

  const _PaymentCard({required this.payment});

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
              Text(payment.studentName, style: AppTextStyles.ownerCardTitle),
              OwnerStatusBadge(status: payment.status),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            payment.mobile,
            style: const TextStyle(color: AppColors.textGray),
          ),
          const SizedBox(height: AppSpacing.md),
          _InfoLine('Course', payment.course),
          _InfoLine('Total Fees', payment.totalFees),
          _InfoLine('Paid', payment.paid),
          _InfoLine('Remaining', payment.remaining),
          _InfoLine('Next Due Date', payment.nextDueDate),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_card_outlined),
              label: const Text('Record'),
              style: OwnerActionButton.filledStyle(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _SecondarySections extends StatelessWidget {
  final List<_TransactionData> transactions;
  final List<_ReminderData> reminders;

  const _SecondarySections({
    required this.transactions,
    required this.reminders,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 920;
        final transactionsCard = _RecentTransactions(
          transactions: transactions,
        );
        final remindersCard = _ReminderSection(reminders: reminders);

        if (!isWide) {
          return Column(
            children: [
              transactionsCard,
              const SizedBox(height: AppSpacing.sectionX),
              remindersCard,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: transactionsCard),
            const SizedBox(width: AppSpacing.sectionX),
            Expanded(child: remindersCard),
          ],
        );
      },
    );
  }
}

class _RecentTransactions extends StatelessWidget {
  final List<_TransactionData> transactions;

  const _RecentTransactions({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Recent Transactions',
      icon: Icons.history_outlined,
      child:
          transactions.isEmpty
              ? const _EmptyMessage(message: 'No recent transactions found.')
              : Column(
                children:
                    transactions
                        .map(
                          (transaction) => _TransactionTile(data: transaction),
                        )
                        .toList(),
              ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final _TransactionData data;

  const _TransactionTile({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.ownerCardTint,
        borderRadius: AppSpacing.radiusMd,
        border: Border.all(color: AppColors.border),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 520;

          return Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: isNarrow ? constraints.maxWidth : 220,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.studentName,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${data.method} - ${data.date}',
                      style: const TextStyle(color: AppColors.textGray),
                    ),
                  ],
                ),
              ),
              Text(
                data.amount,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w900,
                ),
              ),
              OwnerStatusBadge(status: data.status),
            ],
          );
        },
      ),
    );
  }
}

class _ReminderSection extends StatelessWidget {
  final List<_ReminderData> reminders;

  const _ReminderSection({required this.reminders});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Payment Reminders',
      icon: Icons.notifications_active_outlined,
      child:
          reminders.isEmpty
              ? const _EmptyMessage(message: 'No reminders yet.')
              : Column(
                children:
                    reminders
                        .map((reminder) => _ReminderTile(reminder: reminder))
                        .toList(),
              ),
    );
  }
}

class _ReminderTile extends StatelessWidget {
  final _ReminderData reminder;

  const _ReminderTile({required this.reminder});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 360;

          return Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: isNarrow ? constraints.maxWidth : 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder.studentName,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      reminder.dueAmount,
                      style: const TextStyle(color: AppColors.textGray),
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.alarm_outlined, size: 18),
                label: const Text('Reminder'),
                style: OwnerActionButton.outlinedStyle(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AnalyticsSection extends StatelessWidget {
  final _SummaryTotals summary;

  const _AnalyticsSection({required this.summary});

  @override
  Widget build(BuildContext context) {
    final totalFees = summary.totalCollected + summary.pendingAmount;
    final collectedProgress =
        totalFees == 0 ? 0.0 : (summary.totalCollected / totalFees);

    return _SectionCard(
      title: 'Payment Analytics',
      icon: Icons.analytics_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProgressLine(
            label: 'Collected vs Remaining',
            valueLabel: '${(collectedProgress * 100).round()}% collected',
            value: collectedProgress.clamp(0, 1).toDouble(),
          ),
          const SizedBox(height: AppSpacing.xl),
          _ProgressLine(
            label: 'Monthly Collection Progress',
            valueLabel: '${summary.paymentsThisMonth} payments this month',
            value: summary.paymentsThisMonth == 0 ? 0.0 : 1.0,
          ),
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
            backgroundColor: AppColors.ownerTint,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ],
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
    return OwnerSectionCard(title: title, icon: icon, child: child);
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
            children: [
              SizedBox(
                width: 112,
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

class _SoftCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius radius;

  const _SoftCard({
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.card),
    this.radius = AppSpacing.ownerCardRadius,
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

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const _SoftCard(child: Center(child: CircularProgressIndicator()));
  }
}

class _MessageState extends StatelessWidget {
  final String message;

  const _MessageState({required this.message});

  @override
  Widget build(BuildContext context) {
    return _SoftCard(child: _EmptyMessage(message: message));
  }
}

class _EmptyMessage extends StatelessWidget {
  final String message;

  const _EmptyMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: const TextStyle(
        color: AppColors.textGray,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

List<_PaymentData> _buildPaymentRows(List<StudentModel> students) {
  final today = DateTime.now();

  return students.map((student) {
    return _PaymentData(
      studentName: student.fullName,
      mobile: student.mobileNumber,
      course: student.course,
      totalFees: student.totalFeesText,
      paid: student.paidAmountText,
      remaining: student.remainingFeesText,
      nextDueDate: _dueDateText(student.nextPaymentDate),
      status: _paymentStatus(student, today),
    );
  }).toList();
}

List<_TransactionData> _buildTransactions(
  List<PaymentModel> payments,
  List<StudentModel> students,
) {
  final studentsById = {for (final student in students) student.id: student};

  return payments.map((payment) {
    final student = studentsById[payment.studentId];

    return _TransactionData(
      student?.fullName ?? 'Unknown Student',
      payment.amountText,
      payment.paymentMethod.isEmpty ? '-' : payment.paymentMethod,
      _formatDate(payment.paymentDate),
      'Paid',
    );
  }).toList();
}

List<_ReminderData> _buildReminders(List<StudentModel> students) {
  return students
      .where((student) => student.remainingFees > 0)
      .map(
        (student) => _ReminderData(student.fullName, student.remainingFeesText),
      )
      .toList();
}

String _paymentStatus(StudentModel student, DateTime today) {
  if (student.remainingFees <= 0) {
    return 'Paid';
  }

  final dueDate = student.nextPaymentDate;
  if (dueDate != null && _dateOnly(dueDate).isBefore(_dateOnly(today))) {
    return 'Overdue';
  }

  return 'Pending';
}

String _dueDateText(DateTime? date) {
  if (date == null) {
    return '-';
  }

  return _formatDate(date);
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
  final month = months[date.month - 1];
  return '$day $month ${date.year}';
}

String _formatAmount(num value) {
  final amount =
      value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(2);
  return 'Rs $amount';
}

DateTime _dateOnly(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

class _SummaryTotals {
  final num totalCollected;
  final num pendingAmount;
  final int paymentsThisMonth;
  final int overdueStudents;

  const _SummaryTotals({
    required this.totalCollected,
    required this.pendingAmount,
    required this.paymentsThisMonth,
    required this.overdueStudents,
  });

  factory _SummaryTotals.fromData(
    List<PaymentModel> payments,
    List<StudentModel> students,
  ) {
    final now = DateTime.now();
    final today = _dateOnly(now);
    final totalCollected = payments.fold<num>(
      0,
      (total, payment) => total + payment.amount,
    );
    final pendingAmount = students.fold<num>(
      0,
      (total, student) => total + student.remainingFees,
    );
    final paymentsThisMonth =
        payments.where((payment) {
          final date = payment.paymentDate;
          return date != null &&
              date.year == now.year &&
              date.month == now.month;
        }).length;
    final overdueStudents =
        students.where((student) {
          final dueDate = student.nextPaymentDate;
          return student.remainingFees > 0 &&
              dueDate != null &&
              _dateOnly(dueDate).isBefore(today);
        }).length;

    return _SummaryTotals(
      totalCollected: totalCollected,
      pendingAmount: pendingAmount,
      paymentsThisMonth: paymentsThisMonth,
      overdueStudents: overdueStudents,
    );
  }
}

class _PaymentData {
  final String studentName;
  final String mobile;
  final String course;
  final String totalFees;
  final String paid;
  final String remaining;
  final String nextDueDate;
  final String status;

  const _PaymentData({
    required this.studentName,
    required this.mobile,
    required this.course,
    required this.totalFees,
    required this.paid,
    required this.remaining,
    required this.nextDueDate,
    required this.status,
  });
}

class _TransactionData {
  final String studentName;
  final String amount;
  final String method;
  final String date;
  final String status;

  const _TransactionData(
    this.studentName,
    this.amount,
    this.method,
    this.date,
    this.status,
  );
}

class _ReminderData {
  final String studentName;
  final String dueAmount;

  const _ReminderData(this.studentName, this.dueAmount);
}

class _SummaryData {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryData(this.label, this.value, this.icon, this.color);
}
