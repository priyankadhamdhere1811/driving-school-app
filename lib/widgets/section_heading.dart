import 'package:flutter/material.dart';

import '../utils/app_text_styles.dart';

class SectionHeading extends StatelessWidget {
  final String title;
  final String subtitle;

  const SectionHeading({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.sectionTitle),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Text(subtitle, style: AppTextStyles.sectionSubtitle),
        ),
      ],
    );
  }
}
