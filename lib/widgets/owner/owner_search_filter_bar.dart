import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import 'owner_section_card.dart';

class OwnerSearchFilterBar extends StatelessWidget {
  final String hintText;
  final List<String> filters;
  final String selectedFilter;
  final double breakpoint;

  const OwnerSearchFilterBar({
    super.key,
    required this.hintText,
    required this.filters,
    this.selectedFilter = 'All',
    this.breakpoint = 560,
  });

  @override
  Widget build(BuildContext context) {
    return OwnerSectionCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < breakpoint;

          return Wrap(
            spacing: AppSpacing.xl,
            runSpacing: AppSpacing.xl,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: isNarrow ? constraints.maxWidth : 360,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: hintText,
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              SizedBox(
                width:
                    isNarrow
                        ? constraints.maxWidth
                        : constraints.maxWidth - 380,
                child: Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children:
                      filters
                          .map(
                            (filter) => FilterChip(
                              selected: filter == selectedFilter,
                              onSelected: (_) {},
                              label: Text(filter),
                              selectedColor: AppColors.ownerTint,
                              checkmarkColor: AppColors.primary,
                              side: BorderSide(
                                color:
                                    filter == selectedFilter
                                        ? AppColors.primary
                                        : Colors.black.withValues(alpha: 0.08),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
