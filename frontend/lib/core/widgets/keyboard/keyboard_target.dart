import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The `TextEditingController` currently bound to the on-screen keyboard.
/// Null means the keyboard is hidden. flutter-pi has no system IME on
/// this device, so every text field on screen routes through this one
/// custom keyboard instead of waiting for a soft keyboard that will
/// never appear.
final keyboardTargetProvider = StateProvider<TextEditingController?>((ref) => null);
