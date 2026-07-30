import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_strings.dart';
import '../../core/providers/clock_tick_provider.dart';
import '../../core/theme/app_colors.dart';

/// Full-width top bar: Luma branding on the left, the system title
/// centered, and live clock/date + a row of status icons on the right —
/// matches the reference SCADA design's top bar exactly.
class DashboardTopBar extends ConsumerWidget {
  const DashboardTopBar({super.key});

  static const double height = 84;
  static const _weekdays = [
    'PAZARTESİ', 'SALI', 'ÇARŞAMBA', 'PERŞEMBE', 'CUMA', 'CUMARTESİ', 'PAZAR',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(clockTickProvider).valueOrNull ?? DateTime.now();
    final time =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    final date = '${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year} '
        '${_weekdays[now.weekday - 1]}';

    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.hairline)),
      ),
      child: Row(
        children: [
          // ================= Sol: Luma marka =================
          Image.asset('assets/images/luma_marine_logo_white.png', height: 40),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'LUMA MARINE',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 1),
              ),
              const Text(
                AppStrings.tagline,
                style: TextStyle(color: AppColors.textTertiary, fontSize: 9, letterSpacing: 1.5),
              ),
              Text(
                AppStrings.versionPlaceholder,
                style: const TextStyle(color: AppColors.textTertiary, fontSize: 9),
              ),
            ],
          ),

          // ================= Orta: başlık =================
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  AppStrings.mainTitle,
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: 1.5),
                ),
                const SizedBox(height: 4),
                const Text(
                  AppStrings.mainSubtitle,
                  style: TextStyle(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 2),
                ),
              ],
            ),
          ),

          // ================= Sağ: saat + ikonlar =================
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                time,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              Text(date, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
            ],
          ),
          const SizedBox(width: 20),
          const _TopBarIcon(icon: Icons.anchor_outlined),
          const SizedBox(width: 8),
          const _TopBarIcon(icon: Icons.notifications_outlined, badgeCount: 3),
          const SizedBox(width: 8),
          const _TopBarIcon(icon: Icons.settings_outlined),
          const SizedBox(width: 8),
          const _TopBarIcon(icon: Icons.power_settings_new_rounded, danger: true),
        ],
      ),
    );
  }
}

class _TopBarIcon extends StatelessWidget {
  const _TopBarIcon({required this.icon, this.badgeCount, this.danger = false});

  final IconData icon;
  final int? badgeCount;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surfaceHighlight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.hairline),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, size: 20, color: danger ? AppColors.warning : AppColors.textSecondary),
              if (badgeCount != null && badgeCount! > 0)
                Positioned(
                  right: -6,
                  top: -6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: const BoxDecoration(color: AppColors.warning, shape: BoxShape.circle),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    alignment: Alignment.center,
                    child: Text(
                      '$badgeCount',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
