import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../application/overview_providers.dart';

/// The Overview screen's sole hero content — no batteries, no pressure,
/// just time and date (manager's direction: their real project has
/// neither, and this screen should stay simple).
class TimeDateDisplay extends ConsumerWidget {
  const TimeDateDisplay({super.key});

  static const _weekdays = [
    'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY',
    'FRIDAY', 'SATURDAY', 'SUNDAY',
  ];
  static const _months = [
    'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(clockTickProvider).valueOrNull ?? DateTime.now();
    final hh = now.hour.toString().padLeft(2, '0');
    final mm = now.minute.toString().padLeft(2, '0');
    final date =
        '${_weekdays[now.weekday - 1]} · ${now.day} ${_months[now.month - 1]}';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$hh:$mm', style: AppTextStyles.displayNumeral.copyWith(fontSize: 140)),
        const SizedBox(height: 16),
        Text(date, style: AppTextStyles.sectionLabel.copyWith(fontSize: 20, letterSpacing: 4)),
      ],
    );
  }
}
