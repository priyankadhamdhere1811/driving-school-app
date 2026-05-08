import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/app_spacing.dart';

class FooterSection extends StatelessWidget {
  final VoidCallback onCoursesTap;
  final VoidCallback onReviewsTap;
  final VoidCallback onContactTap;

  const FooterSection({
    super.key,
    required this.onCoursesTap,
    required this.onReviewsTap,
    required this.onContactTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.textDark,
      padding: const EdgeInsets.fromLTRB(20, 38, 20, 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 760;
                  final brand = const _FooterBrand();
                  final links = _FooterLinks(
                    onCoursesTap: onCoursesTap,
                    onReviewsTap: onReviewsTap,
                    onContactTap: onContactTap,
                  );
                  final contact = const _FooterContact();

                  if (!isWide) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        brand,
                        const SizedBox(height: 26),
                        links,
                        const SizedBox(height: 26),
                        contact,
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(flex: 4, child: _FooterBrand()),
                      const SizedBox(width: 32),
                      Expanded(flex: 2, child: links),
                      const SizedBox(width: 32),
                      const Expanded(flex: 4, child: _FooterContact()),
                    ],
                  );
                },
              ),
              const SizedBox(height: 28),
              Container(height: 1, color: Colors.white.withValues(alpha: 0.12)),
              const SizedBox(height: 16),
              const Text(
                AppConstants.copyrightText,
                style: TextStyle(color: Color(0xFFFFCDD2)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterBrand extends StatelessWidget {
  const _FooterBrand();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.local_taxi, color: AppColors.accent, size: 30),
            SizedBox(width: 10),
            Text(
              AppConstants.schoolName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Text(
          AppConstants.tagline,
          style: TextStyle(color: Color(0xFFFFCDD2), height: 1.5),
        ),
      ],
    );
  }
}

class _FooterLinks extends StatelessWidget {
  final VoidCallback onCoursesTap;
  final VoidCallback onReviewsTap;
  final VoidCallback onContactTap;

  const _FooterLinks({
    required this.onCoursesTap,
    required this.onReviewsTap,
    required this.onContactTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FooterTitle('Quick links'),
        _FooterLink(label: 'Courses', onTap: onCoursesTap),
        _FooterLink(label: 'Reviews', onTap: onReviewsTap),
        _FooterLink(label: 'Contact', onTap: onContactTap),
      ],
    );
  }
}

class _FooterContact extends StatelessWidget {
  const _FooterContact();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FooterTitle('Contact'),
        _ContactLine(Icons.call, 'Phone', AppConstants.phoneNumber),
        _ContactLine(
          Icons.chat_bubble_outline,
          'WhatsApp',
          AppConstants.whatsAppNumber,
        ),
        _ContactLine(
          Icons.location_on_outlined,
          'Address',
          AppConstants.address,
        ),
        _ContactLine(
          Icons.schedule,
          'Working Hours',
          AppConstants.workingHours,
        ),
      ],
    );
  }
}

class _FooterTitle extends StatelessWidget {
  final String text;

  const _FooterTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FooterLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFFFFCDD2),
        padding: const EdgeInsets.symmetric(vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: Alignment.centerLeft,
      ),
      child: Text(label),
    );
  }
}

class _ContactLine extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ContactLine(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.accent, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFFFFCDD2),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
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
