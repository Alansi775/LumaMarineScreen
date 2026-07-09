import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../application/overview_providers.dart';

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
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$hh:$mm', style: AppTextStyles.displayNumeral),
        const SizedBox(height: 6),
        Text(date, style: AppTextStyles.sectionLabel),
      ],
    );
  }
}
