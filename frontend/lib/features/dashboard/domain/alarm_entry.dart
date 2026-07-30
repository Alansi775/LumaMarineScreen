import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

enum AlarmSeverity { critical, warning }

extension AlarmSeverityMeta on AlarmSeverity {
  Color get color => switch (this) {
        AlarmSeverity.critical => AppColors.warning,
        AlarmSeverity.warning => AppColors.fuel,
      };

  IconData get icon => switch (this) {
        AlarmSeverity.critical => Icons.error_rounded,
        AlarmSeverity.warning => Icons.warning_rounded,
      };
}

class AlarmEntry {
  const AlarmEntry({
    required this.severity,
    required this.time,
    required this.message,
    required this.location,
  });

  final AlarmSeverity severity;
  final String time;
  final String message;
  final String location;
}
