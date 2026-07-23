import 'tank_model.dart';

/// TEST/REAL mirrors the ESP32 Tank Level page's `TEST_MODE` toggle
/// exactly: REAL (default) waits quietly for real sensor data — level
/// stays at 0 — TEST animates plausible values so the page can be
/// demoed without hardware attached.
class TanksState {
  const TanksState({required this.tanks, this.testMode = false});

  final List<Tank> tanks;
  final bool testMode;

  TanksState copyWith({List<Tank>? tanks, bool? testMode}) {
    return TanksState(
      tanks: tanks ?? this.tanks,
      testMode: testMode ?? this.testMode,
    );
  }
}
