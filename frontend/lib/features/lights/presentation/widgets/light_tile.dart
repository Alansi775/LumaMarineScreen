import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/light_model.dart';

/// A single light control surface. Tapping toggles on/off; the "on" state
/// is visually satisfying (warm glow + filled icon) since this is the
/// control the owner touches most.
class LightTile extends StatelessWidget {
  const LightTile({super.key, required this.light, required this.onToggle});

  final Light light;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final isOn = light.isOn;
    final glowColor = const Color(0xFFFFC876);

    return GestureDetector(
      onTap: onToggle,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(
            color: isOn ? glowColor.withValues(alpha: 0.55) : AppColors.hairline,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isOn
                ? [glowColor.withValues(alpha: 0.22), AppColors.surface]
                : [AppColors.surfaceRaised.withValues(alpha: 0.5), AppColors.surface],
          ),
          boxShadow: isOn
              ? [
                  BoxShadow(
                    color: glowColor.withValues(alpha: 0.28),
                    blurRadius: 24,
                    spreadRadius: -4,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isOn ? glowColor.withValues(alpha: 0.16) : AppColors.gaugeTrack,
              ),
              child: Icon(
                light.icon,
                size: 24,
                color: isOn ? glowColor : AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              light.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyStrong.copyWith(
                color: isOn ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isOn ? 'ON' : 'OFF',
              style: AppTextStyles.caption.copyWith(
                color: isOn ? glowColor : AppColors.textTertiary,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
