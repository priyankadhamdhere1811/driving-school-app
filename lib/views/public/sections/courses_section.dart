import 'package:flutter/material.dart';

import '../../../utils/responsive_helper.dart';
import '../../../widgets/course_card.dart';
import '../../../widgets/section_heading.dart';
import '../../../widgets/section_shell.dart';

class CoursesSection extends StatelessWidget {
  final ValueChanged<String> onEnquireTap;

  const CoursesSection({super.key, required this.onEnquireTap});

  @override
  Widget build(BuildContext context) {
    final courses = [
      const _CourseData(
        title: 'Beginner Driving Course',
        description:
            'Start from zero with clutch control, steering, parking, and road basics.',
        duration: '30 days',
        price: 'Rs 5,000',
      ),
      const _CourseData(
        title: 'Advanced Confidence Course',
        description:
            'Build better road judgement, traffic confidence, reverse, and hill control.',
        duration: '15 days',
        price: 'Rs 3,500',
      ),
      const _CourseData(
        title: 'Licence Assistance Course',
        description:
            'Focused driving practice with document and RTO test guidance.',
        duration: '20 days',
        price: 'Rs 4,500',
      ),
    ];

    return SectionShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            title: 'Popular driving courses',
            subtitle:
                'Simple packages designed to convert interest into confident enquiries.',
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = ResponsiveHelper.isDesktopWidth(
                constraints.maxWidth,
              );
              final isTablet = ResponsiveHelper.isTabletWidth(
                constraints.maxWidth,
              );
              final cardWidth =
                  isDesktop
                      ? (constraints.maxWidth - 40) / 3
                      : isTablet
                      ? (constraints.maxWidth - 20) / 2
                      : constraints.maxWidth;

              return Wrap(
                spacing: 20,
                runSpacing: 20,
                children:
                    courses.map((course) {
                      return CourseCard(
                        width: cardWidth,
                        title: course.title,
                        description: course.description,
                        duration: course.duration,
                        price: course.price,
                        onEnquire: () => onEnquireTap(course.title),
                      );
                    }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CourseData {
  final String title;
  final String description;
  final String duration;
  final String price;

  const _CourseData({
    required this.title,
    required this.description,
    required this.duration,
    required this.price,
  });
}
