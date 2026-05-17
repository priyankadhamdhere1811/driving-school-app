import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/attendance_model.dart';
import '../../../models/student_model.dart';
import '../../../providers/attendance_provider.dart';
import '../../../providers/student_provider.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_spacing.dart';
import '../../../utils/app_text_styles.dart';
import '../../../widgets/owner/owner_action_button.dart';
import '../../../widgets/owner/owner_search_filter_bar.dart';
import '../../../widgets/owner/owner_section_card.dart';
import '../../../widgets/owner/owner_stat_card.dart';
import '../../../widgets/owner/owner_status_badge.dart';

class AttendanceView extends StatefulWidget {
  const AttendanceView({super.key});

  @override
  State<AttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<AttendanceView> {
  String _searchQuery = '';
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAttendance());
  }

  Future<void> _loadAttendance() async {
    final studentProvider = context.read<StudentProvider>();
    if (studentProvider.students.isEmpty) {
      await studentProvider.fetchStudents();
    }

    if (!mounted) {
      return;
    }

    await context.read<AttendanceProvider>().fetchAttendance();
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
          child: Consumer2<StudentProvider, AttendanceProvider>(
            builder: (context, studentProvider, attendanceProvider, child) {
              final realStudents =
                  studentProvider.students
                      .map(
                        (student) => _AttendanceStudent.fromStudent(
                          student,
                          attendanceProvider,
                        ),
                      )
                      .toList();
              final stats = _AttendanceStats.fromData(
                studentProvider.students,
                attendanceProvider.attendanceRecords,
              );
              final batches = _buildBatchData(realStudents);
              final trends = _buildTrendData(
                attendanceProvider.attendanceRecords,
              );
              final filteredStudents = _filteredStudents(realStudents);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _PageHeader(),
                  const SizedBox(height: AppSpacing.sectionX),
                  _SummaryCards(stats: stats),
                  const SizedBox(height: AppSpacing.sectionX),
                  OwnerSearchFilterBar(
                    hintText: 'Search by name, mobile, course, or batch',
                    filters: const [
                      'All',
                      'Present',
                      'Absent',
                      'Morning Batch',
                      'Evening Batch',
                    ],
                    selectedFilter: _selectedFilter,
                    onSearchChanged: (value) {
                      setState(() => _searchQuery = value);
                    },
                    onFilterChanged: (value) {
                      setState(() => _selectedFilter = value);
                    },
                    breakpoint: 600,
                  ),
                  const SizedBox(height: AppSpacing.sectionX),
                  if (attendanceProvider.generatedOtpForTesting != null)
                    _GeneratedOtpBanner(provider: attendanceProvider),
                  if (attendanceProvider.generatedOtpForTesting != null)
                    const SizedBox(height: AppSpacing.sectionX),
                  if (studentProvider.isLoading || attendanceProvider.isLoading)
                    const _StateCard(
                      message: 'Loading attendance...',
                      showLoader: true,
                    )
                  else if (attendanceProvider.errorMessage != null)
                    _StateCard(message: attendanceProvider.errorMessage!)
                  else if (realStudents.isEmpty)
                    const _StateCard(message: 'No students found.')
                  else if (filteredStudents.isEmpty)
                    const _StateCard(message: 'No attendance records found.')
                  else
                    Column(
                      children: [
                        if (attendanceProvider.attendanceRecords.isEmpty) ...[
                          const _StateCard(
                            message: 'No attendance records found.',
                          ),
                          const SizedBox(height: AppSpacing.sectionX),
                        ],
                        _AttendanceRecords(
                          students: filteredStudents,
                          onGenerateOtp: _generateOtp,
                          onVerifyOtp: _showVerifyOtpDialog,
                          actionsEnabled: filteredStudents.isNotEmpty,
                          loadingStudentId: attendanceProvider.loadingStudentId,
                          verifyingStudentId:
                              attendanceProvider.verifyingStudentId,
                        ),
                      ],
                    ),
                  const SizedBox(height: AppSpacing.sectionX),
                  _AttendanceCalendarSection(stats: stats),
                  const SizedBox(height: AppSpacing.sectionX),
                  _BatchOverviewSection(batches: batches),
                  const SizedBox(height: AppSpacing.sectionX),
                  _AttendanceAnalytics(stats: stats, trends: trends),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _generateOtp(_AttendanceStudent student) async {
    if (student.id.isEmpty) {
      return;
    }
    if (student.markedToday) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance already marked for today.')),
      );
      return;
    }

    final provider = context.read<AttendanceProvider>();
    final success = await provider.generateOtp(student.id);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'OTP for ${student.name}: ${provider.generatedOtpForTesting}'
              : provider.errorMessage ?? 'Unable to generate OTP.',
        ),
      ),
    );
  }

  Future<void> _showVerifyOtpDialog(_AttendanceStudent student) async {
    if (student.id.isEmpty) {
      return;
    }
    if (student.markedToday) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance already marked for today.')),
      );
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (context) => _VerifyOtpDialog(student: student),
    );
  }

  List<_AttendanceStudent> _filteredStudents(
    List<_AttendanceStudent> students,
  ) {
    final query = _searchQuery.trim().toLowerCase();

    return students.where((student) {
      final matchesSearch =
          query.isEmpty ||
          student.name.toLowerCase().contains(query) ||
          student.mobile.toLowerCase().contains(query) ||
          student.course.toLowerCase().contains(query) ||
          student.batch.toLowerCase().contains(query);
      final matchesFilter = switch (_selectedFilter) {
        'Present' => student.status == 'Present',
        'Absent' => student.status == 'Absent',
        'Morning Batch' => student.batch.toLowerCase().contains('morning'),
        'Evening Batch' => student.batch.toLowerCase().contains('evening'),
        _ => true,
      };

      return matchesSearch && matchesFilter;
    }).toList();
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader();

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 700;

          return Wrap(
            spacing: AppSpacing.xl,
            runSpacing: AppSpacing.xl,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width:
                    isNarrow
                        ? constraints.maxWidth
                        : constraints.maxWidth - 370,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Attendance', style: AppTextStyles.ownerPageTitle),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      'Track daily student attendance and batch participation.',
                      style: AppTextStyles.sectionSubtitle,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: isNarrow ? constraints.maxWidth : 340,
                child: _HeaderActions(isNarrow: isNarrow),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HeaderActions extends StatelessWidget {
  final bool isNarrow;

  const _HeaderActions({required this.isNarrow});

  @override
  Widget build(BuildContext context) {
    final markAttendance = FilledButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.fact_check_outlined),
      label: const Text('Mark Attendance'),
      style: OwnerActionButton.filledStyle(AppColors.primary),
    );
    final exportAttendance = OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.file_download_outlined),
      label: const Text('Export Attendance'),
      style: OwnerActionButton.outlinedStyle(),
    );

    if (isNarrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          markAttendance,
          const SizedBox(height: AppSpacing.sm),
          exportAttendance,
        ],
      );
    }

    return Wrap(
      alignment: WrapAlignment.end,
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.sm,
      children: [
        SizedBox(width: 164, child: markAttendance),
        SizedBox(width: 164, child: exportAttendance),
      ],
    );
  }
}

class _SummaryCards extends StatelessWidget {
  final _AttendanceStats stats;

  const _SummaryCards({required this.stats});

  @override
  Widget build(BuildContext context) {
    final cards = [
      _SummaryData(
        'Total Active Students',
        stats.totalStudents.toString(),
        Icons.people_outline,
        AppColors.primary,
      ),
      _SummaryData(
        'Present Today',
        stats.presentToday.toString(),
        Icons.check_circle_outline,
        AppColors.ctaGreen,
      ),
      _SummaryData(
        'Absent Today',
        stats.absentToday.toString(),
        Icons.cancel_outlined,
        AppColors.accent,
      ),
      _SummaryData(
        'Attendance Percentage',
        '${stats.attendancePercentage}%',
        Icons.analytics_outlined,
        AppColors.darkRed,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns =
            width >= 1040
                ? 4
                : width >= 680
                ? 2
                : 1;
        final gap = width < 680 ? AppSpacing.md : AppSpacing.xl;
        final cardWidth = (width - (gap * (columns - 1))) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children:
              cards
                  .map(
                    (card) => SizedBox(
                      width: cardWidth,
                      child: OwnerStatCard(
                        width: double.infinity,
                        title: card.label,
                        value: card.value,
                        icon: card.icon,
                        color: card.color,
                      ),
                    ),
                  )
                  .toList(),
        );
      },
    );
  }
}

class _GeneratedOtpBanner extends StatelessWidget {
  final AttendanceProvider provider;

  const _GeneratedOtpBanner({required this.provider});

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Row(
        children: [
          const Icon(Icons.sms_outlined, color: AppColors.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              'Test OTP: ${provider.generatedOtpForTesting}',
              style: const TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StateCard extends StatelessWidget {
  final String message;
  final bool showLoader;

  const _StateCard({required this.message, this.showLoader = false});

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      child: Center(
        child: Column(
          children: [
            if (showLoader)
              const CircularProgressIndicator()
            else
              const Icon(Icons.info_outline, color: AppColors.primary),
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
      ),
    );
  }
}

class _VerifyOtpDialog extends StatefulWidget {
  final _AttendanceStudent student;

  const _VerifyOtpDialog({required this.student});

  @override
  State<_VerifyOtpDialog> createState() => _VerifyOtpDialogState();
}

class _VerifyOtpDialogState extends State<_VerifyOtpDialog> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AttendanceProvider>();
    final isLoading = provider.verifyingStudentId == widget.student.id;

    return AlertDialog(
      title: Text('Verify ${widget.student.name}'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'OTP is required';
            }
            return null;
          },
          decoration: const InputDecoration(
            labelText: 'OTP',
            prefixIcon: Icon(Icons.verified_outlined),
          ),
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: isLoading ? null : _verify,
          icon:
              isLoading
                  ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : const Icon(Icons.check_circle_outline),
          label: Text(isLoading ? 'Verifying...' : 'Verify OTP'),
        ),
      ],
    );
  }

  Future<void> _verify() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final provider = context.read<AttendanceProvider>();
    final success = await provider.verifyOtpAndMarkAttendance(
      widget.student.id,
      _otpController.text.trim(),
    );

    if (!mounted) {
      return;
    }

    if (success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance marked present.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(provider.errorMessage ?? 'Unable to verify OTP.')),
    );
  }
}

class _AttendanceRecords extends StatelessWidget {
  final List<_AttendanceStudent> students;
  final ValueChanged<_AttendanceStudent> onGenerateOtp;
  final ValueChanged<_AttendanceStudent> onVerifyOtp;
  final bool actionsEnabled;
  final String? loadingStudentId;
  final String? verifyingStudentId;

  const _AttendanceRecords({
    required this.students,
    required this.onGenerateOtp,
    required this.onVerifyOtp,
    required this.actionsEnabled,
    required this.loadingStudentId,
    required this.verifyingStudentId,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1120) {
          return _AttendanceTable(
            students: students,
            onGenerateOtp: onGenerateOtp,
            onVerifyOtp: onVerifyOtp,
            actionsEnabled: actionsEnabled,
            loadingStudentId: loadingStudentId,
            verifyingStudentId: verifyingStudentId,
          );
        }

        return _AttendanceCardList(
          students: students,
          onGenerateOtp: onGenerateOtp,
          onVerifyOtp: onVerifyOtp,
          actionsEnabled: actionsEnabled,
          loadingStudentId: loadingStudentId,
          verifyingStudentId: verifyingStudentId,
        );
      },
    );
  }
}

class _AttendanceTable extends StatelessWidget {
  final List<_AttendanceStudent> students;
  final ValueChanged<_AttendanceStudent> onGenerateOtp;
  final ValueChanged<_AttendanceStudent> onVerifyOtp;
  final bool actionsEnabled;
  final String? loadingStudentId;
  final String? verifyingStudentId;

  const _AttendanceTable({
    required this.students,
    required this.onGenerateOtp,
    required this.onVerifyOtp,
    required this.actionsEnabled,
    required this.loadingStudentId,
    required this.verifyingStudentId,
  });

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingTextStyle: AppTextStyles.tableHeader,
          dataTextStyle: AppTextStyles.tableBody,
          headingRowHeight: AppSpacing.tableHeadingRowHeight,
          dataRowMinHeight: AppSpacing.tableDataRowMinHeight,
          dataRowMaxHeight: AppSpacing.tableDataRowMaxHeight,
          columns: const [
            DataColumn(label: Text('Student Name')),
            DataColumn(label: Text('Course')),
            DataColumn(label: Text('Batch')),
            DataColumn(label: Text('Mobile')),
            DataColumn(label: Text("Today's Status")),
            DataColumn(label: Text('Attendance %')),
            DataColumn(label: Text('Last Attended')),
            DataColumn(label: Text('Actions')),
          ],
          rows:
              students
                  .map(
                    (student) => DataRow(
                      cells: [
                        DataCell(
                          Text(
                            student.name,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                        DataCell(Text(student.course)),
                        DataCell(Text(student.batch)),
                        DataCell(Text(student.mobile)),
                        DataCell(OwnerStatusBadge(status: student.status)),
                        DataCell(Text(student.attendancePercent)),
                        DataCell(Text(student.lastAttended)),
                        DataCell(
                          SizedBox(
                            width: 270,
                            child: _AttendanceActionButtons(
                              student: student,
                              onGenerateOtp: onGenerateOtp,
                              onVerifyOtp: onVerifyOtp,
                              actionsEnabled: actionsEnabled,
                              verifyingStudentId: verifyingStudentId,
                              loadingStudentId: loadingStudentId,
                              fullWidth: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}

class _AttendanceCardList extends StatelessWidget {
  final List<_AttendanceStudent> students;
  final ValueChanged<_AttendanceStudent> onGenerateOtp;
  final ValueChanged<_AttendanceStudent> onVerifyOtp;
  final bool actionsEnabled;
  final String? loadingStudentId;
  final String? verifyingStudentId;

  const _AttendanceCardList({
    required this.students,
    required this.onGenerateOtp,
    required this.onVerifyOtp,
    required this.actionsEnabled,
    required this.loadingStudentId,
    required this.verifyingStudentId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          students
              .map(
                (student) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                  child: _AttendanceCard(
                    student: student,
                    onGenerateOtp: onGenerateOtp,
                    onVerifyOtp: onVerifyOtp,
                    actionsEnabled: actionsEnabled,
                    loadingStudentId: loadingStudentId,
                    verifyingStudentId: verifyingStudentId,
                  ),
                ),
              )
              .toList(),
    );
  }
}

class _AttendanceCard extends StatelessWidget {
  final _AttendanceStudent student;
  final ValueChanged<_AttendanceStudent> onGenerateOtp;
  final ValueChanged<_AttendanceStudent> onVerifyOtp;
  final bool actionsEnabled;
  final String? loadingStudentId;
  final String? verifyingStudentId;

  const _AttendanceCard({
    required this.student,
    required this.onGenerateOtp,
    required this.onVerifyOtp,
    required this.actionsEnabled,
    required this.loadingStudentId,
    required this.verifyingStudentId,
  });

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      radius: AppSpacing.radiusLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(student.name, style: AppTextStyles.ownerCardTitle),
              OwnerStatusBadge(status: student.status),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _InfoLine('Course', student.course),
          _InfoLine('Batch', student.batch),
          _InfoLine('Mobile', student.mobile),
          _InfoLine('Attendance', student.attendancePercent),
          _InfoLine('Last Attended', student.lastAttended),
          const SizedBox(height: AppSpacing.md),
          _AttendanceActionButtons(
            student: student,
            onGenerateOtp: onGenerateOtp,
            onVerifyOtp: onVerifyOtp,
            actionsEnabled: actionsEnabled,
            loadingStudentId: loadingStudentId,
            verifyingStudentId: verifyingStudentId,
            fullWidth: true,
          ),
        ],
      ),
    );
  }
}

class _AttendanceActionButtons extends StatelessWidget {
  final _AttendanceStudent student;
  final ValueChanged<_AttendanceStudent> onGenerateOtp;
  final ValueChanged<_AttendanceStudent> onVerifyOtp;
  final bool actionsEnabled;
  final String? loadingStudentId;
  final String? verifyingStudentId;
  final bool fullWidth;

  const _AttendanceActionButtons({
    required this.student,
    required this.onGenerateOtp,
    required this.onVerifyOtp,
    required this.actionsEnabled,
    required this.loadingStudentId,
    required this.verifyingStudentId,
    required this.fullWidth,
  });

  @override
  Widget build(BuildContext context) {
    final isGenerating = loadingStudentId == student.id;
    final isVerifying = verifyingStudentId == student.id;
    final isMarkedToday = student.markedToday;

    if (isMarkedToday) {
      return const _MarkedTodayBadge();
    }

    final canGenerate = actionsEnabled && !isGenerating;
    final canVerify = actionsEnabled && !isVerifying;
    final generate = OutlinedButton.icon(
      onPressed: canGenerate ? () => onGenerateOtp(student) : null,
      icon:
          isGenerating
              ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
              : const Icon(Icons.password_outlined),
      label: Text(isGenerating ? 'Generating...' : 'Generate OTP'),
      style: OwnerActionButton.outlinedStyle(),
    );
    final verify = FilledButton.icon(
      onPressed: canVerify ? () => onVerifyOtp(student) : null,
      icon:
          isVerifying
              ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
              : const Icon(Icons.verified_outlined),
      label: Text(isVerifying ? 'Verifying...' : 'Verify OTP'),
      style: OwnerActionButton.filledStyle(AppColors.primary),
    );

    if (!fullWidth) {
      return Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          SizedBox(width: 146, child: generate),
          SizedBox(width: 116, child: verify),
        ],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 430) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [generate, const SizedBox(height: AppSpacing.sm), verify],
          );
        }

        return Row(
          children: [
            Expanded(child: generate),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: verify),
          ],
        );
      },
    );
  }
}

class _MarkedTodayBadge extends StatelessWidget {
  const _MarkedTodayBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.ctaGreen.withValues(alpha: 0.1),
        borderRadius: AppSpacing.radiusMd,
        border: Border.all(color: AppColors.ctaGreen.withValues(alpha: 0.2)),
      ),
      child: const Text(
        'Marked Today',
        style: TextStyle(
          color: AppColors.ctaGreen,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _AttendanceCalendarSection extends StatelessWidget {
  final _AttendanceStats stats;

  const _AttendanceCalendarSection({required this.stats});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Monthly Attendance Calendar',
      icon: Icons.calendar_month_outlined,
      trailing: Text(
        '${stats.attendancePercentage}% attendance',
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w900,
        ),
      ),
      child: const _CalendarGrid(),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cellGap = constraints.maxWidth < 420 ? 6.0 : AppSpacing.sm;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: cellGap,
            crossAxisSpacing: cellGap,
          ),
          itemCount: 31,
          itemBuilder: (context, index) {
            final day = index + 1;
            final isCurrentDay = day == 8;
            final isPresent = day % 6 != 0 && day % 7 != 0;

            return DecoratedBox(
              decoration: BoxDecoration(
                color: isPresent ? AppColors.primary : const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(10),
                border:
                    isCurrentDay
                        ? Border.all(color: AppColors.darkRed, width: 2)
                        : null,
              ),
              child: Center(
                child: Text(
                  '$day',
                  style: TextStyle(
                    color: isPresent ? Colors.white : AppColors.textGray,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _BatchOverviewSection extends StatelessWidget {
  final List<_BatchData> batches;

  const _BatchOverviewSection({required this.batches});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns =
            width >= 920
                ? 3
                : width >= 620
                ? 2
                : 1;
        final gap = width < 620 ? AppSpacing.md : AppSpacing.xl;
        final cardWidth = (width - (gap * (columns - 1))) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children:
              batches
                  .map((batch) => _BatchCard(width: cardWidth, batch: batch))
                  .toList(),
        );
      },
    );
  }
}

class _BatchCard extends StatelessWidget {
  final double width;
  final _BatchData batch;

  const _BatchCard({required this.width, required this.batch});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: _SoftCard(
        padding: const EdgeInsets.all(AppSpacing.xl),
        radius: AppSpacing.radiusLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(batch.name, style: AppTextStyles.ownerCardTitle),
            const SizedBox(height: AppSpacing.xl),
            _InfoLine('Total students', batch.totalStudents),
            _InfoLine('Present count', batch.presentCount),
            _InfoLine('Attendance', batch.attendancePercent),
          ],
        ),
      ),
    );
  }
}

class _AttendanceAnalytics extends StatelessWidget {
  final _AttendanceStats stats;
  final List<_TrendData> trends;

  const _AttendanceAnalytics({required this.stats, required this.trends});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Attendance Analytics',
      icon: Icons.analytics_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProgressLine(
            label: 'Weekly attendance progress',
            valueLabel: '${stats.attendancePercentage}% overall',
            value: stats.attendancePercentage / 100,
          ),
          const SizedBox(height: AppSpacing.xl),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final columns =
                  width >= 760
                      ? 3
                      : width >= 500
                      ? 2
                      : 1;
              final gap = width < 500 ? AppSpacing.md : AppSpacing.xl;
              final cardWidth = (width - (gap * (columns - 1))) / columns;

              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children:
                    trends
                        .map(
                          (trend) => _TrendCard(width: cardWidth, trend: trend),
                        )
                        .toList(),
              );
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          _OverallRateCard(stats: stats),
        ],
      ),
    );
  }
}

class _ProgressLine extends StatelessWidget {
  final String label;
  final String valueLabel;
  final double value;

  const _ProgressLine({
    required this.label,
    required this.valueLabel,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.xs,
          alignment: WrapAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(valueLabel, style: const TextStyle(color: AppColors.textGray)),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 10,
            backgroundColor: AppColors.ownerTint,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ],
    );
  }
}

class _TrendCard extends StatelessWidget {
  final double width;
  final _TrendData trend;

  const _TrendCard({required this.width, required this.trend});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.ownerCardTint,
        borderRadius: AppSpacing.radiusMd,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(trend.icon, color: AppColors.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trend.label,
                  style: const TextStyle(color: AppColors.textGray),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  trend.value,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
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

class _OverallRateCard extends StatelessWidget {
  final _AttendanceStats stats;

  const _OverallRateCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.ownerCardTint,
        borderRadius: AppSpacing.radiusLg,
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        'Overall attendance rate: ${stats.attendancePercentage}% across ${stats.totalAttendanceDays} attendance records.',
        style: const TextStyle(
          color: AppColors.textDark,
          fontWeight: FontWeight.w800,
          height: 1.4,
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final Widget? trailing;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return OwnerSectionCard(
      title: title,
      icon: icon,
      trailing: trailing,
      child: child,
    );
  }
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
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 126,
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
                    fontWeight: FontWeight.w800,
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

class _SoftCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius radius;

  const _SoftCard({
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.card),
    this.radius = AppSpacing.ownerCardRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
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
      ),
      child: child,
    );
  }
}

class _AttendanceStats {
  final int totalStudents;
  final int presentToday;
  final int absentToday;
  final int attendancePercentage;
  final int totalAttendanceDays;

  const _AttendanceStats({
    required this.totalStudents,
    required this.presentToday,
    required this.absentToday,
    required this.attendancePercentage,
    required this.totalAttendanceDays,
  });

  factory _AttendanceStats.fromData(
    List<StudentModel> students,
    List<AttendanceModel> records,
  ) {
    final studentIds = students.map((student) => student.id).toSet();
    final presentStudentIds =
        records
            .where(_isPresentToday)
            .map((record) => record.studentId)
            .where(studentIds.contains)
            .toSet();
    final presentRecords = records.where((record) => record.isPresent).length;
    final attendancePercentage =
        records.isEmpty ? 0 : ((presentRecords / records.length) * 100).round();

    return _AttendanceStats(
      totalStudents: students.length,
      presentToday: presentStudentIds.length,
      absentToday: students.length - presentStudentIds.length,
      attendancePercentage: attendancePercentage,
      totalAttendanceDays: records.length,
    );
  }
}

List<_BatchData> _buildBatchData(List<_AttendanceStudent> students) {
  final batches = <String, List<_AttendanceStudent>>{};
  for (final student in students) {
    batches.putIfAbsent(student.batch, () => []).add(student);
  }

  return batches.entries.map((entry) {
    final totalStudents = entry.value.length;
    final presentCount =
        entry.value.where((student) => student.status == 'Present').length;
    final percentage =
        totalStudents == 0 ? 0 : ((presentCount / totalStudents) * 100).round();

    return _BatchData(
      entry.key,
      totalStudents.toString(),
      presentCount.toString(),
      '$percentage%',
    );
  }).toList();
}

List<_TrendData> _buildTrendData(List<AttendanceModel> records) {
  final recordsByDate = <DateTime, List<AttendanceModel>>{};
  for (final record in records) {
    final date = record.attendanceDate;
    if (date == null) {
      continue;
    }

    recordsByDate.putIfAbsent(_dateOnly(date), () => []).add(record);
  }

  final dates = recordsByDate.keys.toList()..sort((a, b) => b.compareTo(a));
  return dates.take(3).map((date) {
    final dateRecords = recordsByDate[date] ?? [];
    final presentCount = dateRecords.where((record) => record.isPresent).length;
    final percentage =
        dateRecords.isEmpty
            ? 0
            : ((presentCount / dateRecords.length) * 100).round();

    return _TrendData(_formatDate(date), '$percentage%', Icons.show_chart);
  }).toList();
}

bool _isPresentToday(AttendanceModel record) {
  final date = record.attendanceDate;
  if (date == null || !record.isPresent) {
    return false;
  }

  return _dateOnly(date) == _dateOnly(DateTime.now());
}

DateTime _dateOnly(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

class _AttendanceStudent {
  final String id;
  final String name;
  final String course;
  final String batch;
  final String mobile;
  final String status;
  final String attendancePercent;
  final String lastAttended;
  final bool markedToday;

  const _AttendanceStudent({
    required this.id,
    required this.name,
    required this.course,
    required this.batch,
    required this.mobile,
    required this.status,
    required this.attendancePercent,
    required this.lastAttended,
    required this.markedToday,
  });

  factory _AttendanceStudent.fromStudent(
    StudentModel student,
    AttendanceProvider attendanceProvider,
  ) {
    final isPresent = attendanceProvider.isPresentToday(student.id);
    final attendancePercentage = attendanceProvider.attendancePercentage(
      student.id,
    );

    return _AttendanceStudent(
      id: student.id,
      name: _valueOrDash(student.fullName),
      course: _valueOrDash(student.course),
      batch: _valueOrDash(student.preferredBatch),
      mobile: _valueOrDash(student.mobileNumber),
      status: isPresent ? 'Present' : 'Absent',
      attendancePercent: '$attendancePercentage%',
      lastAttended: _formatDate(
        attendanceProvider.lastAttendedDate(student.id),
      ),
      markedToday: isPresent,
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
  final month = months[date.month - 1];
  return '$day $month ${date.year}';
}

class _BatchData {
  final String name;
  final String totalStudents;
  final String presentCount;
  final String attendancePercent;

  const _BatchData(
    this.name,
    this.totalStudents,
    this.presentCount,
    this.attendancePercent,
  );
}

class _SummaryData {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryData(this.label, this.value, this.icon, this.color);
}

class _TrendData {
  final String label;
  final String value;
  final IconData icon;

  const _TrendData(this.label, this.value, this.icon);
}
