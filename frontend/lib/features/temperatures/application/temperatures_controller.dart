import 'dart:async';
import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/temperature_sensor.dart';

part 'temperatures_controller.g.dart';

/// Live temperature readings. Phase 1 has one probe — outside/ambient
/// air — drifting within a realistic range on a timer to simulate a real
/// sensor feed. Adding Freezer/Engine Room/Cabin later is just another
/// seed entry here, no screen changes needed.
@riverpod
class TemperaturesController extends _$TemperaturesController {
  Timer? _driftTimer;
  final _random = Random();

  @override
  List<TemperatureSensor> build() {
    _driftTimer = Timer.periodic(const Duration(seconds: 3), (_) => _drift());
    ref.onDispose(() => _driftTimer?.cancel());

    return const [
      TemperatureSensor(
        id: 'ambient',
        name: 'Outside Air',
        celsius: 27.5,
        minScale: 0,
        maxScale: 45,
      ),
    ];
  }

  void _drift() {
    state = [
      for (final sensor in state)
        sensor.copyWith(
          celsius: (sensor.celsius + (_random.nextDouble() - 0.5) * 0.6)
              .clamp(sensor.minScale + 2, sensor.maxScale - 2),
        ),
    ];
  }
}
