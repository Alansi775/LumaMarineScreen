import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/control_panel/control_page_header.dart';
import '../application/tanks_controller.dart';
import 'widgets/tank_grid_card.dart';
import 'widgets/tank_scroll_more_button.dart';

/// 3-column scrollable tank grid with an animated "scroll for more"
/// button — matches usrTankLevelPage.c's real grid + vertical-scroll
/// page_container pattern.
class TanksScreen extends ConsumerStatefulWidget {
  const TanksScreen({super.key});

  @override
  ConsumerState<TanksScreen> createState() => _TanksScreenState();
}

class _TanksScreenState extends ConsumerState<TanksScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollMore() {
    if (!_scrollController.hasClients) return;
    final target = (_scrollController.offset + 340)
        .clamp(0.0, _scrollController.position.maxScrollExtent);
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tanks = ref.watch(tanksControllerProvider);
    final notifier = ref.read(tanksControllerProvider.notifier);
    final hasMore = tanks.length > 3;

    return Column(
      children: [
        const ControlPageHeader(
          icon: Icons.water_drop_outlined,
          title: 'TANK LEVEL',
          subtitle: 'TANK MONITOR',
        ),
        Expanded(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
                child: GridView.builder(
                  controller: _scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 0.68,
                  ),
                  itemCount: tanks.length,
                  itemBuilder: (context, i) {
                    final tank = tanks[i];
                    return TankGridCard(
                      tank: tank,
                      onEmpty: tank.id == 'waste' ? () => notifier.empty(tank.id) : null,
                    );
                  },
                ),
              ),
              if (hasMore)
                Positioned(
                  bottom: 12,
                  left: 0,
                  right: 0,
                  child: Center(child: TankScrollMoreButton(onTap: _scrollMore)),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
