import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/student_model.dart';
import '../../../providers/student_provider.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_spacing.dart';
import '../../../utils/app_text_styles.dart';
import '../../../utils/student_form_validators.dart';

class EditStudentView extends StatefulWidget {
  final String studentId;

  const EditStudentView({super.key, required this.studentId});

  @override
  State<EditStudentView> createState() => _EditStudentViewState();
}

class _EditStudentViewState extends State<EditStudentView> {
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
  final _remainingFeesController = TextEditingController();
  final _nextPaymentDateController = TextEditingController();
  final _notesController = TextEditingController();
  String _course = 'Beginner Driving';
  String _preferredBatch = 'Morning Batch';
  String _status = 'Active';
  bool _hasLoadedStudent = false;

  @override
  void initState() {
    super.initState();
    _totalFeesController.addListener(_updateRemainingFees);
    _advancePaidController.addListener(_updateRemainingFees);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadStudent());
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
    final text = _formatAmount(value);

    if (_remainingFeesController.text != text) {
      _remainingFeesController.text = text;
    }
  }

  Future<void> _loadStudent() async {
    final provider = context.read<StudentProvider>();
    final success = await provider.fetchStudentById(widget.studentId);

    if (!mounted || !success || provider.selectedStudent == null) {
      return;
    }

    _fillForm(provider.selectedStudent!);
  }

  void _fillForm(StudentModel student) {
    _fullNameController.text = student.fullName;
    _mobileController.text = student.mobileNumber;
    _alternateMobileController.text = student.alternateMobile;
    _areaVillageController.text = student.areaVillage;
    _addressController.text = student.address;
    _durationController.text = student.duration;
    _startDateController.text = _formatDate(student.startDate);
    _totalFeesController.text = _formatAmount(student.totalFees);
    _advancePaidController.text = _formatAmount(student.paidAmount);
    _remainingFeesController.text = _formatAmount(student.remainingFees);
    _nextPaymentDateController.text = _formatDate(student.nextPaymentDate);
    _notesController.text = student.notes;
    setState(() {
      _course = student.course.trim().isEmpty ? _course : student.course;
      _preferredBatch =
          student.preferredBatch.trim().isEmpty
              ? _preferredBatch
              : student.preferredBatch;
      _status = student.status.trim().isEmpty ? _status : student.status;
      _hasLoadedStudent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && !_hasLoadedStudent) {
          return const _StateCard(
            icon: Icons.hourglass_empty,
            message: 'Loading student details...',
            showLoader: true,
          );
        }

        if (provider.errorMessage != null && !_hasLoadedStudent) {
          return _StateCard(
            icon: Icons.error_outline,
            message: provider.errorMessage!,
          );
        }

        if (!_hasLoadedStudent) {
          return const _StateCard(
            icon: Icons.person_off_outlined,
            message: 'Student details not found.',
          );
        }

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
                        status: _status,
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
                        onStatusChanged: (value) {
                          if (value != null) {
                            setState(() => _status = value);
                          }
                        },
                      ),
                      const SizedBox(height: 14),
                      _ActionBar(onCancel: _goBackToDetails, onSave: _save),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final totalFees = num.tryParse(_totalFeesController.text.trim()) ?? 0;
    final advancePaid = num.tryParse(_advancePaidController.text.trim()) ?? 0;
    final remainingFees =
        num.tryParse(_remainingFeesController.text.trim()) ?? 0;
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

    final provider = context.read<StudentProvider>();
    final loadedStudents = await provider.fetchStudents();

    if (!mounted) {
      return;
    }

    if (!loadedStudents) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.errorMessage ??
                'Unable to verify duplicate mobile number.',
          ),
        ),
      );
      return;
    }

    if (StudentFormValidators.hasDuplicateMobile(
      provider.students,
      normalizedMobile,
      excludingStudentId: widget.studentId,
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A student with this mobile number already exists.'),
        ),
      );
      return;
    }

    final student = StudentModel(
      id: widget.studentId,
      fullName: _fullNameController.text.trim(),
      mobileNumber: normalizedMobile,
      alternateMobile: normalizedAlternateMobile ?? '',
      areaVillage: _areaVillageController.text.trim(),
      address: _addressController.text.trim(),
      course: _course,
      duration: _durationController.text.trim(),
      totalFees: totalFees,
      paidAmount: advancePaid,
      remainingFees: remainingFees,
      status: _status,
      preferredBatch: _preferredBatch,
      startDate: _parseDate(_startDateController.text.trim()),
      nextPaymentDate: _parseDate(_nextPaymentDateController.text.trim()),
      createdAt: null,
      updatedAt: null,
      notes: _notesController.text.trim(),
    );

    final success = await provider.updateStudent(widget.studentId, student);

    if (!mounted) {
      return;
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student updated successfully.')),
      );
      _goBackToDetails();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(provider.errorMessage ?? 'Unable to update student.'),
      ),
    );
  }

  void _goBackToDetails() {
    Navigator.of(context).pushReplacementNamed(
      '/owner/students/${Uri.encodeComponent(widget.studentId)}',
    );
  }

  DateTime? _parseDate(String value) {
    if (value.isEmpty) {
      return null;
    }

    return DateTime.tryParse(value);
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
    return SingleChildScrollView(
      padding: AppSpacing.ownerPagePadding,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.ownerCompactMaxContentWidth,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.card),
            decoration: _cardDecoration(),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: _cardDecoration(),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Edit Student', style: AppTextStyles.ownerPageTitle),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Update student profile, course details, and fee records.',
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
  final String status;
  final ValueChanged<String?> onCourseChanged;
  final ValueChanged<String?> onPreferredBatchChanged;
  final ValueChanged<String?> onStatusChanged;

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
    required this.status,
    required this.onCourseChanged,
    required this.onPreferredBatchChanged,
    required this.onStatusChanged,
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
        const SizedBox(height: 14),
        _FormSection(
          title: 'Course Information',
          subtitle: 'Batch, duration, and preferred learning time.',
          icon: Icons.directions_car_outlined,
          children: [
            _DropdownField(
              label: 'Course',
              icon: Icons.directions_car_outlined,
              value: course,
              options: const [
                'Beginner Driving',
                'Advanced Course',
                'Licence Assistance',
              ],
              onChanged: onCourseChanged,
            ),
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
            _DropdownField(
              label: 'Preferred Time Slot',
              icon: Icons.schedule_outlined,
              value: preferredBatch,
              options: const [
                'Morning Batch',
                'Afternoon Batch',
                'Evening Batch',
                'Weekend Batch',
              ],
              onChanged: onPreferredBatchChanged,
            ),
          ],
        ),
        const SizedBox(height: 14),
        _FormSection(
          title: 'Payment Information',
          subtitle:
              'Track fees, advance amount, and the next payment reminder.',
          icon: Icons.payments_outlined,
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
              highlighted: true,
              keyboardType: TextInputType.number,
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
        const SizedBox(height: 14),
        _FormSection(
          title: 'Status & Notes',
          subtitle: 'Current student state and useful internal comments.',
          icon: Icons.notes_outlined,
          children: [
            _DropdownField(
              label: 'Status',
              icon: Icons.verified_outlined,
              value: status,
              options: const [
                'Active',
                'Pending Payment',
                'Completed',
                'Inactive',
              ],
              onChanged: onStatusChanged,
            ),
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

  const _FormSection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.children,
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
  final TextEditingController controller;
  final int maxLines;
  final bool fullWidth;
  final bool highlighted;
  final bool requiredField;
  final String? helperText;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;

  const _InputField({
    required this.label,
    required this.icon,
    required this.controller,
    this.maxLines = 1,
    this.fullWidth = false,
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

class _DropdownField extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.label,
    required this.icon,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final items = [...options];
    if (value.trim().isNotEmpty && !items.contains(value)) {
      items.add(value);
    }

    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
      ),
      items:
          items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
      onChanged: onChanged,
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
      decoration: _cardDecoration(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 520;
          final isLoading = context.watch<StudentProvider>().isLoading;
          final cancel = OutlinedButton.icon(
            onPressed: isLoading ? null : onCancel,
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
            label: Text(isLoading ? 'Saving...' : 'Save Changes'),
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
        },
      ),
    );
  }
}

String _formatDate(DateTime? date) {
  if (date == null) {
    return '';
  }

  return date.toIso8601String().split('T').first;
}

String _formatAmount(num value) {
  return value % 1 == 0 ? value.toInt().toString() : value.toString();
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
