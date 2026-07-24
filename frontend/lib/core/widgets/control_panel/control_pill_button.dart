import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// Generic minimal action button — "Close All", "Auto Pair", "Refresh".
/// Borderless when muted, a soft accent-tinted outline when active —
/// matches the premium glassmorphism action button on Lighting/Tanks.
class ControlPillButton extends StatelessWidget {
  const ControlPillButton({
    super.key,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: active ? AppColors.accent.withValues(alpha: 0.12) : Colors.transparent,
          border: Border.all(
            color: active ? AppColors.accent.withValues(alpha: 0.6) : Colors.white.withValues(alpha: 0.1),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            color: active ? AppColors.accent : Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
