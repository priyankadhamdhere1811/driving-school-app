import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_spacing.dart';

class OwnerLayout extends StatelessWidget {
  final String title;
  final Widget child;

  const OwnerLayout({super.key, required this.title, required this.child});

  static const double _desktopBreakpoint = 980;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= _desktopBreakpoint;

    return Scaffold(
      backgroundColor: AppColors.softBackground,
      drawer: isDesktop ? null : const Drawer(child: _NavigationContent()),
      appBar: AppBar(
        backgroundColor: AppColors.card,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        title: Text(title),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: Row(
        children: [if (isDesktop) const _Sidebar(), Expanded(child: child)],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 248,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border(
          right: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
        ),
      ),
      child: const _NavigationContent(),
    );
  }
}

class _NavigationContent extends StatelessWidget {
  const _NavigationContent();

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final items = [
      const _MenuItem(
        Icons.dashboard_outlined,
        'Dashboard',
        '/owner/dashboard',
      ),
      const _MenuItem(Icons.people_outline, 'Students', '/owner/students'),
      const _MenuItem(Icons.payments_outlined, 'Payments', '/owner/payments'),
      const _MenuItem(
        Icons.fact_check_outlined,
        'Attendance',
        '/owner/attendance',
      ),
      const _MenuItem(
        Icons.mark_email_unread_outlined,
        'Enquiries',
        '/owner/enquiries',
      ),
      const _MenuItem(Icons.star_outline, 'Reviews', '/owner/reviews'),
      const _MenuItem(Icons.settings_outlined, 'Settings', '/owner/settings'),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.local_taxi, color: AppColors.primary, size: 30),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'DrivePro School',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            ...items.map(
              (item) => _SidebarTile(
                item: item,
                isSelected: currentRoute == item.route,
              ),
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: AppSpacing.radiusLg,
              ),
              child: const Text(
                'Manage daily operations from one simple dashboard.',
                style: TextStyle(
                  height: 1.4,
                  color: AppColors.darkRed,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SidebarTile extends StatelessWidget {
  final _MenuItem item;
  final bool isSelected;

  const _SidebarTile({required this.item, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: isSelected ? const Color(0xFFFFEBEE) : Colors.transparent,
        borderRadius: AppSpacing.radiusMd,
        child: InkWell(
          onTap: () {
            if (Scaffold.maybeOf(context)?.hasDrawer ?? false) {
              Navigator.of(context).pop();
            }

            if (!isSelected) {
              Navigator.of(context).pushReplacementNamed(item.route);
            }
          },
          borderRadius: AppSpacing.radiusMd,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  color: isSelected ? AppColors.primary : AppColors.textGray,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      color:
                          isSelected ? AppColors.primary : AppColors.textDark,
                      fontWeight:
                          isSelected ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final String route;

  const _MenuItem(this.icon, this.label, this.route);
}
