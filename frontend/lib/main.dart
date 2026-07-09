import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
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
    );
  }
}
