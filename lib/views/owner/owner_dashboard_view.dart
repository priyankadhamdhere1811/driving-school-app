import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/reminder_model.dart';
import '../../providers/reminder_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';
import '../../widgets/owner/owner_section_card.dart';
import '../../widgets/owner/owner_stat_card.dart';
import '../../widgets/owner/owner_status_badge.dart';

class OwnerDashboardView extends StatelessWidget {
  const OwnerDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _DashboardContent();
  }
}

class _DashboardContent extends StatefulWidget {
  const _DashboardContent();

  @override
  State<_DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<_DashboardContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ReminderProvider>().fetchReminders();
      }
    });
  }

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
      padding: AppSpacing.ownerDashboardPadding,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.ownerMaxContentWidth,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _HeaderBlock(),
              const SizedBox(height: AppSpacing.sectionX),
              LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final columns = width >= 760 ? 2 : 1;
                  final spacing = columns == 1 ? AppSpacing.md : AppSpacing.xl;
                  final cardWidth =
                      columns == 1 ? width : (width - spacing) / columns;

                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children:
                        cards
                            .map(
                              (card) => SizedBox(
                                width: cardWidth,
                                child: OwnerStatCard(
                                  width: double.infinity,
                                  title: card.title,
                                  value: card.value,
                                  subtitle: card.subtitle,
                                  icon: card.icon,
                                  color: card.color,
                                ),
                              ),
                            )
                            .toList(),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.sectionX),
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
      decoration: _cardDecoration(radius: AppSpacing.ownerHeroCardRadius),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Good morning, Owner', style: AppTextStyles.ownerPageTitle),
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
        final duePayments = Consumer<ReminderProvider>(
          builder:
              (context, reminderProvider, child) => _ReminderPanel(
                reminders: reminderProvider.reminders,
                isLoading: reminderProvider.isLoading,
                errorMessage: reminderProvider.errorMessage,
              ),
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
          return Column(
            children: [
              const _InfoPanel(
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
              const SizedBox(height: AppSpacing.xl),
              duePayments,
              const SizedBox(height: AppSpacing.xl),
              const _InfoPanel(
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
    return OwnerSectionCard(
      title: title,
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [...rows.map((row) => _InfoListTile(row: row))],
      ),
    );
  }
}

class _ReminderPanel extends StatelessWidget {
  final List<ReminderModel> reminders;
  final bool isLoading;
  final String? errorMessage;

  const _ReminderPanel({
    required this.reminders,
    required this.isLoading,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (isLoading) {
      child = const Text(
        'Loading reminders...',
        style: TextStyle(color: AppColors.textGray),
      );
    } else if (errorMessage != null) {
      child = Text(
        errorMessage!,
        style: const TextStyle(color: AppColors.darkRed),
      );
    } else if (reminders.isEmpty) {
      child = const Text(
        'No reminders yet.',
        style: TextStyle(color: AppColors.textGray),
      );
    } else {
      child = _ReminderList(reminders: reminders);
    }

    return OwnerSectionCard(
      title: 'Payment Reminders',
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: child,
    );
  }
}

class _ReminderList extends StatelessWidget {
  final List<ReminderModel> reminders;

  const _ReminderList({required this.reminders});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 720 ? 2 : 1;
        final spacing = AppSpacing.md;
        final tileWidth =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children:
              reminders
                  .map(
                    (reminder) => SizedBox(
                      width: tileWidth,
                      child: _ReminderTile(reminder: reminder),
                    ),
                  )
                  .toList(),
        );
      },
    );
  }
}

class _ReminderTile extends StatelessWidget {
  final ReminderModel reminder;

  const _ReminderTile({required this.reminder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 420;

        final details = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              reminder.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              reminder.message.isEmpty ? 'No message added' : reminder.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.textGray, height: 1.35),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Due ${reminder.dueDateText}',
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        );

        final actions = Column(
          crossAxisAlignment:
              isCompact ? CrossAxisAlignment.stretch : CrossAxisAlignment.end,
          children: [
            Align(
              alignment:
                  isCompact ? Alignment.centerLeft : Alignment.centerRight,
              child: OwnerStatusBadge(status: reminder.status),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: isCompact ? double.infinity : 128,
              height: 40,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none_outlined, size: 18),
                label: const Text('Reminder'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textDark,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  textStyle: AppTextStyles.button,
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppSpacing.radiusMd,
                  ),
                ),
              ),
            ),
          ],
        );

        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.ownerCardTint,
            borderRadius: AppSpacing.radiusMd,
            border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
          ),
          child:
              isCompact
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      details,
                      const SizedBox(height: AppSpacing.md),
                      actions,
                    ],
                  )
                  : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: details),
                      const SizedBox(width: AppSpacing.md),
                      actions,
                    ],
                  ),
        );
      },
    );
  }
}

BoxDecoration _cardDecoration({
  BorderRadius radius = AppSpacing.ownerCardRadius,
}) {
  return BoxDecoration(
    color: AppColors.card,
    borderRadius: radius,
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
