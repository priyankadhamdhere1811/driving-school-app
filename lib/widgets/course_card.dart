import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'primary_button.dart';

class CourseCard extends StatefulWidget {
  final String title;
  final String description;
  final String duration;
  final String price;
  final double width;
  final VoidCallback onEnquire;

  const CourseCard({
    super.key,
    required this.title,
    required this.description,
    required this.duration,
    required this.price,
    required this.width,
    required this.onEnquire,
  });

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            width: widget.width,
            padding: const EdgeInsets.all(22),
            transform: Matrix4.translationValues(0, _isHovered ? -5 : 0, 0),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: _isHovered ? AppColors.primary : AppColors.border,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: _isHovered ? 0.12 : 0.07,
                  ),
                  blurRadius: _isHovered ? 30 : 22,
                  offset: Offset(0, _isHovered ? 18 : 14),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.directions_car_filled,
                        color: AppColors.primary,
                        size: 30,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'Enquiry open',
                        style: TextStyle(
                          color: AppColors.ctaGreen,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 20,
                    height: 1.2,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.description,
                  style: const TextStyle(
                    height: 1.45,
                    color: AppColors.textGray,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      size: 18,
                      color: AppColors.textGray,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.duration,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.price,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 3),
                      child: Text(
                        'onwards',
                        style: TextStyle(color: AppColors.textGray),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'Enquire Now',
                    icon: Icons.arrow_forward_rounded,
                    color: AppColors.ctaGreen,
                    onPressed: widget.onEnquire,
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
