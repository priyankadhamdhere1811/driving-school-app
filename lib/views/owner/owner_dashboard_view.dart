import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';

class OwnerDashboardView extends StatelessWidget {
  const OwnerDashboardView({super.key});

  static const double _desktopBreakpoint = 980;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= _desktopBreakpoint;

    return Scaffold(
      backgroundColor: AppColors.softBackground,
      drawer: isDesktop ? null : const _OwnerDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.card,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        title: const Text('Owner Dashboard'),
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
        children: [
          if (isDesktop) const _Sidebar(),
          const Expanded(child: _DashboardContent()),
        ],
      ),
    );
  }
}

class _OwnerDrawer extends StatelessWidget {
  const _OwnerDrawer();

  @override
  Widget build(BuildContext context) {
    return const Drawer(child: _NavigationContent());
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
    final items = [
      const _MenuItem(Icons.dashboard_outlined, 'Dashboard', true),
      const _MenuItem(Icons.people_outline, 'Students', false),
      const _MenuItem(Icons.payments_outlined, 'Payments', false),
      const _MenuItem(Icons.fact_check_outlined, 'Attendance', false),
      const _MenuItem(Icons.alarm_outlined, 'Reminders', false),
      const _MenuItem(Icons.mark_email_unread_outlined, 'Enquiries', false),
      const _MenuItem(Icons.star_outline, 'Reviews', false),
      const _MenuItem(Icons.settings_outlined, 'Settings', false),
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
            ...items.map((item) => _SidebarTile(item: item)),
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

  const _SidebarTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: item.isSelected ? const Color(0xFFFFEBEE) : Colors.transparent,
        borderRadius: AppSpacing.radiusMd,
        child: InkWell(
          onTap: () {},
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
                  color:
                      item.isSelected ? AppColors.primary : AppColors.textGray,
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  item.label,
                  style: TextStyle(
                    color:
                        item.isSelected
                            ? AppColors.primary
                            : AppColors.textDark,
                    fontWeight:
                        item.isSelected ? FontWeight.w800 : FontWeight.w600,
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

class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  static const double _maxDashboardWidth = 1400;

  @override
  Widget build(BuildContext context) {
    final cards = [
      const _MetricData(
        'Total Students',
        '128',
        '+12 this month',
        Icons.people_outline,
        AppColors.primary,
      ),
      const _MetricData(
        'Pending Payments',
        'Rs 42,500',
        '18 dues open',
        Icons.account_balance_wallet_outlined,
        AppColors.accent,
      ),
      const _MetricData(
        "Today's Attendance",
        '34 / 42',
        '81% present',
        Icons.fact_check_outlined,
        AppColors.ctaGreen,
      ),
      const _MetricData(
        'Courses Ending Soon',
        '9',
        'Next 7 days',
        Icons.event_available_outlined,
        AppColors.darkRed,
      ),
      const _MetricData(
        'New Enquiries',
        '16',
        '5 need callback',
        Icons.mark_email_unread_outlined,
        AppColors.primary,
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 36),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _maxDashboardWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _HeaderBlock(),
              const SizedBox(height: 26),
              LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final columns =
                      width >= 1180
                          ? 5
                          : width >= 900
                          ? 3
                          : width >= 620
                          ? 2
                          : 1;
                  final spacing = width < 620 ? AppSpacing.md : AppSpacing.xl;
                  final cardWidth =
                      (width - (spacing * (columns - 1))) / columns;

                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children:
                        cards
                            .map(
                              (card) =>
                                  _MetricCard(width: cardWidth, data: card),
                            )
                            .toList(),
                  );
                },
              ),
              const SizedBox(height: 28),
              const _DashboardSections(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderBlock extends StatelessWidget {
  const _HeaderBlock();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.card),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppSpacing.radiusXl,
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Good morning, Owner', style: AppTextStyles.sectionTitle),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Here is a quick view of students, payments, attendance, and enquiries.',
            style: AppTextStyles.sectionSubtitle,
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final double width;
  final _MetricData data;

  const _MetricCard({required this.width, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppSpacing.radiusLg,
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.1),
              borderRadius: AppSpacing.radiusMd,
            ),
            child: Icon(data.icon, color: data.color),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            data.value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            data.title,
            style: const TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            data.subtitle,
            style: const TextStyle(color: AppColors.textGray),
          ),
        ],
      ),
    );
  }
}

class _DashboardSections extends StatelessWidget {
  const _DashboardSections();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 920;
        final recentPayments = const _InfoPanel(
          title: 'Recent Payments',
          rows: [
            _InfoRow('Amit Sharma', 'Beginner Course', 'Rs 5,000', 'Paid'),
            _InfoRow('Neha Singh', 'Advanced Course', 'Rs 3,500', 'Paid'),
            _InfoRow('Vikram Patel', 'Licence Assist', 'Rs 4,500', 'Paid'),
          ],
        );
        final duePayments = const _InfoPanel(
          title: 'Upcoming Due Payments',
          rows: [
            _InfoRow('Priya Nair', 'Due tomorrow', 'Rs 2,000', 'Reminder'),
            _InfoRow('Rohan Das', 'Due May 12', 'Rs 3,000', 'Pending'),
            _InfoRow('Sara Khan', 'Due May 15', 'Rs 1,500', 'Pending'),
          ],
        );
        final enquiries = const _InfoPanel(
          title: 'Recent Enquiries',
          rows: [
            _InfoRow('Karan Mehta', 'Car training', 'Today', 'Callback'),
            _InfoRow('Anjali Rao', 'Licence help', 'Yesterday', 'New'),
            _InfoRow('Manish Jain', 'Weekend batch', 'May 7', 'New'),
          ],
        );

        if (!isWide) {
          return const Column(
            children: [
              _InfoPanel(
                title: 'Recent Payments',
                rows: [
                  _InfoRow(
                    'Amit Sharma',
                    'Beginner Course',
                    'Rs 5,000',
                    'Paid',
                  ),
                  _InfoRow('Neha Singh', 'Advanced Course', 'Rs 3,500', 'Paid'),
                  _InfoRow(
                    'Vikram Patel',
                    'Licence Assist',
                    'Rs 4,500',
                    'Paid',
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.xl),
              _InfoPanel(
                title: 'Upcoming Due Payments',
                rows: [
                  _InfoRow(
                    'Priya Nair',
                    'Due tomorrow',
                    'Rs 2,000',
                    'Reminder',
                  ),
                  _InfoRow('Rohan Das', 'Due May 12', 'Rs 3,000', 'Pending'),
                  _InfoRow('Sara Khan', 'Due May 15', 'Rs 1,500', 'Pending'),
                ],
              ),
              SizedBox(height: AppSpacing.xl),
              _InfoPanel(
                title: 'Recent Enquiries',
                rows: [
                  _InfoRow('Karan Mehta', 'Car training', 'Today', 'Callback'),
                  _InfoRow('Anjali Rao', 'Licence help', 'Yesterday', 'New'),
                  _InfoRow('Manish Jain', 'Weekend batch', 'May 7', 'New'),
                ],
              ),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: recentPayments),
            const SizedBox(width: AppSpacing.xl),
            Expanded(child: duePayments),
            const SizedBox(width: AppSpacing.xl),
            Expanded(child: enquiries),
          ],
        );
      },
    );
  }
}

class _InfoPanel extends StatelessWidget {
  final String title;
  final List<_InfoRow> rows;

  const _InfoPanel({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppSpacing.radiusLg,
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
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
          const SizedBox(height: AppSpacing.xl),
          ...rows.map((row) => _InfoListTile(row: row)),
        ],
      ),
    );
  }
}

class _InfoListTile extends StatelessWidget {
  final _InfoRow row;

  const _InfoListTile({required this.row});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.title,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  row.subtitle,
                  style: const TextStyle(color: AppColors.textGray),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                row.value,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                row.status,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final bool isSelected;

  const _MenuItem(this.icon, this.label, this.isSelected);
}

class _MetricData {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _MetricData(
    this.title,
    this.value,
    this.subtitle,
    this.icon,
    this.color,
  );
}

class _InfoRow {
  final String title;
  final String subtitle;
  final String value;
  final String status;

  const _InfoRow(this.title, this.subtitle, this.value, this.status);
}
