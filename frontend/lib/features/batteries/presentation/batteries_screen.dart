import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/luma_card.dart';
import '../../../core/widgets/section_label.dart';
import '../application/battery_providers.dart';
import 'widgets/circuit_row.dart';
import 'widgets/main_battery_summary.dart';

class BatteriesScreen extends ConsumerWidget {
  const BatteriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final circuits = ref.watch(batteryCircuitsProvider).valueOrNull ?? [];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.pagePadding,
          AppDimensions.pagePadding,
          AppDimensions.pagePadding,
          AppDimensions.pagePadding + 40,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Expanded(flex: 4, child: MainBatterySummary()),
            const SizedBox(width: AppDimensions.gutter),
            Expanded(
              flex: 6,
              child: LumaCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionLabel('CIRCUITS'),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.separated(
                        itemCount: circuits.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, i) =>
                            CircuitRow(circuit: circuits[i]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
