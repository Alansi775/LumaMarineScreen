import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/luma_card.dart';

/// HIZLI ERİŞİM — 4 circular icon buttons. Non-functional placeholders
/// for now (log on tap), per the spec — they navigate nowhere yet.
class QuickAccessPanel extends StatelessWidget {
  const QuickAccessPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return LumaCard(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.hizliErisim,
            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _QuickButton(icon: Icons.tune_rounded, label: AppStrings.manuelKontrol)),
                Expanded(child: _QuickButton(icon: Icons.description_outlined, label: AppStrings.raporlar)),
                Expanded(child: _QuickButton(icon: Icons.videocam_outlined, label: AppStrings.kamera)),
                Expanded(child: _QuickButton(icon: Icons.build_outlined, label: AppStrings.bakim)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickButton extends StatelessWidget {
  const _QuickButton({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => debugPrint('[Dashboard] Hızlı Erişim "$label" tapped (placeholder, no destination yet)'),
      borderRadius: BorderRadius.circular(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceHighlight,
              border: Border.all(color: AppColors.hairline),
            ),
            child: Icon(icon, size: 22, color: AppColors.accent),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.textTertiary, fontSize: 11, letterSpacing: 0.2),
          ),
        ],
      ),
    );
  }
}
