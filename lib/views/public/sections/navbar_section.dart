import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/app_spacing.dart';
import '../../../utils/app_text_styles.dart';
import '../../../utils/responsive_helper.dart';

class NavbarSection extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onCoursesTap;
  final VoidCallback onReviewsTap;
  final VoidCallback onContactTap;
  final VoidCallback onCallTap;

  const NavbarSection({
    super.key,
    required this.onCoursesTap,
    required this.onReviewsTap,
    required this.onContactTap,
    required this.onCallTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(68);

  @override
  Widget build(BuildContext context) {
    final isCompact = ResponsiveHelper.isMobile(context);

    return AppBar(
      toolbarHeight: 68,
      elevation: 3,
      shadowColor: Colors.black.withValues(alpha: 0.14),
      title: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_taxi, color: AppColors.primary),
          SizedBox(width: AppSpacing.sm),
          Text(AppConstants.schoolName),
        ],
      ),
      actions:
          isCompact
              ? [
                IconButton(
                  tooltip: 'Call Now',
                  onPressed: onCallTap,
                  icon: const Icon(Icons.call, color: AppColors.ctaGreen),
                ),
                _MobileMenu(
                  onCoursesTap: onCoursesTap,
                  onReviewsTap: onReviewsTap,
                  onContactTap: onContactTap,
                  onCallTap: onCallTap,
                ),
                const SizedBox(width: AppSpacing.sm),
              ]
              : [
                _NavButton(label: 'Courses', onPressed: onCoursesTap),
                _NavButton(label: 'Reviews', onPressed: onReviewsTap),
                _NavButton(label: 'Contact', onPressed: onContactTap),
                const SizedBox(width: AppSpacing.sm),
                _CallNowButton(onPressed: onCallTap),
                const SizedBox(width: AppSpacing.xxl),
              ],
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _NavButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textDark,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
      child: Text(label),
    );
  }
}

class _CallNowButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _CallNowButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.call, size: 18),
      label: const Text('Call Now'),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.ctaGreen,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xxl,
          vertical: AppSpacing.lg,
        ),
        textStyle: AppTextStyles.button,
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.radiusMd),
      ),
    );
  }
}

class _MobileMenu extends StatelessWidget {
  final VoidCallback onCoursesTap;
  final VoidCallback onReviewsTap;
  final VoidCallback onContactTap;
  final VoidCallback onCallTap;

  const _MobileMenu({
    required this.onCoursesTap,
    required this.onReviewsTap,
    required this.onContactTap,
    required this.onCallTap,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Menu',
      icon: const Icon(Icons.menu),
      onSelected: (value) {
        if (value == 'courses') {
          onCoursesTap();
        } else if (value == 'reviews') {
          onReviewsTap();
        } else if (value == 'contact') {
          onContactTap();
        } else if (value == 'call') {
          onCallTap();
        }
      },
      itemBuilder:
          (context) => const [
            PopupMenuItem(value: 'courses', child: Text('Courses')),
            PopupMenuItem(value: 'reviews', child: Text('Reviews')),
            PopupMenuItem(value: 'contact', child: Text('Contact')),
            PopupMenuDivider(),
            PopupMenuItem(value: 'call', child: Text('Call Now')),
          ],
    );
  }
}
