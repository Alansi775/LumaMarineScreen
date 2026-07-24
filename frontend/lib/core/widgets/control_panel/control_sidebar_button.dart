import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// One channel entry in a control page's left sidebar — borderless, a
/// small glow dot marks on/off state. Tapping it only *selects* the
/// channel (shows it in the center detail panel); it does not toggle
/// on/off — that's what the center power button is for. Matches
/// `sidebar_btn_cb` in usrLightingPage.c/usrSocketsPage.c/usrBigRelayPage.c,
/// styled to match the premium glassmorphism list item on Lighting/Tanks.
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
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isOn ? AppColors.accent : (isSelected ? Colors.white54 : Colors.transparent),
                boxShadow: isOn ? [BoxShadow(color: AppColors.accent, blurRadius: 6)] : [],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: AppTextStyles.bodyStrong.copyWith(
                  color: isSelected ? Colors.white : Colors.white38,
                  fontSize: isSelected ? 15 : 14,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  letterSpacing: 1.5,
                ),
                child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}
