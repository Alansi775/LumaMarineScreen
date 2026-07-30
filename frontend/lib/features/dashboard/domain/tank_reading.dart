import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';

enum DashboardTankType { yakit, tatliSu, pisSu, sintine }

extension DashboardTankTypeMeta on DashboardTankType {
  String get label => switch (this) {
        DashboardTankType.yakit => AppStrings.yakit,
        DashboardTankType.tatliSu => AppStrings.tatliSu,
        DashboardTankType.pisSu => AppStrings.pisSu,
        DashboardTankType.sintine => AppStrings.sintine,
      };

  Color get color => switch (this) {
        DashboardTankType.yakit => AppColors.success,
        DashboardTankType.tatliSu => AppColors.solar,
        DashboardTankType.pisSu => AppColors.fuel,
        DashboardTankType.sintine => AppColors.warning,
      };
}

class TankReading {
  const TankReading({required this.type, required this.percent, required this.liters});

  final DashboardTankType type;
  final double percent;
  final double liters;
}
