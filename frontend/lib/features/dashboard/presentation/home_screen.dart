import 'package:flutter/material.dart';

import 'widgets/electrical_panel.dart';
import 'widgets/generator_panel.dart';
import 'widgets/machine_info_panel.dart';
import 'widgets/quick_access_panel.dart';
import 'widgets/status_cards_row.dart';
import 'widgets/system_controls_panel.dart';
import 'widgets/tank_levels_panel.dart';
import 'widgets/yacht_alarms_row.dart';

/// ANA EKRAN — the only sidebar section with real content right now.
/// Sized to target fitting the full 1280x800 kiosk screen with no
/// scrolling per the reference design, wrapped in a scroll view as a
/// safety net since exact fit can't be pixel-verified without the
/// physical device.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      child: Column(
        children: [
          const StatusCardsRow(),
          const SizedBox(height: 12),
          const YachtAlarmsRow(),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: Row(
              children: const [
                Expanded(child: MachineInfoPanel()),
                SizedBox(width: 12),
                Expanded(child: GeneratorPanel()),
                SizedBox(width: 12),
                Expanded(child: ElectricalPanel()),
                SizedBox(width: 12),
                Expanded(child: TankLevelsPanel()),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 150,
            child: Row(
              children: const [
                Expanded(flex: 3, child: SystemControlsPanel()),
                SizedBox(width: 12),
                Expanded(flex: 1, child: QuickAccessPanel()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
