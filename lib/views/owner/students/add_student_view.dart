import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_spacing.dart';
import '../../../utils/app_text_styles.dart';

class AddStudentView extends StatelessWidget {
  const AddStudentView({super.key});

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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PageHeader(),
                SizedBox(height: 14),
                _StudentForm(),
                SizedBox(height: 14),
                _ActionBar(),
              ],
            ),
          ),
        ),
      ),
    );
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
  const _StudentForm();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _FormSection(
          title: 'Basic Information',
          subtitle: 'Contact and address details used for daily follow-ups.',
          icon: Icons.person_outline,
          children: [
            _InputField(label: 'Full Name', icon: Icons.person_outline),
            _InputField(label: 'Mobile Number', icon: Icons.call_outlined),
            _InputField(
              label: 'Alternate Mobile',
              icon: Icons.phone_android_outlined,
              helperText: 'Optional',
            ),
            _InputField(
              label: 'Area / Village',
              icon: Icons.location_on_outlined,
            ),
            _InputField(
              label: 'Address',
              icon: Icons.home_outlined,
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
            _CourseDropdown(),
            _InputField(label: 'Duration', icon: Icons.timer_outlined),
            _InputField(
              label: 'Start Date',
              icon: Icons.calendar_today_outlined,
              helperText: 'Example: 08 May 2026',
            ),
            _TimeSlotDropdown(),
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
            _InputField(label: 'Total Fees', icon: Icons.payments_outlined),
            _InputField(
              label: 'Advance Paid',
              icon: Icons.account_balance_wallet_outlined,
            ),
            _InputField(
              label: 'Remaining Fees',
              icon: Icons.receipt_long_outlined,
              readOnly: true,
              highlighted: true,
              helperText: 'Auto calculated from total fees and advance paid',
            ),
            _InputField(
              label: 'Next Payment Date',
              icon: Icons.event_available_outlined,
              helperText: 'Optional reminder date',
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
  final int maxLines;
  final bool fullWidth;
  final bool readOnly;
  final bool highlighted;
  final String? helperText;

  const _InputField({
    required this.label,
    required this.icon,
    this.maxLines = 1,
    this.fullWidth = false,
    this.readOnly = false,
    this.highlighted = false,
    this.helperText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      maxLines: maxLines,
      initialValue: readOnly ? 'Auto calculated' : null,
      style: const TextStyle(
        color: AppColors.textDark,
        fontWeight: FontWeight.w600,
      ),
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
  const _CourseDropdown();

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: 'Beginner Driving',
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Course',
        prefixIcon: Icon(Icons.directions_car_outlined),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
      ),
      items: const [
        DropdownMenuItem(
          value: 'Beginner Driving',
          child: Text('Beginner Driving'),
        ),
        DropdownMenuItem(
          value: 'Advanced Course',
          child: Text('Advanced Course'),
        ),
        DropdownMenuItem(
          value: 'Licence Assistance',
          child: Text('Licence Assistance'),
        ),
      ],
      onChanged: (_) {},
    );
  }
}

class _TimeSlotDropdown extends StatelessWidget {
  const _TimeSlotDropdown();

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: 'Morning Batch',
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
      onChanged: (_) {},
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
  const _ActionBar();

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
      child: const _ActionButtons(),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 520;
        final cancel = OutlinedButton.icon(
          onPressed: () {},
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
          onPressed: () {},
          icon: const Icon(Icons.save_outlined),
          label: const Text('Save Student'),
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
