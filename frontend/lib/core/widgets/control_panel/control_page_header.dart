import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Page header for every control screen — an icon, huge letter-spaced
/// title, subtitle, and an optional trailing widget (status pill / mode
/// toggle) floated to the corner. Deliberately borderless and centered —
/// no app-bar box, reads as part of the page. Matches the premium
/// glassmorphism header established on the Lighting/Tanks screens.
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
    return Padding(
      padding: const EdgeInsets.only(top: 32, left: 32, right: 32, bottom: 40),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (trailing != null) Align(alignment: Alignment.centerRight, child: trailing),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.accent, size: 28),
              const SizedBox(height: 12),
              Text(
                title,
                style: AppTextStyles.title.copyWith(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 16,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white38,
                  letterSpacing: 8,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
