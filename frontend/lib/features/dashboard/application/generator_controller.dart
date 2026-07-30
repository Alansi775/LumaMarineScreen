import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/telemetry/dashboard_bus_service.dart';
import '../../../core/telemetry/dashboard_can_ids.dart';
import '../domain/dc_reading.dart';

part 'generator_controller.g.dart';

class GeneratorState {
  const GeneratorState({required this.jenset1, required this.jenset2});

  final DcReading jenset1;
  final DcReading jenset2;
}

DcReading _mockGenerator(Random random, {required double baseVoltage}) {
  return DcReading(
    voltageDc: baseVoltage + random.nextDouble() * 0.6 - 0.3,
    ampsDc: 8 + random.nextDouble() * 6,
  );
}

/// JENERATÖRLER — reference design shows AC Volt/Hz/kW; confirmed with
/// client that current hardware is DC-only, so this shows DC volt+amp
/// instead. Mock-backed until real telemetry is wired in.
@riverpod
class GeneratorController extends _$GeneratorController {
  final _random = Random();

  @override
  GeneratorState build() {
    final bus = ref.watch(dashboardBusServiceProvider);
    bus.ensureMockChannel(DashboardCanIds.jenset1, () => _mockGenerator(_random, baseVoltage: 27.6));
    bus.ensureMockChannel(DashboardCanIds.jenset2, () => _mockGenerator(_random, baseVoltage: 27.4));

    final subs = [
      bus.frames(DashboardCanIds.jenset1).listen((f) {
        state = GeneratorState(jenset1: f.payload as DcReading, jenset2: state.jenset2);
      }),
      bus.frames(DashboardCanIds.jenset2).listen((f) {
        state = GeneratorState(jenset1: state.jenset1, jenset2: f.payload as DcReading);
      }),
    ];
    ref.onDispose(() {
      for (final s in subs) {
        s.cancel();
      }
    });

    return GeneratorState(
      jenset1: _mockGenerator(_random, baseVoltage: 27.6),
      jenset2: _mockGenerator(_random, baseVoltage: 27.4),
    );
  }
}
