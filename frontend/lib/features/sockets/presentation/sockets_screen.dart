import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/control_panel/control_page_header.dart';
import '../../../core/widgets/control_panel/control_pill_button.dart';
import '../../../core/widgets/control_panel/control_power_button.dart';
import '../../../core/widgets/control_panel/control_sidebar_button.dart';
import '../../../core/widgets/node_status_pill.dart';
import '../application/sockets_controller.dart';

/// Sidebar (6 channels) + center detail (power button) — no right panel,
/// relays are on/off only. Matches usrSocketsPage.c's real layout.
class SocketsScreen extends ConsumerStatefulWidget {
  const SocketsScreen({super.key});

  @override
  ConsumerState<SocketsScreen> createState() => _SocketsScreenState();
}

class _SocketsScreenState extends ConsumerState<SocketsScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final sockets = ref.watch(socketsControllerProvider);
    final notifier = ref.read(socketsControllerProvider.notifier);

    final index = _selectedIndex.clamp(0, sockets.length - 1);
    final selected = sockets[index];

    return Container(
      color: const Color(0xFF07080A),
      child: Column(
        children: [
          ControlPageHeader(
            icon: Icons.power_outlined,
            title: 'SOCKETS',
            subtitle: 'RELAY CONTROL',
            trailing: const NodeStatusPill(),
          ),
          Expanded(
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
                          itemCount: sockets.length,
                          itemBuilder: (context, i) => ControlSidebarButton(
                            label: sockets[i].name,
                            isSelected: i == index,
                            isOn: sockets[i].isOn,
                            onTap: () => setState(() => _selectedIndex = i),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: ControlPillButton(label: 'Close All', onTap: notifier.allOff),
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
                          selected.name.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 10,
                          ),
                        ),
                        const SizedBox(height: 60),
                        ControlPowerButton(
                          isOn: selected.isOn,
                          onTap: () => notifier.toggle(selected.id),
                        ),
                        const SizedBox(height: 50),
                        Text(
                          selected.isOn ? 'ACTIVE' : 'STANDBY',
                          style: TextStyle(
                            color: selected.isOn ? AppColors.accent : Colors.white38,
                            letterSpacing: 6,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
