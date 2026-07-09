import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/vertical_bar_gauge.dart';
import '../../domain/tank_model.dart';

Color tankColor(TankKind kind) {
  return switch (kind) {
    TankKind.freshWater => AppColors.water,
    TankKind.waste => AppColors.waste,
    TankKind.fuel => AppColors.fuel,
  };
}

/// One tank: live fill gauge plus either a passive "LIVE" monitoring hint
/// (fresh water) or a tappable "PRESS TO EMPTY" pump action (waste).
class TankColumn extends StatelessWidget {
  const TankColumn({super.key, required this.tank, this.onEmpty});

  final Tank tank;
  final VoidCallback? onEmpty;

  @override
  Widget build(BuildContext context) {
    final color = tankColor(tank.kind);
    final isTappable = onEmpty != null;

    final column = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        VerticalBarGaugeColumn(
          label: tank.name.toUpperCase(),
          value: tank.level,
          color: color,
          valueText: '${(tank.level * 100).round()}%',
          subText: '${tank.liters.round()} L',
          barWidth: 64,
          barHeight: 280,
        ),
        const SizedBox(height: 16),
        if (isTappable)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.touch_app_outlined, size: 14, color: color),
              const SizedBox(width: 6),
              Text(
                'PRESS TO EMPTY',
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  letterSpacing: 1.4,
                ),
              ),
            ],
          )
        else
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
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

    if (!isTappable) return column;

    return GestureDetector(
      onTap: onEmpty,
      behavior: HitTestBehavior.opaque,
      child: column,
    );
  }
}
