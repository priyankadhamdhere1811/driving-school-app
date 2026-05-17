import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/enquiry_model.dart';
import '../../../providers/enquiry_provider.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/app_spacing.dart';
import '../../../utils/validators.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  ContactSectionState createState() => ContactSectionState();
}

class ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _messageController = TextEditingController();
  String _interestedCourse = 'Beginner Driving Course';

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void selectCourse(String course) {
    setState(() => _interestedCourse = course);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final enquiry = EnquiryModel(
      id: '',
      fullName: _nameController.text.trim(),
      mobileNumber: _mobileController.text.trim(),
      interestedCourse: _interestedCourse,
      message: _messageController.text.trim(),
      status: 'New',
      createdAt: null,
    );
    final provider = context.read<EnquiryProvider>();
    final success = await provider.createEnquiry(enquiry);

    if (!mounted) {
      return;
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thanks! We will call you shortly.')),
      );
      _nameController.clear();
      _mobileController.clear();
      _messageController.clear();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(provider.errorMessage ?? 'Unable to submit enquiry.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sectionX,
        vertical: 54,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 820;
              final form = _CallbackForm(
                formKey: _formKey,
                nameController: _nameController,
                mobileController: _mobileController,
                messageController: _messageController,
                interestedCourse: _interestedCourse,
                onCourseChanged: (value) {
                  if (value != null) {
                    setState(() => _interestedCourse = value);
                  }
                },
                onSubmit: _submit,
              );
              final info = const _ContactInfo();

              if (!isWide) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    form,
                    const SizedBox(height: AppSpacing.sectionX),
                    info,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: form),
                  const SizedBox(width: AppSpacing.card),
                  const Expanded(child: _ContactInfo()),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CallbackForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController mobileController;
  final TextEditingController messageController;
  final String interestedCourse;
  final ValueChanged<String?> onCourseChanged;
  final Future<void> Function() onSubmit;

  const _CallbackForm({
    required this.formKey,
    required this.nameController,
    required this.mobileController,
    required this.messageController,
    required this.interestedCourse,
    required this.onCourseChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<EnquiryProvider>().isLoading;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.card),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppSpacing.radiusXl,
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Get a free callback',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Share your details and our team will help you pick the right batch.',
              style: TextStyle(height: 1.5, color: AppColors.textGray),
            ),
            const SizedBox(height: 22),
            TextFormField(
              controller: nameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: Validators.requiredName,
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: mobileController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Mobile Number',
                prefixIcon: Icon(Icons.call_outlined),
              ),
              validator: Validators.mobileNumber,
            ),
            const SizedBox(height: AppSpacing.lg),
            DropdownButtonFormField<String>(
              value: interestedCourse,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Interested Course',
                prefixIcon: Icon(Icons.directions_car_outlined),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Beginner Driving Course',
                  child: Text('Beginner Driving Course'),
                ),
                DropdownMenuItem(
                  value: 'Advanced Confidence Course',
                  child: Text('Advanced Confidence Course'),
                ),
                DropdownMenuItem(
                  value: 'Licence Assistance Course',
                  child: Text('Licence Assistance Course'),
                ),
              ],
              onChanged: onCourseChanged,
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: messageController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Message',
                prefixIcon: Icon(Icons.notes_outlined),
              ),
            ),
            const SizedBox(height: AppSpacing.sectionX),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: isLoading ? null : onSubmit,
                icon:
                    isLoading
                        ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Icon(Icons.phone_callback),
                label: Text(isLoading ? 'Submitting...' : 'Submit'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.ctaGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppSpacing.radiusMd,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactInfo extends StatelessWidget {
  const _ContactInfo();

  @override
  Widget build(BuildContext context) {
    final items = [
      const _InfoItem(Icons.call, 'Phone', AppConstants.phoneNumber),
      const _InfoItem(
        Icons.chat_bubble_outline,
        'WhatsApp',
        AppConstants.phoneNumber,
      ),
      const _InfoItem(
        Icons.location_on_outlined,
        'Address',
        AppConstants.address,
      ),
      const _InfoItem(
        Icons.schedule,
        'Working Hours',
        AppConstants.workingHours,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.card),
      decoration: BoxDecoration(
        color: AppColors.darkRed,
        borderRadius: AppSpacing.radiusXl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Call or message us for current batches, fees, and licence support.',
            style: TextStyle(height: 1.5, color: Color(0xFFFFCDD2)),
          ),
          const SizedBox(height: 22),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(item.icon, color: AppColors.accent),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.label,
                          style: const TextStyle(
                            color: Color(0xFFFFCDD2),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.call),
                label: const Text('Call Now'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.ctaGreen,
                  foregroundColor: Colors.white,
                ),
              ),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.chat),
                label: const Text('WhatsApp'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem(this.icon, this.label, this.value);
}
