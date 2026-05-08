import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_spacing.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/section_heading.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback onCallTap;
  final VoidCallback onWhatsAppTap;
  final VoidCallback onCoursesTap;

  const HeroSection({
    super.key,
    required this.onCallTap,
    required this.onWhatsAppTap,
    required this.onCoursesTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFEBEE), AppColors.background],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sectionX,
        28,
        AppSpacing.sectionX,
        42,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 820;
              final content = _HeroCopy(
                onCallTap: onCallTap,
                onWhatsAppTap: onWhatsAppTap,
                onCoursesTap: onCoursesTap,
              );
              final visual = const _DrivingVisual();

              if (!isWide) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    content,
                    const SizedBox(height: 24),
                    Center(child: visual),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(flex: 6, child: content),
                  const SizedBox(width: 28),
                  const Expanded(flex: 5, child: _DrivingVisual()),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class WhyChooseUsSection extends StatelessWidget {
  final VoidCallback onContactTap;

  const WhyChooseUsSection({super.key, required this.onContactTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      const _TrustItem(
        icon: Icons.school,
        title: 'Certified trainers',
        subtitle: 'Patient, practical road training',
      ),
      const _TrustItem(
        icon: Icons.schedule,
        title: 'Flexible batches',
        subtitle: 'Morning, evening, and weekend slots',
      ),
      const _TrustItem(
        icon: Icons.verified_user,
        title: 'Licence support',
        subtitle: 'Guidance from practice to RTO test',
      ),
    ];

    return Container(
      width: double.infinity,
      color: AppColors.softBackground,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sectionX,
        vertical: 38,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeading(
                title: 'Why learners choose us',
                subtitle:
                    'Clear training, steady support, and quick enquiry options at every step.',
              ),
              const SizedBox(height: 22),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 760;
                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children:
                        items.map((item) {
                          return SizedBox(
                            width:
                                isWide
                                    ? (constraints.maxWidth - 32) / 3
                                    : constraints.maxWidth,
                            child: _TrustCard(item: item),
                          );
                        }).toList(),
                  );
                },
              ),
              const SizedBox(height: 22),
              FilledButton.icon(
                onPressed: onContactTap,
                icon: const Icon(Icons.phone_in_talk),
                label: const Text('Request a quick callback'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  final VoidCallback onCallTap;
  final VoidCallback onWhatsAppTap;
  final VoidCallback onCoursesTap;

  const _HeroCopy({
    required this.onCallTap,
    required this.onWhatsAppTap,
    required this.onCoursesTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final titleSize = screenWidth < 420 ? 36.0 : 46.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.border),
          ),
          child: const Text(
            'Trusted local driving school',
            style: TextStyle(
              color: AppColors.darkRed,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Learn Driving with Confidence',
          style: TextStyle(
            fontSize: titleSize,
            height: 1.08,
            fontWeight: FontWeight.w900,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Expert trainers - Flexible batches - Licence assistance',
          style: TextStyle(
            fontSize: 18,
            height: 1.5,
            color: AppColors.textGray,
          ),
        ),
        const SizedBox(height: 26),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            PrimaryButton(
              text: 'Call Now',
              icon: Icons.call,
              color: AppColors.ctaGreen,
              onPressed: onCallTap,
            ),
            PrimaryButton(
              text: 'WhatsApp',
              icon: Icons.chat_bubble_outline,
              color: AppColors.ctaGreen,
              onPressed: onWhatsAppTap,
            ),
            OutlinedButton.icon(
              onPressed: onCoursesTap,
              icon: const Icon(Icons.menu_book_outlined),
              label: const Text('View Courses'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary, width: 1.2),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const _TrustStats(),
      ],
    );
  }
}

class _TrustStats extends StatelessWidget {
  const _TrustStats();

  @override
  Widget build(BuildContext context) {
    final stats = [
      const _StatData(value: '1000+', label: 'Students Trained'),
      const _StatData(value: '5+', label: 'Years Experience'),
      const _StatData(value: '4.8 stars', label: 'Rating'),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children:
          stats.map((stat) {
            return Container(
              width: 154,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stat.value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stat.label,
                    style: const TextStyle(
                      color: AppColors.textGray,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }
}

class _DrivingVisual extends StatelessWidget {
  const _DrivingVisual();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.34,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.14),
              blurRadius: 32,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 24,
              right: 24,
              bottom: 48,
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.textDark,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            Positioned(
              top: 22,
              right: 24,
              child: _InfoBadge(
                icon: Icons.traffic,
                title: 'Road rules',
                color: AppColors.accent,
              ),
            ),
            Positioned(
              top: 30,
              left: 24,
              child: _InfoBadge(
                icon: Icons.verified,
                title: 'RTO help',
                color: AppColors.ctaGreen,
              ),
            ),
            Positioned(
              left: 32,
              right: 32,
              bottom: 68,
              child: Container(
                height: 108,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Center(
                  child: Icon(
                    Icons.directions_car_filled,
                    color: AppColors.primary,
                    size: 92,
                  ),
                ),
              ),
            ),
            const Positioned(
              bottom: 18,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on, color: AppColors.darkRed, size: 20),
                  SizedBox(width: 6),
                  Text(
                    'Practice routes near you',
                    style: TextStyle(
                      color: AppColors.textGray,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrustCard extends StatelessWidget {
  final _TrustItem item;

  const _TrustCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(item.icon, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: const TextStyle(
                    height: 1.4,
                    color: AppColors.textGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _InfoBadge({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustItem {
  final IconData icon;
  final String title;
  final String subtitle;

  const _TrustItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

class _StatData {
  final String value;
  final String label;

  const _StatData({required this.value, required this.label});
}
