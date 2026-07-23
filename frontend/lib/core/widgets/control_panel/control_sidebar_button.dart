import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../../theme/app_text_styles.dart';

/// One channel entry in a control page's left sidebar — pill-shaped,
/// glowing accent border when selected. Tapping it only *selects* the
/// channel (shows it in the center detail panel); it does not toggle
/// on/off — that's what the center power button is for. Matches
/// `sidebar_btn_cb` in usrLightingPage.c/usrSocketsPage.c/usrBigRelayPage.c.
class ControlSidebarButton extends StatelessWidget {
  const ControlSidebarButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isOn = false,
    this.trailing,
  });

  final String label;
  final bool isSelected;
  final bool isOn;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accent.withValues(alpha: 0.14) : Colors.transparent,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            border: Border.all(
              color: isSelected ? AppColors.accent : AppColors.hairline,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.35),
                      blurRadius: 16,
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              if (isOn)
                Container(
                  width: 7,
                  height: 7,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.success),
                ),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyStrong.copyWith(
                    color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}
