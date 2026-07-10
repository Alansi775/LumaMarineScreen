import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/circular_gauge.dart';
import '../../../../core/widgets/luma_card.dart';
import '../../application/battery_providers.dart';

/// Compact second battery arc — the reserve/backup bank, alongside the
/// main house battery. Matches the ESP32 Shunt Monitor page's 2-battery
/// layout.
class BackupBatteryCard extends ConsumerWidget {
  const BackupBatteryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final battery = ref.watch(backupBatteryProvider).valueOrNull;
    final percentText = battery == null ? '--%' : '${(battery.percentage * 100).round()}%';

    return LumaCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        children: [
          CircularGauge(
            value: battery?.percentage ?? 0,
            size: 64,
            strokeWidth: 7,
            color: AppColors.solar,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('BACKUP BATTERY', style: AppTextStyles.caption.copyWith(letterSpacing: 1.2)),
                const SizedBox(height: 4),
                Text(percentText, style: AppTextStyles.numeralMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
