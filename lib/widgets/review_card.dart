import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class ReviewCard extends StatelessWidget {
  final double width;
  final String name;
  final int rating;
  final String testimonial;

  const ReviewCard({
    super.key,
    required this.width,
    required this.name,
    required this.rating,
    required this.testimonial,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.format_quote,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const Spacer(),
              ...List.generate(
                5,
                (index) => Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: const Color(0xFFFFB300),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            testimonial,
            style: const TextStyle(
              height: 1.55,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFFFEBEE),
                child: Text(
                  name.characters.first,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
