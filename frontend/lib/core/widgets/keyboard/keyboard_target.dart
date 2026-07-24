import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The `TextEditingController` currently bound to the on-screen keyboard.
/// Null means the keyboard is hidden. flutter-pi has no system IME on
/// this device, so every text field on screen routes through this one
/// custom keyboard instead of waiting for a soft keyboard that will
/// never appear.
final keyboardTargetProvider = StateProvider<TextEditingController?>((ref) => null);

/// Approximate rendered height of [AppKeyboard] — used by bottom sheets
/// to lift their content clear of the keyboard overlay, since it isn't a
/// system inset `MediaQuery` knows about.
const double kAppKeyboardHeight = 300;

/// Clears [keyboardTargetProvider] if it currently points at
/// [controller] — safe to call from anywhere, including after a widget
/// has been disposed, because it goes through the captured
/// [ProviderContainer] directly rather than a widget's `ref` (reading
/// `ref` inside `State.dispose()` throws "used after dispose" once the
/// element has already been unmounted).
void clearKeyboardTargetIfMatches(ProviderContainer container, TextEditingController controller) {
  if (container.read(keyboardTargetProvider) == controller) {
    container.read(keyboardTargetProvider.notifier).state = null;
  }
}
