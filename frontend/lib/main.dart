import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/widgets/keyboard/keyboard_host.dart';
import 'features/splash/presentation/splash_screen.dart';

void main() {
  runApp(const ProviderScope(child: LumaMarineApp()));
}

class LumaMarineApp extends StatelessWidget {
  const LumaMarineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luma Marine',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const SplashScreen(),
      // This device (flutter-pi) has no system IME — one on-screen
      // keyboard lives here, above the navigator, so it's available
      // no matter which screen is showing an AppTextField.
      builder: (context, child) => KeyboardHost(child: child!),
    );
  }
}
