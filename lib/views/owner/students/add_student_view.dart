import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/payment_model.dart';
import '../../../models/student_prefill_model.dart';
import '../../../models/student_model.dart';
import '../../../providers/enquiry_provider.dart';
import '../../../providers/payment_provider.dart';
import '../../../providers/student_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_spacing.dart';
import '../../../utils/app_text_styles.dart';
import '../../../utils/student_form_validators.dart';

const _courseOptions = [
  'Beginner Driving',
  'Advanced Course',
  'Licence Assistance',
];

class AddStudentView extends StatefulWidget {
  const AddStudentView({super.key});

  @override
  State<AddStudentView> createState() => _AddStudentViewState();
}

class _AddStudentViewState extends State<AddStudentView> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _alternateMobileController = TextEditingController();
  final _areaVillageController = TextEditingController();
  final _addressController = TextEditingController();
  final _durationController = TextEditingController();
  final _startDateController = TextEditingController();
  final _totalFeesController = TextEditingController();
  final _advancePaidController = TextEditingController();
  final _remainingFeesController = TextEditingController(text: '0');
  final _nextPaymentDateController = TextEditingController();
  final _notesController = TextEditingController();
  String _course = 'Beginner Driving';
  String _preferredBatch = 'Morning Batch';
  StudentPrefillModel? _prefill;
  bool _didApplyPrefill = false;

  @override
  void initState() {
    super.initState();
    _totalFeesController.addListener(_updateRemainingFees);
    _advancePaidController.addListener(_updateRemainingFees);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didApplyPrefill) {
      return;
    }

    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is StudentPrefillModel) {
      _prefill = arguments;
      _fullNameController.text = arguments.fullName;
      _mobileController.text = arguments.mobileNumber;
      _notesController.text = arguments.notes;
      _course = _normalizeCourse(arguments.course);
    }

    _didApplyPrefill = true;
  }

  @override
  void dispose() {
    _totalFeesController.removeListener(_updateRemainingFees);
    _advancePaidController.removeListener(_updateRemainingFees);
    _fullNameController.dispose();
    _mobileController.dispose();
    _alternateMobileController.dispose();
    _areaVillageController.dispose();
    _addressController.dispose();
    _durationController.dispose();
    _startDateController.dispose();
    _totalFeesController.dispose();
    _advancePaidController.dispose();
    _remainingFeesController.dispose();
    _nextPaymentDateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _updateRemainingFees() {
    final totalFees = num.tryParse(_totalFeesController.text.trim()) ?? 0;
    final advancePaid = num.tryParse(_advancePaidController.text.trim()) ?? 0;
    final remainingFees = totalFees - advancePaid;
    final value = remainingFees < 0 ? 0 : remainingFees;
    final text = value % 1 == 0 ? value.toInt().toString() : value.toString();

    if (_remainingFeesController.text != text) {
      _remainingFeesController.text = text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: AppSpacing.ownerPagePadding.copyWith(
          bottom: 32 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSpacing.ownerCompactMaxContentWidth,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _PageHeader(),
                  const SizedBox(height: 14),
                  _StudentForm(
                    fullNameController: _fullNameController,
                    mobileController: _mobileController,
                    alternateMobileController: _alternateMobileController,
                    areaVillageController: _areaVillageController,
                    addressController: _addressController,
                    durationController: _durationController,
                    startDateController: _startDateController,
                    totalFeesController: _totalFeesController,
                    advancePaidController: _advancePaidController,
                    remainingFeesController: _remainingFeesController,
                    nextPaymentDateController: _nextPaymentDateController,
                    notesController: _notesController,
                    course: _course,
                    preferredBatch: _preferredBatch,
                    onCourseChanged: (value) {
                      if (value != null) {
                        setState(() => _course = value);
                      }
                    },
                    onPreferredBatchChanged: (value) {
                      if (value != null) {
                        setState(() => _preferredBatch = value);
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  _ActionBar(onCancel: _cancel, onSave: _saveStudent),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveStudent() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final totalFees = num.tryParse(_totalFeesController.text.trim()) ?? 0;
    final advancePaid = num.tryParse(_advancePaidController.text.trim()) ?? 0;
    final remainingFees = totalFees - advancePaid;
    final normalizedMobile = StudentFormValidators.normalizeIndianMobile(
      _mobileController.text,
    );
    final alternateMobile = _alternateMobileController.text.trim();
    final normalizedAlternateMobile =
        alternateMobile.isEmpty
            ? ''
            : StudentFormValidators.normalizeIndianMobile(alternateMobile);

    if (normalizedMobile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid mobile number.')),
      );
      return;
    }

    if (advancePaid > totalFees) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Advance paid cannot be greater than total fees.'),
        ),
      );
      return;
    }

    if (remainingFees < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Remaining fees cannot be negative.')),
      );
      return;
    }

    final studentProvider = context.read<StudentProvider>();
    final loadedStudents = await studentProvider.fetchStudents();

    if (!mounted) {
      return;
    }

    if (!loadedStudents) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            studentProvider.errorMessage ??
                'Unable to verify duplicate mobile number.',
          ),
        ),
      );
      return;
    }

    if (StudentFormValidators.hasDuplicateMobile(
      studentProvider.students,
      normalizedMobile,
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A student with this mobile number already exists.'),
        ),
      );
      return;
    }

    final student = StudentModel(
      id: '',
      fullName: _fullNameController.text.trim(),
      mobileNumber: normalizedMobile,
      alternateMobile: normalizedAlternateMobile ?? '',
      areaVillage: _areaVillageController.text.trim(),
      address: _addressController.text.trim(),
      course: _course,
      duration: _durationController.text.trim(),
      totalFees: totalFees,
      paidAmount: advancePaid,
      remainingFees: remainingFees < 0 ? 0 : remainingFees,
      status: remainingFees > 0 ? 'Pending Payment' : 'Active',
      preferredBatch: _preferredBatch,
      startDate: _parseDate(_startDateController.text.trim()),
      nextPaymentDate: _parseDate(_nextPaymentDateController.text.trim()),
      createdAt: null,
      updatedAt: null,
      notes: _notesController.text.trim(),
    );

    final paymentProvider = context.read<PaymentProvider>();
    final enquiryProvider = context.read<EnquiryProvider>();
    final success = await studentProvider.createStudent(student);

    if (!mounted) {
      return;
    }

    if (success) {
      final createdStudent = studentProvider.lastCreatedStudent;
      if (createdStudent != null && advancePaid > 0) {
        final paymentSaved = await paymentProvider.createPayment(
          PaymentModel(
            id: '',
            studentId: createdStudent.id,
            amount: advancePaid,
            paymentMethod: 'Cash',
            paymentDate: DateTime.now(),
            notes: 'Initial advance payment',
          ),
        );

        await studentProvider.fetchStudents();

        if (!mounted) {
          return;
        }

        if (!paymentSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                paymentProvider.errorMessage ??
                    'Student saved, but initial payment was not recorded.',
              ),
            ),
          );
          return;
        }
      }

      final sourceEnquiryId = _prefill?.sourceEnquiryId;
      if (sourceEnquiryId != null && sourceEnquiryId.isNotEmpty) {
        await enquiryProvider.updateEnquiryStatus(sourceEnquiryId, 'Converted');
      }

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student saved successfully.')),
      );
      final createdStudentId = studentProvider.lastCreatedStudent?.id ?? '';
      final route =
          _isEnquiryConversion && createdStudentId.isNotEmpty
              ? '/owner/students/${Uri.encodeComponent(createdStudentId)}'
              : AppRoutes.ownerStudents;
      Navigator.of(context).pushReplacementNamed(route);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          studentProvider.errorMessage ?? 'Unable to save student.',
        ),
      ),
    );
  }

  DateTime? _parseDate(String value) {
    if (value.isEmpty) {
      return null;
    }

    return DateTime.tryParse(value);
  }

  bool get _isEnquiryConversion =>
      _prefill?.sourceEnquiryId?.trim().isNotEmpty ?? false;

  void _cancel() {
    Navigator.of(context).pushReplacementNamed(
      _isEnquiryConversion ? AppRoutes.enquiries : AppRoutes.ownerStudents,
    );
  }

  String _normalizeCourse(String value) {
    final trimmed = value.trim();
    return switch (trimmed) {
      'Beginner Driving Course' => 'Beginner Driving',
      'Licence Assistance Course' => 'Licence Assistance',
      _ when _courseOptions.contains(trimmed) => trimmed,
      _ => _course,
    };
  }
}

class _ResponsiveButtonPair extends StatelessWidget {
  final Widget cancel;
  final Widget save;
  final bool isNarrow;

  const _ResponsiveButtonPair({
    required this.cancel,
    required this.save,
    required this.isNarrow,
  });

  @override
  Widget build(BuildContext context) {
    if (isNarrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [save, const SizedBox(height: AppSpacing.sm), cancel],
      );
    }

    return Wrap(
      alignment: WrapAlignment.end,
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.sm,
      children: [
        SizedBox(width: 150, child: cancel),
        SizedBox(width: 200, child: save),
      ],
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: _cardDecoration(),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Add Student', style: AppTextStyles.ownerPageTitle),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Create new student profile and fee structure.',
            style: AppTextStyles.sectionSubtitle,
          ),
        ],
      ),
    );
  }
}

class _StudentForm extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController mobileController;
  final TextEditingController alternateMobileController;
  final TextEditingController areaVillageController;
  final TextEditingController addressController;
  final TextEditingController durationController;
  final TextEditingController startDateController;
  final TextEditingController totalFeesController;
  final TextEditingController advancePaidController;
  final TextEditingController remainingFeesController;
  final TextEditingController nextPaymentDateController;
  final TextEditingController notesController;
  final String course;
  final String preferredBatch;
  final ValueChanged<String?> onCourseChanged;
  final ValueChanged<String?> onPreferredBatchChanged;

  const _StudentForm({
    required this.fullNameController,
    required this.mobileController,
    required this.alternateMobileController,
    required this.areaVillageController,
    required this.addressController,
    required this.durationController,
    required this.startDateController,
    required this.totalFeesController,
    required this.advancePaidController,
    required this.remainingFeesController,
    required this.nextPaymentDateController,
    required this.notesController,
    required this.course,
    required this.preferredBatch,
    required this.onCourseChanged,
    required this.onPreferredBatchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _FormSection(
          title: 'Basic Information',
          subtitle: 'Contact and address details used for daily follow-ups.',
          icon: Icons.person_outline,
          children: [
            _InputField(
              label: 'Full Name',
              icon: Icons.person_outline,
              controller: fullNameController,
              requiredField: true,
              validator: StudentFormValidators.validateName,
            ),
            _InputField(
              label: 'Mobile Number',
              icon: Icons.call_outlined,
              controller: mobileController,
              requiredField: true,
              keyboardType: TextInputType.phone,
              validator: StudentFormValidators.validateMobile,
            ),
            _InputField(
              label: 'Alternate Mobile',
              icon: Icons.phone_android_outlined,
              controller: alternateMobileController,
              helperText: 'Optional',
              keyboardType: TextInputType.phone,
              validator:
                  (value) => StudentFormValidators.validateMobile(
                    value,
                    required: false,
                  ),
            ),
            _InputField(
              label: 'Area / Village',
              icon: Icons.location_on_outlined,
              controller: areaVillageController,
            ),
            _InputField(
              label: 'Address',
              icon: Icons.home_outlined,
              controller: addressController,
              maxLines: 3,
              fullWidth: true,
            ),
          ],
        ),
        SizedBox(height: 14),
        _FormSection(
          title: 'Course Information',
          subtitle: 'Batch, duration, and preferred learning time.',
          icon: Icons.directions_car_outlined,
          children: [
            _CourseDropdown(value: course, onChanged: onCourseChanged),
            _InputField(
              label: 'Duration',
              icon: Icons.timer_outlined,
              controller: durationController,
              requiredField: true,
              keyboardType: TextInputType.number,
              validator: StudentFormValidators.validateDuration,
            ),
            _InputField(
              label: 'Start Date',
              icon: Icons.calendar_today_outlined,
              controller: startDateController,
              helperText: 'Example: 2026-05-08',
              keyboardType: TextInputType.datetime,
            ),
            _TimeSlotDropdown(
              value: preferredBatch,
              onChanged: onPreferredBatchChanged,
            ),
          ],
        ),
        SizedBox(height: 14),
        _FormSection(
          title: 'Payment Information',
          subtitle:
              'Track fees, advance amount, and the next payment reminder.',
          icon: Icons.payments_outlined,
          footer: _PaymentSummaryStrip(),
          children: [
            _InputField(
              label: 'Total Fees',
              icon: Icons.payments_outlined,
              controller: totalFeesController,
              requiredField: true,
              keyboardType: TextInputType.number,
              validator:
                  (value) => StudentFormValidators.validatePositiveAmount(
                    value,
                    'Total fees',
                  ),
            ),
            _InputField(
              label: 'Advance Paid',
              icon: Icons.account_balance_wallet_outlined,
              controller: advancePaidController,
              keyboardType: TextInputType.number,
              validator:
                  (value) => StudentFormValidators.validateNonNegativeAmount(
                    value?.trim().isEmpty ?? true ? '0' : value,
                    'Advance paid',
                  ),
            ),
            _InputField(
              label: 'Remaining Fees',
              icon: Icons.receipt_long_outlined,
              controller: remainingFeesController,
              readOnly: true,
              highlighted: true,
              helperText: 'Auto calculated from total fees and advance paid',
              validator:
                  (value) => StudentFormValidators.validateNonNegativeAmount(
                    value,
                    'Remaining fees',
                  ),
            ),
            _InputField(
              label: 'Next Payment Date',
              icon: Icons.event_available_outlined,
              controller: nextPaymentDateController,
              helperText: 'Optional reminder date',
              keyboardType: TextInputType.datetime,
            ),
          ],
        ),
        SizedBox(height: 14),
        _FormSection(
          title: 'Notes',
          subtitle: 'Useful preferences, pickup notes, or payment comments.',
          icon: Icons.notes_outlined,
          children: [
            _InputField(
              label: 'Notes',
              icon: Icons.notes_outlined,
              controller: notesController,
              maxLines: 4,
              fullWidth: true,
              helperText: 'Optional internal note',
            ),
          ],
        ),
      ],
    );
  }
}

class _FormSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Widget> children;
  final Widget? footer;

  const _FormSection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.children,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: title, subtitle: subtitle, icon: icon),
          const SizedBox(height: AppSpacing.md),
          Divider(color: Colors.black.withValues(alpha: 0.06), height: 1),
          const SizedBox(height: AppSpacing.xl),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 760;
              final gap = isWide ? AppSpacing.xl : AppSpacing.md;
              final fieldWidth =
                  isWide
                      ? (constraints.maxWidth - gap) / 2
                      : constraints.maxWidth;

              return Wrap(
                spacing: gap,
                runSpacing: AppSpacing.md,
                children:
                    children.map((child) {
                      if (child is _InputField && child.fullWidth) {
                        return SizedBox(
                          width: constraints.maxWidth,
                          child: child,
                        );
                      }
                      return SizedBox(width: fieldWidth, child: child);
                    }).toList(),
              );
            },
          ),
          if (footer != null) ...[
            const SizedBox(height: AppSpacing.xl),
            footer!,
          ],
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.ownerTint,
            borderRadius: AppSpacing.radiusMd,
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle,
                style: const TextStyle(height: 1.35, color: AppColors.textGray),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController? controller;
  final int maxLines;
  final bool fullWidth;
  final bool readOnly;
  final bool highlighted;
  final bool requiredField;
  final String? helperText;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;

  const _InputField({
    required this.label,
    required this.icon,
    this.controller,
    this.maxLines = 1,
    this.fullWidth = false,
    this.readOnly = false,
    this.highlighted = false,
    this.requiredField = false,
    this.helperText,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: AppColors.textDark,
        fontWeight: FontWeight.w600,
      ),
      validator: (value) {
        final customError = validator?.call(value);
        if (customError != null) {
          return customError;
        }
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
        fillColor: highlighted ? const Color(0xFFFFF3E0) : Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.radiusMd,
          borderSide: BorderSide(
            color: highlighted ? AppColors.accent : AppColors.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.radiusMd,
          borderSide: BorderSide(
            color: highlighted ? AppColors.accent : AppColors.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

class _CourseDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const _CourseDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Course',
        prefixIcon: Icon(Icons.directions_car_outlined),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
      ),
      items: [
        for (final course in _courseOptions)
          DropdownMenuItem(value: course, child: Text(course)),
      ],
      onChanged: onChanged,
    );
  }
}

class _TimeSlotDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const _TimeSlotDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Preferred Time Slot',
        prefixIcon: Icon(Icons.schedule_outlined),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
      ),
      items: const [
        DropdownMenuItem(value: 'Morning Batch', child: Text('Morning Batch')),
        DropdownMenuItem(
          value: 'Afternoon Batch',
          child: Text('Afternoon Batch'),
        ),
        DropdownMenuItem(value: 'Evening Batch', child: Text('Evening Batch')),
        DropdownMenuItem(value: 'Weekend Batch', child: Text('Weekend Batch')),
      ],
      onChanged: onChanged,
    );
  }
}

class _PaymentSummaryStrip extends StatelessWidget {
  const _PaymentSummaryStrip();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.ownerCardTint,
        borderRadius: AppSpacing.radiusLg,
        border: Border.all(color: AppColors.border),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 640;
          final itemWidth =
              isWide
                  ? (constraints.maxWidth - (AppSpacing.md * 2)) / 3
                  : constraints.maxWidth;

          return Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: [
              _PaymentSummaryItem(
                width: itemWidth,
                label: 'Total',
                value: 'Rs 5,000',
              ),
              _PaymentSummaryItem(
                width: itemWidth,
                label: 'Paid',
                value: 'Rs 2,000',
              ),
              _PaymentSummaryItem(
                width: itemWidth,
                label: 'Remaining',
                value: 'Rs 3,000',
                highlighted: true,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PaymentSummaryItem extends StatelessWidget {
  final double width;
  final String label;
  final String value;
  final bool highlighted;

  const _PaymentSummaryItem({
    required this.width,
    required this.label,
    required this.value,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: highlighted ? const Color(0xFFFFF3E0) : Colors.white,
          borderRadius: AppSpacing.radiusMd,
          border: Border.all(
            color: highlighted ? AppColors.accent : AppColors.border,
          ),
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
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const _ActionBar({required this.onCancel, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppSpacing.ownerCardRadius,
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: _ActionButtons(onCancel: onCancel, onSave: onSave),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const _ActionButtons({required this.onCancel, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 520;
        final cancel = OutlinedButton.icon(
          onPressed: onCancel,
          icon: const Icon(Icons.close),
          label: const Text('Cancel'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textDark,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
            minimumSize: const Size(0, 44),
            shape: const RoundedRectangleBorder(
              borderRadius: AppSpacing.radiusMd,
            ),
          ),
        );
        final isLoading = context.watch<StudentProvider>().isLoading;
        final save = FilledButton.icon(
          onPressed: isLoading ? null : onSave,
          icon:
              isLoading
                  ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : const Icon(Icons.save_outlined),
          label: Text(isLoading ? 'Saving...' : 'Save Student'),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
            minimumSize: const Size(0, 44),
            textStyle: AppTextStyles.button,
            shape: const RoundedRectangleBorder(
              borderRadius: AppSpacing.radiusMd,
            ),
          ),
        );

        return _ResponsiveButtonPair(
          cancel: cancel,
          save: save,
          isNarrow: isNarrow,
        );
      },
    );
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: AppColors.card,
    borderRadius: AppSpacing.ownerCardRadius,
    border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.045),
        blurRadius: 18,
        offset: const Offset(0, 8),
      ),
    ],
  );
}
