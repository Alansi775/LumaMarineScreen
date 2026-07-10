import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/pin_state.dart';

part 'settings_controller.g.dart';

/// 6-digit PIN gate for the whole app. Mirrors
/// PAGE_PASSWORD_SETUP/ENTRY/CHANGE from the ESP32 reference project.
@riverpod
class SettingsController extends _$SettingsController {
  @override
  PinState build() => const PinState();

  void setPin(String pin) {
    state = state.copyWith(pin: pin, isVerified: true);
  }

  bool verifyPin(String pin) {
    if (state.pin == pin) {
      state = state.copyWith(isVerified: true);
      return true;
    }
    return false;
  }

  bool changePin({required String oldPin, required String newPin}) {
    if (state.pin != oldPin) return false;
    state = state.copyWith(pin: newPin);
    return true;
  }

  void lock() => state = state.copyWith(isVerified: false);
}
