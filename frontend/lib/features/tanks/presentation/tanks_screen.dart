import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/control_panel/control_page_header.dart';
import '../../../core/widgets/control_panel/control_pill_button.dart';
import '../application/tanks_controller.dart';
import '../domain/tank_model.dart';
import 'widgets/add_tank_tile.dart';
import 'widgets/tank_grid_card.dart';
import 'widgets/tank_scroll_more_button.dart';

/// Two labeled sensor-type sections (0-190Ω / 30-240Ω), 3 tanks each by
/// default, whole page vertically scrollable with an animated
/// "scroll for more" button — matches usrTankLevelPage.c's real
/// grid + `LV_DIR_VER` page_container scroll pattern. TEST/REAL toggle
/// in the header mirrors their `TEST_MODE` exactly.
class TanksScreen extends ConsumerStatefulWidget {
  const TanksScreen({super.key});

  @override
  ConsumerState<TanksScreen> createState() => _TanksScreenState();
}

class _TanksScreenState extends ConsumerState<TanksScreen> {
  final _scrollController = ScrollController();
  bool _canScrollUp = false;
  bool _canScrollDown = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateScrollState);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateScrollState());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollState);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateScrollState() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final canUp = position.pixels > 4;
    final canDown = position.pixels < position.maxScrollExtent - 4;
    if (canUp != _canScrollUp || canDown != _canScrollDown) {
      setState(() {
        _canScrollUp = canUp;
        _canScrollDown = canDown;
      });
    }
  }

  void _scrollBy(double delta) {
    if (!_scrollController.hasClients) return;
    final target = (_scrollController.offset + delta)
        .clamp(0.0, _scrollController.position.maxScrollExtent);
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tanksControllerProvider);
    final notifier = ref.read(tanksControllerProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateScrollState());

    final ohms0Tanks = state.tanks.where((t) => t.sensorType == TankSensorType.ohms0to190).toList();
    final ohms30Tanks = state.tanks.where((t) => t.sensorType == TankSensorType.ohms30to240).toList();

    return Column(
      children: [
        ControlPageHeader(
          icon: Icons.water_drop_outlined,
          title: 'TANK LEVEL',
          subtitle: state.testMode ? 'TANK MONITOR [TEST MODE]' : 'TANK MONITOR [REAL MODE]',
          trailing: ControlPillButton(
            label: state.testMode ? 'TEST' : 'REAL',
            active: state.testMode,
            onTap: () => notifier.setTestMode(!state.testMode),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(28, 24, 28, 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('0–190Ω', style: AppTextStyles.sectionLabel),
                    const SizedBox(height: 16),
                    _TankGrid(
                      tanks: ohms0Tanks,
                      onAdd: () => notifier.addTank(TankSensorType.ohms0to190),
                    ),
                    const SizedBox(height: 32),
                    Text('30–240Ω', style: AppTextStyles.sectionLabel),
                    const SizedBox(height: 16),
                    _TankGrid(
                      tanks: ohms30Tanks,
                      onAdd: () => notifier.addTank(TankSensorType.ohms30to240),
                    ),
                  ],
                ),
              ),
              if (_canScrollUp)
                Positioned(
                  top: 8,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: TankScrollMoreButton(
                      pointDown: false,
                      onTap: () => _scrollBy(-320),
                    ),
                  ),
                ),
              if (_canScrollDown)
                Positioned(
                  bottom: 12,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: TankScrollMoreButton(
                      onTap: () => _scrollBy(320),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TankGrid extends StatelessWidget {
  const _TankGrid({required this.tanks, required this.onAdd});

  final List<Tank> tanks;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 0.68,
      ),
      itemCount: tanks.length + 1,
      itemBuilder: (context, i) {
        if (i == tanks.length) return AddTankTile(onTap: onAdd);
        return TankGridCard(tank: tanks[i]);
      },
    );
  }
}
