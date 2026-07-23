import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/control_panel/control_page_header.dart';
import '../../../core/widgets/control_panel/control_pill_button.dart';
import '../application/shunt_controller.dart';
import 'widgets/battery_arc_card.dart';
import 'widgets/main_shunt_card.dart';
import 'widgets/quadro_shunt_card.dart';
import 'widgets/shunt_relay_controls.dart';

/// Main 300A shunt bar flanked by 2 battery arcs, 4 quadro 30A shunts
/// below, relay controls at the bottom — matches usrShuntPage.c's real
/// layout exactly (main_shunt_container + battery_containers +
/// quadro_containers + relay_control_container).
class ShuntScreen extends ConsumerWidget {
  const ShuntScreen({super.key});

  static const _quadroColors = [AppColors.accent, AppColors.solar, AppColors.water, AppColors.fuel];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(shuntControllerProvider);
    final notifier = ref.read(shuntControllerProvider.notifier);

    return Column(
      children: [
        ControlPageHeader(
          icon: Icons.bolt_outlined,
          title: 'SHUNT',
          subtitle: state.testMode
              ? 'SHUNT CURRENT MONITOR [TEST MODE]'
              : 'SHUNT CURRENT MONITOR [REAL MODE]',
          trailing: ControlPillButton(
            label: state.testMode ? 'TEST' : 'REAL',
            active: state.testMode,
            onTap: () => notifier.setTestMode(!state.testMode),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BatteryArcCard(reading: state.batteries[0], color: AppColors.accent),
                    const SizedBox(width: 28),
                    Expanded(child: MainShuntCard(reading: state.mainShunt)),
                    const SizedBox(width: 28),
                    BatteryArcCard(reading: state.batteries[1], color: AppColors.solar),
                  ],
                ),
                const SizedBox(height: 28),
                Expanded(
                  child: Row(
                    children: [
                      for (var i = 0; i < state.quadroShunts.length; i++) ...[
                        Expanded(
                          child: QuadroShuntCard(
                            reading: state.quadroShunts[i],
                            color: _quadroColors[i % _quadroColors.length],
                          ),
                        ),
                        if (i < state.quadroShunts.length - 1) const SizedBox(width: AppDimensions.gutter),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const ShuntRelayControls(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
