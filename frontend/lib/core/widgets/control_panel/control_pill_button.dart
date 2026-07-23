import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../../theme/app_text_styles.dart';

/// Generic outlined pill action button — "Close All", "Auto Pair",
/// "Refresh". Matches the sidebar/center-panel footer buttons on every
/// real control page.
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
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.accent.withValues(alpha: 0.14) : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          border: Border.all(color: active ? AppColors.accent : AppColors.hairline, width: active ? 2 : 1),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodyStrong.copyWith(
            color: active ? AppColors.accent : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
