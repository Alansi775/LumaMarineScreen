import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/settings/application/settings_controller.dart';
import '../features/settings/presentation/pin_entry_screen.dart';
import '../features/settings/presentation/pin_setup_screen.dart';
import 'root_shell.dart';

/// Decides what the app shows after the splash screen: first-boot PIN
/// setup, PIN entry for a returning session, or the unlocked app.
class AppGate extends ConsumerWidget {
  const AppGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinState = ref.watch(settingsControllerProvider);

    if (pinState.isVerified) return const RootShell();
    if (!pinState.isSet) return const PinSetupScreen();
    return const PinEntryScreen();
  }
}
