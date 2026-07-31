import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/telemetry/dashboard_bus_service.dart';
import '../../../core/telemetry/dashboard_can_ids.dart';
import '../domain/system_controls_state.dart';

part 'system_controls_controller.g.dart';

/// SİSTEM KONTROLLERİ (minus lighting, which reads straight from
/// `lightingControllerProvider`) — every toggle here is confirmed
/// "fully real": each already has its own CAN id and sends a real
/// packet once hardware is connected (currently logged by
/// [MockDashboardBusService] instead of transmitted).
@riverpod
class SystemControlsController extends _$SystemControlsController {
  @override
  SystemControlsState build() => const SystemControlsState();

  void _send(int canId, Object? payload) => ref.read(dashboardBusServiceProvider).sendCommand(canId, payload);

  void cycleSintinePompa() {
    final next = switch (state.sintinePompa) {
      SintineMode.kapali => SintineMode.acik,
      SintineMode.acik => SintineMode.otomatik,
      SintineMode.otomatik => SintineMode.kapali,
    };
    state = state.copyWith(sintinePompa: next);
    _send(DashboardCanIds.sintinePompa, next.name);
  }

  void toggleIrgat() {
    final next = !state.irgat;
    state = state.copyWith(irgat: next);
    _send(DashboardCanIds.irgat, next);
  }

  void toggleHorn() {
    final next = !state.horn;
    state = state.copyWith(horn: next);
    _send(DashboardCanIds.horn, next);
  }
}
