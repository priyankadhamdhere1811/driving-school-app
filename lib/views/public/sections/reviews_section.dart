import 'package:flutter/material.dart';

import '../../../widgets/review_card.dart';
import '../../../widgets/section_heading.dart';
import '../../../widgets/section_shell.dart';

class ReviewsSection extends StatelessWidget {
  const ReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final reviews = [
      const _ReviewData(
        name: 'Aarav Mehta',
        rating: 5,
        testimonial:
            'The trainer was calm and helped me drive confidently in traffic.',
      ),
      const _ReviewData(
        name: 'Sneha Rao',
        rating: 5,
        testimonial:
            'Flexible timings made it easy to learn after work. Very professional.',
      ),
      const _ReviewData(
        name: 'Rahul Nair',
        rating: 5,
        testimonial: 'Great licence test guidance and clear practice sessions.',
      ),
    ];

    return Container(
      width: double.infinity,
      color: Colors.white,
      child: SectionShell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeading(
              title: 'Trusted by new drivers',
              subtitle:
                  'Short, genuine feedback that helps visitors feel ready to enquire.',
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 900;
                  return Wrap(
                    spacing: 22,
                    runSpacing: 22,
                    children:
                        reviews.map((review) {
                          return ReviewCard(
                            width:
                                isWide
                                    ? (constraints.maxWidth - 44) / 3
                                    : constraints.maxWidth,
                            name: review.name,
                            rating: review.rating,
                            testimonial: review.testimonial,
                          );
                        }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewData {
  final String name;
  final int rating;
  final String testimonial;

  const _ReviewData({
    required this.name,
    required this.rating,
    required this.testimonial,
  });
}
