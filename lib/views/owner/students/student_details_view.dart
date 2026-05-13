import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/payment_model.dart';
import '../../../models/student_model.dart';
import '../../../providers/payment_provider.dart';
import '../../../providers/student_provider.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_spacing.dart';
import '../../../utils/app_text_styles.dart';

class StudentDetailsView extends StatefulWidget {
  final String studentId;

  const StudentDetailsView({super.key, required this.studentId});

  @override
  State<StudentDetailsView> createState() => _StudentDetailsViewState();
}

class _StudentDetailsViewState extends State<StudentDetailsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudentProvider>().fetchStudentById(widget.studentId);
      context.read<PaymentProvider>().fetchPaymentsByStudentId(
        widget.studentId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.ownerPagePadding,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.ownerCompactMaxContentWidth,
          ),
          child: Consumer2<StudentProvider, PaymentProvider>(
            builder: (context, studentProvider, paymentProvider, child) {
              if (studentProvider.isLoading) {
                return const _StateCard(
                  icon: Icons.hourglass_empty,
                  message: 'Loading student details...',
                  showLoader: true,
                );
              }

              if (studentProvider.errorMessage != null) {
                return _StateCard(
                  icon: Icons.error_outline,
                  message: studentProvider.errorMessage!,
                );
              }

              final selectedStudent = studentProvider.selectedStudent;
              if (selectedStudent == null) {
                return const _StateCard(
                  icon: Icons.person_off_outlined,
                  message: 'Student details not found.',
                );
              }

              final student = _StudentDetails.fromStudent(selectedStudent);
              final payments =
                  paymentProvider.payments
                      .map(_PaymentRecord.fromPayment)
                      .toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeaderSection(student: student, studentId: widget.studentId),
                  const SizedBox(height: AppSpacing.sectionX),
                  _QuickStatsRow(student: student),
                  const SizedBox(height: AppSpacing.sectionX),
                  _MainSections(
                    student: student,
                    payments: payments,
                    isPaymentLoading: paymentProvider.isLoading,
                    paymentErrorMessage: paymentProvider.errorMessage,
                  ),
                  const SizedBox(height: AppSpacing.sectionX),
                  const _BottomActions(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _StateCard extends StatelessWidget {
  final IconData icon;
  final String message;
  final bool showLoader;

  const _StateCard({
    required this.icon,
    required this.message,
    this.showLoader = false,
  });

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      child: Center(
        child: Column(
          children: [
            if (showLoader)
              const CircularProgressIndicator()
            else
              Icon(icon, color: AppColors.primary, size: 34),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: const TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final _StudentDetails student;
  final String studentId;

  const _HeaderSection({required this.student, required this.studentId});

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
                      backgroundColor: AppColors.ownerTint,
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
                          Text(
                            student.name,
                            style: AppTextStyles.ownerPageTitle,
                          ),
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
                child: _HeaderActions(isNarrow: isNarrow, studentId: studentId),
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
  final String studentId;

  const _HeaderActions({required this.isNarrow, required this.studentId});

  @override
  Widget build(BuildContext context) {
    final edit = OutlinedButton.icon(
      onPressed: () {
        Navigator.of(
          context,
        ).pushNamed('/owner/students/${Uri.encodeComponent(studentId)}/edit');
      },
      icon: const Icon(Icons.edit_outlined),
      label: const Text('Edit Student'),
      style: _outlinedButtonStyle(),
    );
    final payment = FilledButton.icon(
      onPressed: () => _showRecordPaymentDialog(context, studentId),
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

Future<void> _showRecordPaymentDialog(
  BuildContext context,
  String studentId,
) async {
  await showDialog<void>(
    context: context,
    builder: (context) => _RecordPaymentDialog(studentId: studentId),
  );
}

class _RecordPaymentDialog extends StatefulWidget {
  final String studentId;

  const _RecordPaymentDialog({required this.studentId});

  @override
  State<_RecordPaymentDialog> createState() => _RecordPaymentDialogState();
}

class _RecordPaymentDialogState extends State<_RecordPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _paymentDateController = TextEditingController(
    text: DateTime.now().toIso8601String().split('T').first,
  );
  final _notesController = TextEditingController();
  String _paymentMethod = 'Cash';

  @override
  void dispose() {
    _amountController.dispose();
    _paymentDateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<PaymentProvider>().isLoading;

    return AlertDialog(
      title: const Text('Record Payment'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _PaymentInputField(
                label: 'Amount',
                icon: Icons.payments_outlined,
                controller: _amountController,
                keyboardType: TextInputType.number,
                requiredField: true,
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                value: _paymentMethod,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                  prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                  DropdownMenuItem(value: 'UPI', child: Text('UPI')),
                  DropdownMenuItem(value: 'Card', child: Text('Card')),
                  DropdownMenuItem(
                    value: 'Bank Transfer',
                    child: Text('Bank Transfer'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _paymentMethod = value);
                  }
                },
              ),
              const SizedBox(height: AppSpacing.md),
              _PaymentInputField(
                label: 'Payment Date',
                icon: Icons.calendar_today_outlined,
                controller: _paymentDateController,
                helperText: 'Example: 2026-05-13',
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: AppSpacing.md),
              _PaymentInputField(
                label: 'Notes',
                icon: Icons.notes_outlined,
                controller: _notesController,
                maxLines: 3,
                helperText: 'Optional',
              ),
            ],
          ),
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: isLoading ? null : _savePayment,
          icon:
              isLoading
                  ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : const Icon(Icons.save_outlined),
          label: Text(isLoading ? 'Saving...' : 'Save Payment'),
        ),
      ],
    );
  }

  Future<void> _savePayment() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final amount = num.tryParse(_amountController.text.trim()) ?? 0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Amount must be greater than 0.')),
      );
      return;
    }

    final payment = PaymentModel(
      id: '',
      studentId: widget.studentId,
      amount: amount,
      paymentMethod: _paymentMethod,
      paymentDate: _parseDate(_paymentDateController.text.trim()),
      notes: _notesController.text.trim(),
    );

    final provider = context.read<PaymentProvider>();
    final success = await provider.createPayment(payment);

    if (!mounted) {
      return;
    }

    if (success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment recorded successfully.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(provider.errorMessage ?? 'Unable to save payment.'),
      ),
    );
  }

  DateTime? _parseDate(String value) {
    if (value.isEmpty) {
      return null;
    }

    return DateTime.tryParse(value);
  }
}

class _PaymentInputField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final int maxLines;
  final bool requiredField;
  final String? helperText;
  final TextInputType? keyboardType;

  const _PaymentInputField({
    required this.label,
    required this.icon,
    required this.controller,
    this.maxLines = 1,
    this.requiredField = false,
    this.helperText,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) {
        if (requiredField && (value == null || value.trim().isEmpty)) {
          return '$label is required';
        }

        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
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
                color: AppColors.ownerTint,
                borderRadius: AppSpacing.radiusMd,
              ),
              child: Icon(stat.icon, color: AppColors.primary),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(stat.value, style: AppTextStyles.ownerMetricValue),
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
  final bool isPaymentLoading;
  final String? paymentErrorMessage;

  const _MainSections({
    required this.student,
    required this.payments,
    required this.isPaymentLoading,
    required this.paymentErrorMessage,
  });

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
            _PaymentHistorySection(
              payments: payments,
              isLoading: isPaymentLoading,
              errorMessage: paymentErrorMessage,
            ),
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
  final bool isLoading;
  final String? errorMessage;

  const _PaymentHistorySection({
    required this.payments,
    required this.isLoading,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Payment History',
      icon: Icons.account_balance_wallet_outlined,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (isLoading) {
            return const _InlineLoadingMessage(
              message: 'Loading payment history...',
            );
          }

          if (errorMessage != null) {
            return _EmptySectionMessage(message: errorMessage!);
          }

          if (payments.isEmpty) {
            return const _EmptySectionMessage(
              message: 'No payment records found.',
            );
          }

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
              headingTextStyle: AppTextStyles.tableHeader,
              dataTextStyle: AppTextStyles.tableBody,
              headingRowHeight: AppSpacing.tableHeadingRowHeight,
              dataRowMinHeight: AppSpacing.tableDataRowMinHeight,
              dataRowMaxHeight: AppSpacing.tableDataRowMaxHeight,
              columns: const [
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Amount')),
                DataColumn(label: Text('Method')),
                DataColumn(label: Text('Notes')),
              ],
              rows:
                  payments
                      .map(
                        (payment) => DataRow(
                          cells: [
                            DataCell(Text(payment.date)),
                            DataCell(Text(payment.amount)),
                            DataCell(Text(payment.method)),
                            DataCell(Text(payment.notes)),
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
            child: LinearProgressIndicator(
              value: student.attendanceProgress,
              minHeight: 10,
              backgroundColor: AppColors.ownerTint,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
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
      child:
          notes.isEmpty
              ? const _EmptySectionMessage(message: 'No notes added.')
              : Text(
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

class _EmptySectionMessage extends StatelessWidget {
  final String message;

  const _EmptySectionMessage({required this.message});

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

class _InlineLoadingMessage extends StatelessWidget {
  final String message;

  const _InlineLoadingMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(
              color: AppColors.textGray,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
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
              Expanded(child: Text(title, style: AppTextStyles.ownerCardTitle)),
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
        color: AppColors.ownerCardTint,
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
              Text(
                payment.method,
                style: const TextStyle(
                  color: AppColors.textGray,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            payment.amount,
            style: const TextStyle(color: AppColors.textGray),
          ),
          if (payment.notes.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              payment.notes,
              style: const TextStyle(color: AppColors.textGray),
            ),
          ],
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
        color: AppColors.ownerCardTint,
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
        color: AppColors.ownerCardTint,
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

ButtonStyle _filledButtonStyle(Color color) {
  return FilledButton.styleFrom(
    backgroundColor: color,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
    minimumSize: const Size(0, 44),
    textStyle: AppTextStyles.button,
    shape: const RoundedRectangleBorder(borderRadius: AppSpacing.radiusMd),
  );
}

ButtonStyle _outlinedButtonStyle() {
  return OutlinedButton.styleFrom(
    foregroundColor: AppColors.textDark,
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
    minimumSize: const Size(0, 44),
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
  final double attendanceProgress;
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
    required this.attendanceProgress,
    required this.classesAttended,
    required this.missedClasses,
    required this.notes,
  });

  factory _StudentDetails.fromStudent(StudentModel student) {
    return _StudentDetails(
      initials: _initialsFor(student.fullName),
      name: _valueOrDash(student.fullName),
      course: _valueOrDash(student.course),
      status: student.displayStatus,
      mobile: _valueOrDash(student.mobileNumber),
      alternateMobile: _valueOrDash(student.alternateMobile),
      area: _valueOrDash(student.areaVillage),
      address: _valueOrDash(student.address),
      startDate: _formatDate(student.startDate),
      duration: _valueOrDash(student.duration),
      preferredBatch: _valueOrDash(student.preferredBatch),
      totalFees: student.totalFeesText,
      paidAmount: student.paidAmountText,
      remainingFees: student.remainingFeesText,
      attendancePercent: '0%',
      attendanceProgress: 0,
      classesAttended: '0',
      missedClasses: '0',
      notes: student.notes.trim(),
    );
  }
}

String _initialsFor(String name) {
  final words = name.trim().split(RegExp(r'\s+'));
  final initials =
      words
          .where((word) => word.isNotEmpty)
          .take(2)
          .map((word) => word[0].toUpperCase())
          .join();

  return initials.isEmpty ? '?' : initials;
}

String _valueOrDash(String value) {
  final trimmedValue = value.trim();
  return trimmedValue.isEmpty ? '-' : trimmedValue;
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

class _PaymentRecord {
  final String date;
  final String amount;
  final String method;
  final String notes;

  const _PaymentRecord(this.date, this.amount, this.method, this.notes);

  factory _PaymentRecord.fromPayment(PaymentModel payment) {
    return _PaymentRecord(
      _formatDate(payment.paymentDate),
      payment.amountText,
      _valueOrDash(payment.paymentMethod),
      payment.notes.trim(),
    );
  }
}

class _StatData {
  final String label;
  final String value;
  final IconData icon;

  const _StatData(this.label, this.value, this.icon);
}
