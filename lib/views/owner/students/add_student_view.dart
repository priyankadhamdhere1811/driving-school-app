import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_spacing.dart';
import '../../../utils/app_text_styles.dart';

class AddStudentView extends StatelessWidget {
  const AddStudentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBackground,
      appBar: AppBar(
        title: const Text('Add Student'),
        backgroundColor: AppColors.card,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.sectionX),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.card),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('New Student', style: AppTextStyles.sectionTitle),
                  const SizedBox(height: AppSpacing.sm),
                  const Text(
                    'Add basic student, course, and fee details.',
                    style: AppTextStyles.sectionSubtitle,
                  ),
                  const SizedBox(height: AppSpacing.card),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 720;
                      return Wrap(
                        spacing: AppSpacing.xl,
                        runSpacing: AppSpacing.xl,
                        children: [
                          _FormFieldBox(
                            width: _fieldWidth(constraints.maxWidth, isWide),
                            label: 'Full Name',
                            icon: Icons.person_outline,
                          ),
                          _FormFieldBox(
                            width: _fieldWidth(constraints.maxWidth, isWide),
                            label: 'Mobile Number',
                            icon: Icons.call_outlined,
                          ),
                          _FormFieldBox(
                            width: _fieldWidth(constraints.maxWidth, isWide),
                            label: 'Area/Village',
                            icon: Icons.location_on_outlined,
                          ),
                          _FormFieldBox(
                            width: _fieldWidth(constraints.maxWidth, isWide),
                            label: 'Course',
                            icon: Icons.directions_car_outlined,
                          ),
                          _FormFieldBox(
                            width: _fieldWidth(constraints.maxWidth, isWide),
                            label: 'Start Date',
                            icon: Icons.calendar_today_outlined,
                          ),
                          _FormFieldBox(
                            width: _fieldWidth(constraints.maxWidth, isWide),
                            label: 'Duration',
                            icon: Icons.timer_outlined,
                          ),
                          _FormFieldBox(
                            width: _fieldWidth(constraints.maxWidth, isWide),
                            label: 'Total Fees',
                            icon: Icons.payments_outlined,
                          ),
                          _FormFieldBox(
                            width: _fieldWidth(constraints.maxWidth, isWide),
                            label: 'Advance Paid',
                            icon: Icons.account_balance_wallet_outlined,
                          ),
                          _FormFieldBox(
                            width: _fieldWidth(constraints.maxWidth, isWide),
                            label: 'Remaining Fees',
                            icon: Icons.receipt_long_outlined,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.card),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('Save Student'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: AppTextStyles.button,
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppSpacing.radiusMd,
                        ),
                      ),
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

  double _fieldWidth(double maxWidth, bool isWide) {
    return isWide ? (maxWidth - AppSpacing.xl) / 2 : maxWidth;
  }
}

class _FormFieldBox extends StatelessWidget {
  final double width;
  final String label;
  final IconData icon;

  const _FormFieldBox({
    required this.width,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
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
