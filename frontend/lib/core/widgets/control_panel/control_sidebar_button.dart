import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// One channel entry in a control page's left sidebar — borderless, an
/// on/off icon plus a small glow dot mark state. Tapping it only
/// *selects* the channel (shows it in the center detail panel); it does
/// not toggle on/off — that's what the center power button is for.
/// Matches `sidebar_btn_cb` in usrLightingPage.c/usrSocketsPage.c/
/// usrBigRelayPage.c, styled to match the premium glassmorphism list
/// item on Lighting/Tanks.
class ControlSidebarButton extends StatelessWidget {
  const ControlSidebarButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isOn = false,
    this.trailing,
    this.iconOn = Icons.power_rounded,
    this.iconOff = Icons.power_outlined,
  });

  final String label;
  final bool isSelected;
  final bool isOn;
  final VoidCallback onTap;
  final Widget? trailing;
  final IconData iconOn;
  final IconData iconOff;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Icon(
                isOn ? iconOn : iconOff,
                key: ValueKey(isOn),
                size: 20,
                color: isOn ? AppColors.accent : (isSelected ? Colors.white54 : Colors.white24),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: AppTextStyles.bodyStrong.copyWith(
                  color: isSelected ? Colors.white : Colors.white38,
                  fontSize: isSelected ? 18 : 17,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  letterSpacing: 1.5,
                ),
                child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ),
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
            ?trailing,
          ],
        ),
      ),
    );
  }
}
