import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/telemetry/dashboard_bus_service.dart';
import '../../../core/telemetry/dashboard_can_ids.dart';
import '../domain/system_controls_state.dart';

part 'system_controls_controller.g.dart';

/// SİSTEM KONTROLLERİ — every toggle here is confirmed "fully real":
/// each already has its own CAN id and sends a real packet once
/// hardware is connected (currently logged by [MockDashboardBusService]
/// instead of transmitted).
@riverpod
class SystemControlsController extends _$SystemControlsController {
  @override
  SystemControlsState build() => const SystemControlsState();

  void _send(int canId, Object? payload) => ref.read(dashboardBusServiceProvider).sendCommand(canId, payload);

  void toggleIcAydinlatma() {
    final next = !state.icAydinlatma;
    state = state.copyWith(icAydinlatma: next);
    _send(DashboardCanIds.icAydinlatma, next);
  }

  void toggleDisAydinlatma() {
    final next = !state.disAydinlatma;
    state = state.copyWith(disAydinlatma: next);
    _send(DashboardCanIds.disAydinlatma, next);
  }

  void togglePompa1() {
    final next = !state.pompa1;
    state = state.copyWith(pompa1: next);
    _send(DashboardCanIds.pompa1, next);
  }

  void togglePompa2() {
    final next = !state.pompa2;
    state = state.copyWith(pompa2: next);
    _send(DashboardCanIds.pompa2, next);
  }

  void cycleSintinePompa() {
    final next = switch (state.sintinePompa) {
      SintineMode.kapali => SintineMode.acik,
      SintineMode.acik => SintineMode.otomatik,
      SintineMode.otomatik => SintineMode.kapali,
    };
    state = state.copyWith(sintinePompa: next);
    _send(DashboardCanIds.sintinePompa, next.name);
  }

  void toggleKlima() {
    final next = !state.klima;
    state = state.copyWith(klima: next);
    _send(DashboardCanIds.klima, next);
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
