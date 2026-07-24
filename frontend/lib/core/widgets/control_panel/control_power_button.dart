import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// The big circular power button every real control page centers its
/// detail panel on — a soft glowing disc, brighter and haloed when on.
/// Matches `main_power_btn_cb` (usrLightingPage.c/usrSocketsPage.c/
/// usrBigRelayPage.c), styled to match the premium glassmorphism power
/// button on the Lighting screen.
class ControlPowerButton extends StatelessWidget {
  const ControlPowerButton({super.key, required this.isOn, required this.onTap, this.size = 160});

  final bool isOn;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF0D0E12),
          border: Border.all(
            color: isOn ? AppColors.accent.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.05),
            width: 1,
          ),
          boxShadow: isOn
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.2),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                  const BoxShadow(
                    color: Color(0xFF0D0E12),
                    blurRadius: 20,
                    spreadRadius: -5,
                    offset: Offset(0, 10),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.6),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
        ),
        child: Center(
          child: Icon(
            Icons.power_settings_new_rounded,
            size: size * 0.35,
            color: isOn ? AppColors.accent : Colors.white24,
          ),
        ),
      ),
    );
  }
}
