import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/circular_gauge.dart';
import '../../../../core/widgets/luma_card.dart';
import '../../application/battery_providers.dart';

class MainBatterySummary extends ConsumerWidget {
  const MainBatterySummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final battery = ref.watch(mainBatteryProvider).valueOrNull;
    final percentText =
        battery == null ? '--%' : '${(battery.percentage * 100).round()}%';
    final hours = battery?.timeRemaining.inHours ?? 0;
    final minutes = (battery?.timeRemaining.inMinutes ?? 0) % 60;

    return LumaCard(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularGaugeReading(
            value: battery?.percentage ?? 0,
            percentText: percentText,
            label: 'MAIN BATTERY',
            size: 196,
          ),
          const SizedBox(height: 26),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _Stat(
                label: 'VOLTAGE',
                value: '${battery?.voltage.toStringAsFixed(1) ?? '--'}V',
              ),
              Container(width: 1, height: 34, color: AppColors.hairline),
              _Stat(
                label: 'CURRENT',
                value:
                    '${battery != null && battery.amps >= 0 ? '+' : ''}${battery?.amps.toStringAsFixed(1) ?? '--'}A',
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            battery?.isCharging ?? true
                ? '${hours}h ${minutes}m to full charge'
                : '${hours}h ${minutes}m remaining',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.numeralMedium),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}
