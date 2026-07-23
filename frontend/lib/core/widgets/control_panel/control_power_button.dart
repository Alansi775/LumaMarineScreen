import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// The big circular power button every real control page centers its
/// detail panel on — an outer ring plus a glowing filled circle when on.
/// Matches `main_power_btn_cb` (usrLightingPage.c/usrSocketsPage.c/
/// usrBigRelayPage.c).
class ControlPowerButton extends StatelessWidget {
  const ControlPowerButton({super.key, required this.isOn, required this.onTap, this.size = 190});

  final bool isOn;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    final innerSize = size * 0.8;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isOn ? AppColors.accent.withValues(alpha: 0.4) : AppColors.hairline,
                  width: 2,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: innerSize,
              height: innerSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isOn ? AppColors.accent.withValues(alpha: 0.16) : AppColors.surface,
                border: Border.all(
                  color: isOn ? AppColors.accent : AppColors.textTertiary.withValues(alpha: 0.4),
                  width: 2,
                ),
                boxShadow: isOn
                    ? [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.4),
                          blurRadius: 30,
                          spreadRadius: -4,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                Icons.power_settings_new_rounded,
                size: innerSize * 0.34,
                color: isOn ? AppColors.accent : AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
