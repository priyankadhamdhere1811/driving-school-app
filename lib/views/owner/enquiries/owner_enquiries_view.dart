import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/enquiry_model.dart';
import '../../../models/student_prefill_model.dart';
import '../../../providers/enquiry_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_spacing.dart';
import '../../../utils/app_text_styles.dart';
import '../../../widgets/owner/owner_status_badge.dart';

const _enquiryStatuses = ['New', 'Contacted', 'Converted'];
const _convertToStudentAction = 'convert_to_student';

class OwnerEnquiriesView extends StatefulWidget {
  const OwnerEnquiriesView({super.key});

  @override
  State<OwnerEnquiriesView> createState() => _OwnerEnquiriesViewState();
}

class _OwnerEnquiriesViewState extends State<OwnerEnquiriesView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EnquiryProvider>().fetchEnquiries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.ownerPagePadding,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.ownerMaxContentWidth,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _PageHeader(),
              const SizedBox(height: AppSpacing.sectionX),
              Consumer<EnquiryProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const _LoadingState();
                  }

                  if (provider.errorMessage != null) {
                    return _MessageState(
                      icon: Icons.error_outline,
                      message: provider.errorMessage!,
                    );
                  }

                  final enquiries = provider.enquiries;
                  if (enquiries.isEmpty) {
                    return const _MessageState(
                      icon: Icons.mark_email_unread_outlined,
                      message: 'No enquiries yet.',
                    );
                  }

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth >= 920) {
                        return _EnquiriesTable(enquiries: enquiries);
                      }

                      return _EnquiryCardsList(enquiries: enquiries);
                    },
                  );
                },
              ),
            ],
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
      padding: const EdgeInsets.all(AppSpacing.card),
      decoration: _cardDecoration(radius: AppSpacing.ownerHeroCardRadius),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Enquiries', style: AppTextStyles.ownerPageTitle),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Review callback requests and course enquiries from the public website.',
            style: AppTextStyles.sectionSubtitle,
          ),
        ],
      ),
    );
  }
}

class _EnquiriesTable extends StatelessWidget {
  final List<EnquiryModel> enquiries;

  const _EnquiriesTable({required this.enquiries});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: _cardDecoration(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingTextStyle: AppTextStyles.tableHeader,
          dataTextStyle: AppTextStyles.tableBody,
          headingRowHeight: AppSpacing.tableHeadingRowHeight,
          dataRowMinHeight: AppSpacing.tableDataRowMinHeight,
          dataRowMaxHeight: AppSpacing.tableDataRowMaxHeight,
          columns: const [
            DataColumn(label: Text('Full Name')),
            DataColumn(label: Text('Mobile')),
            DataColumn(label: Text('Course')),
            DataColumn(label: Text('Message')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Created')),
          ],
          rows:
              enquiries
                  .map(
                    (enquiry) => DataRow(
                      cells: [
                        DataCell(Text(_valueOrDash(enquiry.fullName))),
                        DataCell(Text(_valueOrDash(enquiry.mobileNumber))),
                        DataCell(Text(_valueOrDash(enquiry.interestedCourse))),
                        DataCell(
                          SizedBox(
                            width: 260,
                            child: Text(
                              _valueOrDash(enquiry.message),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(_StatusActions(enquiry: enquiry)),
                        DataCell(Text(_formatDate(enquiry.createdAt))),
                      ],
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}

class _EnquiryCardsList extends StatelessWidget {
  final List<EnquiryModel> enquiries;

  const _EnquiryCardsList({required this.enquiries});

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          enquiries
              .map(
                (enquiry) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                  child: _EnquiryCard(enquiry: enquiry),
                ),
              )
              .toList(),
    );
  }
}

class _EnquiryCard extends StatelessWidget {
  final EnquiryModel enquiry;

  const _EnquiryCard({required this.enquiry});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                _valueOrDash(enquiry.fullName),
                style: AppTextStyles.ownerCardTitle,
              ),
              _StatusActions(enquiry: enquiry),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _InfoLine('Mobile', _valueOrDash(enquiry.mobileNumber)),
          _InfoLine('Course', _valueOrDash(enquiry.interestedCourse)),
          _InfoLine('Message', _valueOrDash(enquiry.message)),
          _InfoLine('Created', _formatDate(enquiry.createdAt)),
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.card),
      decoration: _cardDecoration(),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

class _MessageState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _MessageState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.card),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 32),
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
    );
  }
}

class _StatusActions extends StatelessWidget {
  final EnquiryModel enquiry;

  const _StatusActions({required this.enquiry});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OwnerStatusBadge(status: enquiry.status),
        const SizedBox(width: AppSpacing.xs),
        PopupMenuButton<String>(
          tooltip: 'Enquiry actions',
          initialValue:
              _enquiryStatuses.contains(enquiry.status) ? enquiry.status : null,
          icon: const Icon(Icons.more_vert, color: AppColors.textGray),
          onSelected: (value) {
            if (value == _convertToStudentAction) {
              _convertToStudent(context, enquiry);
              return;
            }

            _updateStatus(context, enquiry, value);
          },
          itemBuilder:
              (context) => [
                ..._enquiryStatuses.map(
                  (status) =>
                      PopupMenuItem<String>(value: status, child: Text(status)),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem<String>(
                  value: _convertToStudentAction,
                  child: Text('Convert to Student'),
                ),
              ],
        ),
      ],
    );
  }
}

void _convertToStudent(BuildContext context, EnquiryModel enquiry) {
  Navigator.of(context).pushNamed(
    AppRoutes.addStudent,
    arguments: StudentPrefillModel(
      fullName: enquiry.fullName,
      mobileNumber: enquiry.mobileNumber,
      course: enquiry.interestedCourse,
      notes: enquiry.message,
      sourceEnquiryId: enquiry.id,
    ),
  );
}

Future<void> _updateStatus(
  BuildContext context,
  EnquiryModel enquiry,
  String status,
) async {
  final provider = context.read<EnquiryProvider>();
  final updated = await provider.updateEnquiryStatus(enquiry.id, status);

  if (!context.mounted) {
    return;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        updated
            ? 'Enquiry status updated successfully.'
            : provider.errorMessage ??
                'Unable to update enquiry status. Please try again.',
      ),
    ),
  );
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLine(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 360;

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: AppColors.textGray)),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 112,
                child: Text(
                  label,
                  style: const TextStyle(color: AppColors.textGray),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

String _valueOrDash(String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? '-' : trimmed;
}

String _formatDate(DateTime? date) {
  if (date == null) {
    return '-';
  }

  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final day = date.day.toString().padLeft(2, '0');
  return '$day ${months[date.month - 1]} ${date.year}';
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
