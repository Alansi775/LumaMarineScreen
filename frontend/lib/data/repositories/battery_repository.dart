import '../../features/batteries/domain/battery_model.dart';
import '../../features/batteries/domain/circuit_model.dart';

/// Source of battery readings. Swap the implementation (e.g. for a Firebase
/// or local-bus backed one) without touching any UI code — only a provider
/// override is needed.
abstract class BatteryRepository {
  Stream<BatteryModel> watchMainBattery();
  Stream<BatteryModel> watchBackupBattery();
  Stream<List<CircuitModel>> watchCircuits();
}
