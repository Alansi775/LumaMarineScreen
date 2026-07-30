import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/telemetry/dashboard_bus_service.dart';
import '../../../core/telemetry/dashboard_can_ids.dart';
import '../domain/engine_reading.dart';

part 'engine_room_controller.g.dart';

class EngineRoomState {
  const EngineRoomState({required this.iskele, required this.sancak});

  final EngineReading iskele;
  final EngineReading sancak;
}

EngineReading _mockEngine(Random random, {required double baseRpm}) {
  return EngineReading(
    rpm: (baseRpm + random.nextInt(120) - 60).round(),
    tempC: 78 + random.nextDouble() * 14,
    oilBar: 3.2 + random.nextDouble() * 0.6,
    loadPercent: 55 + random.nextDouble() * 30,
  );
}

/// MAKİNE BİLGİLERİ — İskele/Sancak motor readings. Not explicitly
/// classified real-vs-placeholder in the client's spec (only system
/// control toggles + tank levels were confirmed "fully real now"), so
/// this is mock-backed like generators/electrical until engine sensors
/// are confirmed installed.
@riverpod
class EngineRoomController extends _$EngineRoomController {
  final _random = Random();

  @override
  EngineRoomState build() {
    final bus = ref.watch(dashboardBusServiceProvider);
    bus.ensureMockChannel(DashboardCanIds.engineIskele, () => _mockEngine(_random, baseRpm: 1450));
    bus.ensureMockChannel(DashboardCanIds.engineSancak, () => _mockEngine(_random, baseRpm: 1460));

    final subs = [
      bus.frames(DashboardCanIds.engineIskele).listen((f) {
        state = EngineRoomState(iskele: f.payload as EngineReading, sancak: state.sancak);
      }),
      bus.frames(DashboardCanIds.engineSancak).listen((f) {
        state = EngineRoomState(iskele: state.iskele, sancak: f.payload as EngineReading);
      }),
    ];
    ref.onDispose(() {
      for (final s in subs) {
        s.cancel();
      }
    });

    return EngineRoomState(
      iskele: _mockEngine(_random, baseRpm: 1450),
      sancak: _mockEngine(_random, baseRpm: 1460),
    );
  }
}
