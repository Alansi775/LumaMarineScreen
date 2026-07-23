import 'shunt_reading.dart';

/// TEST/REAL mirrors usrShuntPage.c's `TEST_MODE` exactly — REAL
/// (default) waits quietly for real sensor data, TEST animates
/// plausible values so the page can be demoed without hardware.
class ShuntState {
  const ShuntState({
    required this.mainShunt,
    required this.batteries,
    required this.quadroShunts,
    this.testMode = false,
  });

  final ShuntReading mainShunt;
  final List<BatteryReading> batteries;
  final List<ShuntReading> quadroShunts;
  final bool testMode;

  ShuntState copyWith({
    ShuntReading? mainShunt,
    List<BatteryReading>? batteries,
    List<ShuntReading>? quadroShunts,
    bool? testMode,
  }) {
    return ShuntState(
      mainShunt: mainShunt ?? this.mainShunt,
      batteries: batteries ?? this.batteries,
      quadroShunts: quadroShunts ?? this.quadroShunts,
      testMode: testMode ?? this.testMode,
    );
  }
}
