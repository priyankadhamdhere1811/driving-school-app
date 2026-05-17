import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class FloatingCtaButtons extends StatelessWidget {
  final VoidCallback onCallTap;
  final VoidCallback onWhatsAppTap;

  const FloatingCtaButtons({
    super.key,
    required this.onCallTap,
    required this.onWhatsAppTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 18,
      bottom: 18,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _FloatingButton(
              label: 'WhatsApp',
              icon: Icons.chat_bubble_outline,
              color: AppColors.ctaGreen,
              onPressed: onWhatsAppTap,
            ),
            const SizedBox(height: 12),
            _FloatingButton(
              label: 'Call',
              icon: Icons.call,
              color: AppColors.primary,
              onPressed: onCallTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatingButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _FloatingButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: FloatingActionButton(
        heroTag: label,
        onPressed: onPressed,
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 6,
        child: Icon(icon),
      ),
    );
  }
}
