import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_spacing.dart';
import '../../../utils/app_text_styles.dart';

class StudentDetailsView extends StatelessWidget {
  const StudentDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBackground,
      appBar: AppBar(
        title: const Text('Student Details'),
        backgroundColor: AppColors.card,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.sectionX),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _StudentHeader(),
                const SizedBox(height: AppSpacing.sectionX),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 780;
                    final cardWidth =
                        isWide
                            ? (constraints.maxWidth - AppSpacing.xl) / 2
                            : constraints.maxWidth;

                    return Wrap(
                      spacing: AppSpacing.xl,
                      runSpacing: AppSpacing.xl,
                      children: [
                        _DetailsSection(
                          width: cardWidth,
                          title: 'Basic Info',
                          icon: Icons.person_outline,
                          items: const [
                            _DetailItem('Name', 'Amit Sharma'),
                            _DetailItem('Mobile', '+91 98765 11111'),
                            _DetailItem('Area/Village', 'Main Road'),
                            _DetailItem('Status', 'Active'),
                          ],
                        ),
                        _DetailsSection(
                          width: cardWidth,
                          title: 'Course Info',
                          icon: Icons.directions_car_outlined,
                          items: const [
                            _DetailItem('Course', 'Beginner Driving'),
                            _DetailItem('Start Date', 'May 8, 2026'),
                            _DetailItem('Duration', '30 days'),
                            _DetailItem('Trainer', 'Raj Trainer'),
                          ],
                        ),
                        _DetailsSection(
                          width: cardWidth,
                          title: 'Payment Summary',
                          icon: Icons.payments_outlined,
                          items: const [
                            _DetailItem('Total Fees', 'Rs 5,000'),
                            _DetailItem('Advance Paid', 'Rs 2,000'),
                            _DetailItem('Remaining Fees', 'Rs 3,000'),
                            _DetailItem('Next Due Date', 'May 15, 2026'),
                          ],
                        ),
                        _DetailsSection(
                          width: cardWidth,
                          title: 'Attendance Summary',
                          icon: Icons.fact_check_outlined,
                          items: const [
                            _DetailItem('Classes Attended', '8'),
                            _DetailItem('Classes Missed', '1'),
                            _DetailItem('Remaining Classes', '21'),
                            _DetailItem('Last Attendance', 'Present'),
                          ],
                        ),
                        _DetailsSection(
                          width: cardWidth,
                          title: 'Reminder Status',
                          icon: Icons.alarm_outlined,
                          items: const [
                            _DetailItem('Payment Reminder', 'Scheduled'),
                            _DetailItem('Class Reminder', 'Enabled'),
                            _DetailItem('Last Follow-up', 'May 7, 2026'),
                            _DetailItem('Next Follow-up', 'May 10, 2026'),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StudentHeader extends StatelessWidget {
  const _StudentHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.card),
      decoration: _cardDecoration(),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Amit Sharma', style: AppTextStyles.sectionTitle),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Beginner Driving • Active student • Pending fee: Rs 3,000',
            style: AppTextStyles.sectionSubtitle,
          ),
        ],
      ),
    );
  }
}

class _DetailsSection extends StatelessWidget {
  final double width;
  final String title;
  final IconData icon;
  final List<_DetailItem> items;

  const _DetailsSection({
    required this.width,
    required this.title,
    required this.icon,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: AppSpacing.sm),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          ...items.map((item) => _DetailLine(item: item)),
        ],
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  final _DetailItem item;

  const _DetailLine({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              item.label,
              style: const TextStyle(color: AppColors.textGray),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              item.value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
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

class _DetailItem {
  final String label;
  final String value;

  const _DetailItem(this.label, this.value);
}
