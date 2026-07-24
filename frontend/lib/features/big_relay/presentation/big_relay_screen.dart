import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/control_panel/control_page_header.dart';
import '../../../core/widgets/control_panel/control_pill_button.dart';
import '../../../core/widgets/control_panel/control_power_button.dart';
import '../../../core/widgets/control_panel/control_sidebar_button.dart';
import '../../../core/widgets/node_status_pill.dart';
import '../application/big_relay_controller.dart';

/// Scrollable 16-channel sidebar (with a live input-feedback dot per row)
/// + center detail panel (power button, ACTIVE/INACTIVE, INPUT PASSIVE/
/// ACTIVE, Refresh) — matches usrBigRelayPage.c's real layout exactly.
class BigRelayScreen extends ConsumerStatefulWidget {
  const BigRelayScreen({super.key});

  @override
  ConsumerState<BigRelayScreen> createState() => _BigRelayScreenState();
}

class _BigRelayScreenState extends ConsumerState<BigRelayScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bigRelayControllerProvider);
    final notifier = ref.read(bigRelayControllerProvider.notifier);
    final selected = state.channels[_selectedIndex];

    return Container(
      color: const Color(0xFF07080A),
      child: Column(
        children: [
          ControlPageHeader(
            icon: Icons.settings_outlined,
            title: 'BIG RELAY',
            subtitle: '16-CHANNEL BANK',
            trailing: const NodeStatusPill(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.navArrowGutter),
              child: Row(
              children: [
                SizedBox(
                  width: 260,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          itemCount: state.channels.length,
                          itemBuilder: (context, i) {
                            final channel = state.channels[i];
                            return ControlSidebarButton(
                              label: 'Relay ${(i + 1).toString().padLeft(2, '0')}',
                              isSelected: i == _selectedIndex,
                              isOn: channel.outputOn,
                              onTap: () => setState(() => _selectedIndex = i),
                              trailing: channel.inputOn
                                  ? Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.success,
                                      ),
                                    )
                                  : null,
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            ControlPillButton(
                              label: 'Close All',
                              onTap: () => notifier.setAllOutputs(false),
                            ),
                            const SizedBox(height: 16),
                            ControlPillButton(
                              label: state.autoPairEnabled ? 'Auto Pair ON' : 'Auto Pair OFF',
                              active: state.autoPairEnabled,
                              onTap: () => notifier.setAutoPair(!state.autoPairEnabled),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'RELAY ${(_selectedIndex + 1).toString().padLeft(2, '0')}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 10,
                          ),
                        ),
                        const SizedBox(height: 60),
                        ControlPowerButton(
                          isOn: selected.outputOn,
                          onTap: () => notifier.toggleOutput(_selectedIndex),
                        ),
                        const SizedBox(height: 50),
                        Text(
                          selected.outputOn ? 'ACTIVE' : 'STANDBY',
                          style: TextStyle(
                            color: selected.outputOn ? AppColors.accent : Colors.white38,
                            letterSpacing: 6,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          selected.inputOn ? 'INPUT ACTIVE' : 'INPUT PASSIVE',
                          style: TextStyle(
                            color: selected.inputOn ? AppColors.success : Colors.white24,
                            letterSpacing: 3,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
