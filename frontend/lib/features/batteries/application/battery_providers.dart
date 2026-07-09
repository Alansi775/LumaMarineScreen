import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/battery_repository.dart';
import '../../../data/repositories/mock_battery_repository.dart';
import '../domain/battery_model.dart';
import '../domain/circuit_model.dart';

part 'battery_providers.g.dart';

@riverpod
BatteryRepository batteryRepository(BatteryRepositoryRef ref) {
  return MockBatteryRepository();
}

@riverpod
Stream<BatteryModel> mainBattery(MainBatteryRef ref) {
  return ref.watch(batteryRepositoryProvider).watchMainBattery();
}

@riverpod
Stream<List<CircuitModel>> batteryCircuits(BatteryCircuitsRef ref) {
  return ref.watch(batteryRepositoryProvider).watchCircuits();
}
