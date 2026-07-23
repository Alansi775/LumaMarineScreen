import '../features/big_relay/presentation/big_relay_screen.dart';
import '../features/doors/presentation/doors_screen.dart';
import '../features/lights/presentation/lights_screen.dart';
import '../features/overview/presentation/overview_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/sockets/presentation/sockets_screen.dart';
import '../features/tanks/presentation/tanks_screen.dart';
import 'package:flutter/widgets.dart';

/// Ordered list of top-level screens swiped between in [RootShell].
/// Matches the ESP32 reference project's real page set exactly — no
/// Batteries, Temperatures, or Toilet screens, none of those exist on
/// real hardware (confirmed against `usrGraphicalInterface.c`'s
/// `main_buttons`/`controls_buttons` and the manager's direct comparison
/// against the physical ESP32 screen, 2026-07-23).
enum AppScreen {
  overview,
  tanks,
  lights,
  sockets,
  bigRelay,
  doors,
  settings,
}

extension AppScreenWidget on AppScreen {
  Widget build() {
    switch (this) {
      case AppScreen.overview:
        return const OverviewScreen();
      case AppScreen.tanks:
        return const TanksScreen();
      case AppScreen.lights:
        return const LightsScreen();
      case AppScreen.sockets:
        return const SocketsScreen();
      case AppScreen.bigRelay:
        return const BigRelayScreen();
      case AppScreen.doors:
        return const DoorsScreen();
      case AppScreen.settings:
        return const SettingsScreen();
    }
  }
}
