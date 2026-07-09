import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/door_model.dart';

/// A momentary press-to-open control. Visually pulses while [door.isOpen]
/// is true, then settles back to its resting "closed" look — the controller
/// flips the state back automatically, this widget just reflects it.
class DoorTile extends StatelessWidget {
  const DoorTile({super.key, required this.door, required this.onTrigger});

  final Door door;
  final VoidCallback onTrigger;

  @override
  Widget build(BuildContext context) {
    final isOpen = door.isOpen;
    final color = AppColors.solar;

    return GestureDetector(
      onTap: onTrigger,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(
            color: isOpen ? color.withValues(alpha: 0.6) : AppColors.hairline,
          ),
          color: AppColors.surface,
          boxShadow: isOpen
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 24,
                    spreadRadius: -4,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isOpen ? color.withValues(alpha: 0.16) : AppColors.gaugeTrack,
              ),
              child: Icon(
                isOpen ? Icons.lock_open_rounded : door.icon,
                size: 24,
                color: isOpen ? color : AppColors.textTertiary,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(door.name, style: AppTextStyles.bodyStrong),
                  const SizedBox(height: 4),
                  Text(
                    isOpen ? 'RELEASING…' : 'PRESS TO OPEN',
                    style: AppTextStyles.caption.copyWith(
                      color: isOpen ? color : AppColors.textTertiary,
                      letterSpacing: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
