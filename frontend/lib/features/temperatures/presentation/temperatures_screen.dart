import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/luma_card.dart';
import '../../../core/widgets/section_label.dart';
import '../application/temperatures_controller.dart';
import 'widgets/temperature_column.dart';

class TemperaturesScreen extends ConsumerWidget {
  const TemperaturesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sensors = ref.watch(temperaturesControllerProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.pagePadding,
          AppDimensions.pagePadding,
          AppDimensions.pagePadding,
          AppDimensions.pagePadding + 40,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionLabel('TEMPERATURES'),
            const SizedBox(height: 20),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (final sensor in sensors)
                    LumaCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 32,
                      ),
                      child: TemperatureColumn(sensor: sensor),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
