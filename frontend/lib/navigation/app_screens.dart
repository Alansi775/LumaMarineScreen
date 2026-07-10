import '../features/batteries/presentation/batteries_screen.dart';
import '../features/big_relay/presentation/big_relay_screen.dart';
import '../features/doors/presentation/doors_screen.dart';
import '../features/lights/presentation/lights_screen.dart';
import '../features/overview/presentation/overview_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/sockets/presentation/sockets_screen.dart';
import '../features/tanks/presentation/tanks_screen.dart';
import '../features/temperatures/presentation/temperatures_screen.dart';
import '../features/toilet/presentation/toilet_screen.dart';
import 'package:flutter/widgets.dart';

/// Ordered list of top-level screens swiped between in [RootShell].
enum AppScreen {
  overview,
  batteries,
  tanks,
  temperatures,
  lights,
  sockets,
  bigRelay,
  toilet,
  doors,
  settings,
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
      case AppScreen.sockets:
        return const SocketsScreen();
      case AppScreen.bigRelay:
        return const BigRelayScreen();
      case AppScreen.toilet:
        return const ToiletScreen();
      case AppScreen.doors:
        return const DoorsScreen();
      case AppScreen.settings:
        return const SettingsScreen();
    }
  }
}
