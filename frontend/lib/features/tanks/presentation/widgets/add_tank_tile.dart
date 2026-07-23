import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Dashed-style "add a tank" entry, same affordance pattern as
/// AddLightTile — tap to append a new tank to this sensor-type group.
class AddTankTile extends StatelessWidget {
  const AddTankTile({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(color: AppColors.hairline),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.gaugeTrack),
              child: const Icon(Icons.add_rounded, size: 22, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 10),
            Text('Add Tank', style: AppTextStyles.caption.copyWith(letterSpacing: 1)),
          ],
        ),
      ),
    );
  }
}
