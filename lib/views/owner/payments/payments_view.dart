import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_spacing.dart';
import '../../../utils/app_text_styles.dart';

class PaymentsView extends StatelessWidget {
  const PaymentsView({super.key});

  static const _payments = [
    _PaymentData(
      studentName: 'Amit Sharma',
      mobile: '+91 98765 11111',
      course: 'Beginner Driving',
      totalFees: 'Rs 5,000',
      paid: 'Rs 5,000',
      remaining: 'Rs 0',
      nextDueDate: 'Completed',
      status: 'Paid',
    ),
    _PaymentData(
      studentName: 'Neha Singh',
      mobile: '+91 98765 22222',
      course: 'Advanced Course',
      totalFees: 'Rs 8,000',
      paid: 'Rs 4,500',
      remaining: 'Rs 3,500',
      nextDueDate: '12 May 2026',
      status: 'Pending',
    ),
    _PaymentData(
      studentName: 'Vikram Patel',
      mobile: '+91 98765 33333',
      course: 'Licence Assistance',
      totalFees: 'Rs 4,500',
      paid: 'Rs 4,500',
      remaining: 'Rs 0',
      nextDueDate: 'Completed',
      status: 'Paid',
    ),
    _PaymentData(
      studentName: 'Priya Nair',
      mobile: '+91 98765 44444',
      course: 'Beginner Driving',
      totalFees: 'Rs 6,000',
      paid: 'Rs 2,000',
      remaining: 'Rs 4,000',
      nextDueDate: '05 May 2026',
      status: 'Overdue',
    ),
    _PaymentData(
      studentName: 'Rohan Das',
      mobile: '+91 98765 55555',
      course: 'Weekend Batch',
      totalFees: 'Rs 7,500',
      paid: 'Rs 3,000',
      remaining: 'Rs 4,500',
      nextDueDate: '18 May 2026',
      status: 'Pending',
    ),
    _PaymentData(
      studentName: 'Sara Khan',
      mobile: '+91 98765 66666',
      course: 'Advanced Course',
      totalFees: 'Rs 8,000',
      paid: 'Rs 1,500',
      remaining: 'Rs 6,500',
      nextDueDate: '02 May 2026',
      status: 'Overdue',
    ),
  ];

  static const _transactions = [
    _TransactionData('Amit Sharma', 'Rs 2,500', 'UPI', '08 May 2026', 'Paid'),
    _TransactionData('Vikram Patel', 'Rs 1,500', 'Cash', '07 May 2026', 'Paid'),
    _TransactionData('Neha Singh', 'Rs 2,000', 'Card', '06 May 2026', 'Paid'),
    _TransactionData('Rohan Das', 'Rs 1,000', 'UPI', '04 May 2026', 'Paid'),
  ];

  static const _reminders = [
    _ReminderData('Priya Nair', 'Rs 4,000'),
    _ReminderData('Sara Khan', 'Rs 6,500'),
    _ReminderData('Neha Singh', 'Rs 3,500'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBackground,
      appBar: AppBar(
        title: const Text('Payments'),
        backgroundColor: AppColors.card,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PageHeader(),
                SizedBox(height: AppSpacing.sectionX),
                _SummaryCardsRow(),
                SizedBox(height: AppSpacing.sectionX),
                _SearchAndFilters(),
                SizedBox(height: AppSpacing.sectionX),
                _PaymentsSection(payments: _payments),
                SizedBox(height: AppSpacing.sectionX),
                _SecondarySections(
                  transactions: _transactions,
                  reminders: _reminders,
                ),
                SizedBox(height: AppSpacing.sectionX),
                _AnalyticsSection(),
              ],
            ),
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
                    Text('Payments', style: AppTextStyles.sectionTitle),
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
      style: _filledButtonStyle(AppColors.primary),
    );
    final exportReport = OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.file_download_outlined),
      label: const Text('Export Report'),
      style: _outlinedButtonStyle(),
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
  const _SummaryCardsRow();

  @override
  Widget build(BuildContext context) {
    final cards = [
      const _SummaryData(
        'Total Collected',
        'Rs 1,48,500',
        Icons.account_balance_wallet_outlined,
        AppColors.ctaGreen,
      ),
      const _SummaryData(
        'Pending Amount',
        'Rs 42,500',
        Icons.receipt_long_outlined,
        AppColors.accent,
      ),
      const _SummaryData(
        'Payments This Month',
        '36',
        Icons.calendar_month_outlined,
        AppColors.primary,
      ),
      const _SummaryData(
        'Overdue Students',
        '8',
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
          final isNarrow = constraints.maxWidth < 560;

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
                    _FilterChip(label: 'Paid'),
                    _FilterChip(label: 'Pending'),
                    _FilterChip(label: 'Overdue'),
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

class _PaymentsSection extends StatelessWidget {
  final List<_PaymentData> payments;

  const _PaymentsSection({required this.payments});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
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
          headingTextStyle: const TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w900,
          ),
          dataTextStyle: const TextStyle(color: AppColors.textDark),
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
                        DataCell(_StatusBadge(status: payment.status)),
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
              Text(
                payment.studentName,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              _StatusBadge(status: payment.status),
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
              style: _filledButtonStyle(AppColors.primary),
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
      child: Column(
        children:
            transactions
                .map((transaction) => _TransactionTile(data: transaction))
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
        color: const Color(0xFFFFF7F7),
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
                      '${data.method} • ${data.date}',
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
              _StatusBadge(status: data.status),
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
      child: Column(
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
                style: _outlinedButtonStyle(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AnalyticsSection extends StatelessWidget {
  const _AnalyticsSection();

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Payment Analytics',
      icon: Icons.analytics_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _ProgressLine(
            label: 'Collected vs Remaining',
            valueLabel: '78% collected',
            value: 0.78,
          ),
          SizedBox(height: AppSpacing.xl),
          _ProgressLine(
            label: 'Monthly Collection Progress',
            valueLabel: 'Rs 1,48,500 of Rs 1,90,000',
            value: 0.72,
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
            backgroundColor: const Color(0xFFFFEBEE),
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

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color =
        status == 'Paid'
            ? AppColors.ctaGreen
            : status == 'Overdue'
            ? AppColors.darkRed
            : AppColors.accent;

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
