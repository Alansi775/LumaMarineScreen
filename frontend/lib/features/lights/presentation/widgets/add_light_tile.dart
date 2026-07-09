import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'add_light_sheet.dart';

/// Dashed-style entry point at the end of the light grid — the minimal
/// Phase 1 "settings" surface for adding a light.
class AddLightTile extends StatelessWidget {
  const AddLightTile({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showAddLightSheet(context),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(
            color: AppColors.hairline,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.gaugeTrack,
              ),
              child: const Icon(Icons.add_rounded, size: 24, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 14),
            Text('Add Light', style: AppTextStyles.bodyStrong.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            Text('NEW', style: AppTextStyles.caption.copyWith(letterSpacing: 1.5)),
          ],
        ),
      ),
    );
  }
}
