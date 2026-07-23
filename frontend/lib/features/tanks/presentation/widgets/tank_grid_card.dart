import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/tank_model.dart';
import 'tank_config_sheet.dart';

Color tankColor(TankSensorType sensorType) {
  return switch (sensorType) {
    TankSensorType.ohms0to190 => AppColors.water,
    TankSensorType.ohms30to240 => AppColors.fuel,
  };
}

/// One tank card: name, thin accent line, a rectangular liquid-fill area
/// with the percentage centered inside it, another accent line, then
/// liters/sensor type — matches `usrTankLevelPage_createTankWidget`'s
/// real layout exactly (name / line / tank_area+bar / line / info). Tap
/// anywhere to configure (name, capacity, sensor type).
class TankGridCard extends StatelessWidget {
  const TankGridCard({super.key, required this.tank});

  final Tank tank;

  @override
  Widget build(BuildContext context) {
    final color = tankColor(tank.sensorType);

    return GestureDetector(
      onTap: () => showTankConfigSheet(context, tank),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(color: AppColors.hairline),
        ),
        child: Column(
          children: [
            Text(
              tank.name.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyStrong,
            ),
            const SizedBox(height: 10),
            Container(width: 90, height: 3, color: color),
            const SizedBox(height: 4),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.gaugeTrack,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: tank.level, end: tank.level),
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeInOutCubic,
                        builder: (context, animatedValue, _) {
                          return Align(
                            alignment: Alignment.bottomCenter,
                            child: FractionallySizedBox(
                              heightFactor: animatedValue.clamp(0.02, 1.0),
                              widthFactor: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: [
                                    BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 12),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      '${(tank.level * 100).round()}%',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.cardNumeral.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Container(width: 90, height: 3, color: color),
            const SizedBox(height: 10),
            Text('${tank.liters.round()} L', style: AppTextStyles.bodyStrong),
            Text(tank.sensorType.label, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}
