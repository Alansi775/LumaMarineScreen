import '../features/batteries/presentation/batteries_screen.dart';
import '../features/doors/presentation/doors_screen.dart';
import '../features/lights/presentation/lights_screen.dart';
import '../features/overview/presentation/overview_screen.dart';
import '../features/tanks/presentation/tanks_screen.dart';
import '../features/temperatures/presentation/temperatures_screen.dart';
import 'package:flutter/widgets.dart';

/// Ordered list of top-level screens swiped between in [RootShell].
/// TV control is planned but intentionally not built yet.
enum AppScreen {
  overview,
  batteries,
  tanks,
  temperatures,
  lights,
  doors,
}

extension AppScreenWidget on AppScreen {
  Widget build() {
    switch (this) {
      case AppScreen.overview:
        return const OverviewScreen();
      case AppScreen.batteries:
        return const BatteriesScreen();
      case AppScreen.tanks:
        return const TanksScreen();
      case AppScreen.temperatures:
        return const TemperaturesScreen();
      case AppScreen.lights:
        return const LightsScreen();
      case AppScreen.doors:
        return const DoorsScreen();
    }
  }
}
