import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Full-width header bar used by every real control page (Lighting,
/// Sockets, Big Relay) — icon, title, subtitle/status stacked, optional
/// trailing widget. Mirrors their header structure exactly.
class ControlPageHeader extends StatelessWidget {
  const ControlPageHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised.withValues(alpha: 0.9),
        border: const Border(bottom: BorderSide(color: AppColors.hairline)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 30, color: AppColors.accent),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.title),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(letterSpacing: 1.5),
                ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
