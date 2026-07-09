import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/vertical_bar_gauge.dart';
import '../../domain/temperature_sensor.dart';

/// One temperature probe: live fill gauge scaled to its own min/max, with
/// a passive "LIVE MONITORING" hint — same read-only pattern as the fresh
/// water tank.
class TemperatureColumn extends StatelessWidget {
  const TemperatureColumn({super.key, required this.sensor});

  final TemperatureSensor sensor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        VerticalBarGaugeColumn(
          label: sensor.name.toUpperCase(),
          value: sensor.fraction,
          color: AppColors.solar,
          valueText: '${sensor.celsius.toStringAsFixed(1)}°',
          subText:
              '${sensor.minScale.round()}° – ${sensor.maxScale.round()}°C range',
          barWidth: 64,
          barHeight: 280,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'LIVE MONITORING',
              style: AppTextStyles.caption.copyWith(letterSpacing: 1.4),
            ),
          ],
        ),
      ],
    );
  }
}
