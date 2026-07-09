import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/circular_gauge.dart';
import '../../../../core/widgets/luma_card.dart';
import '../../../batteries/application/battery_providers.dart';

/// The centerpiece of Overview: the main battery gauge plus a
/// directional time-remaining readout beneath it.
class MainBatteryHero extends ConsumerWidget {
  const MainBatteryHero({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final battery = ref.watch(mainBatteryProvider).valueOrNull;

    final percentText = battery == null
        ? '--%'
        : '${(battery.percentage * 100).round()}%';

    final hours = battery?.timeRemaining.inHours ?? 0;
    final minutes = (battery?.timeRemaining.inMinutes ?? 0) % 60;

    return LumaCard(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularGaugeReading(
            value: battery?.percentage ?? 0,
            percentText: percentText,
            label: 'MAIN BATTERY',
            size: 240,
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                battery?.isCharging ?? true
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                size: 16,
                color: battery?.isCharging ?? true
                    ? AppColors.success
                    : AppColors.warning,
              ),
              const SizedBox(width: 6),
              Text(
                '${hours}h ${minutes}m ${battery?.isCharging ?? true ? 'to full' : 'remaining'}',
                style: AppTextStyles.body,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
