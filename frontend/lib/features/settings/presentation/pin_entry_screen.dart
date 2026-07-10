import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../application/settings_controller.dart';
import 'widgets/pin_dots.dart';
import 'widgets/pin_keypad.dart';

/// Returning-boot flow: enter the existing 6-digit PIN to unlock. Mirrors
/// PAGE_PASSWORD_ENTRY from the ESP32 reference project.
class PinEntryScreen extends ConsumerStatefulWidget {
  const PinEntryScreen({super.key});

  @override
  ConsumerState<PinEntryScreen> createState() => _PinEntryScreenState();
}

class _PinEntryScreenState extends ConsumerState<PinEntryScreen> {
  String _buffer = '';
  bool _error = false;

  void _onDigit(String digit) {
    if (_buffer.length >= 6) return;
    setState(() {
      _error = false;
      _buffer += digit;
    });
    if (_buffer.length == 6) {
      Future.delayed(const Duration(milliseconds: 150), _onComplete);
    }
  }

  void _onBackspace() {
    if (_buffer.isEmpty) return;
    setState(() => _buffer = _buffer.substring(0, _buffer.length - 1));
  }

  void _onComplete() {
    final ok = ref.read(settingsControllerProvider.notifier).verifyPin(_buffer);
    if (!ok) {
      setState(() {
        _error = true;
        _buffer = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline_rounded, size: 40, color: AppColors.accent),
            const SizedBox(height: 20),
            Text('ENTER PIN', style: AppTextStyles.sectionLabel.copyWith(letterSpacing: 3)),
            const SizedBox(height: 24),
            PinDots(length: _buffer.length),
            const SizedBox(height: 16),
            SizedBox(
              height: 20,
              child: _error
                  ? Text('Incorrect PIN', style: AppTextStyles.caption.copyWith(color: AppColors.warning))
                  : null,
            ),
            const SizedBox(height: 24),
            PinKeypad(onDigit: _onDigit, onBackspace: _onBackspace),
          ],
        ),
      ),
    );
  }
}
