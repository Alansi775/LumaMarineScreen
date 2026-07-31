import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/luma_card.dart';
import '../../application/generator_controller.dart';
import '../../domain/dc_reading.dart';

/// JENERATÖRLER — JENSET 1 / JENSET 2 columns. Reference design shows
/// AC Volt/Hz/kW; hardware is DC-only (confirmed with client), so this
/// shows DC voltage + amps instead.
class GeneratorPanel extends ConsumerWidget {
  const GeneratorPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(generatorControllerProvider);

    return LumaCard(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.jeneratorler,
            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _GenColumn(title: AppStrings.jenset1, reading: state.jenset1)),
                Container(width: 1, color: AppColors.hairline, margin: const EdgeInsets.symmetric(horizontal: 10)),
                Expanded(child: _GenColumn(title: AppStrings.jenset2, reading: state.jenset2)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GenColumn extends StatelessWidget {
  const _GenColumn({required this.title, required this.reading});

  final String title;
  final DcReading reading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textTertiary, fontSize: 11, letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(
          '${reading.voltageDc.toStringAsFixed(1)} V',
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text('${reading.ampsDc.toStringAsFixed(1)} A', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        const SizedBox(height: 3),
        Text('${reading.wattsDc.toStringAsFixed(0)} W', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
      ],
    );
  }
}
