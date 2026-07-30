import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/circular_gauge.dart';
import '../../../../core/widgets/luma_card.dart';
import '../../application/tank_levels_controller.dart';
import '../../domain/tank_reading.dart';

/// TANK SEVİYELERİ — 4 ring gauges (YAKIT/TATLI SU/PİS SU/SİNTİNE),
/// percentage in the center, liters below. Sensors already installed —
/// this is real production data once hardware is connected, no
/// placeholder treatment.
class TankLevelsPanel extends ConsumerWidget {
  const TankLevelsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tanks = ref.watch(tankLevelsControllerProvider);

    return LumaCard(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.tankSeviyeleri,
            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Row(
              children: [for (final tank in tanks) Expanded(child: _TankGaugeTile(tank: tank))],
            ),
          ),
        ],
      ),
    );
  }
}

class _TankGaugeTile extends StatelessWidget {
  const _TankGaugeTile({required this.tank});

  final TankReading tank;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularGauge(
          value: tank.percent / 100,
          size: 68,
          color: tank.type.color,
          strokeWidth: 8,
          startAngleDeg: 0,
          sweepAngleDeg: 360,
          centerLabel: Text(
            '%${tank.percent.toStringAsFixed(0)}',
            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          tank.type.label,
          style: const TextStyle(color: AppColors.textTertiary, fontSize: 8.5, letterSpacing: 0.3),
        ),
        Text(
          '${tank.liters.toStringAsFixed(0)} L',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 9, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
