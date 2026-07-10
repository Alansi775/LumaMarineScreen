import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../application/settings_controller.dart';
import 'widgets/pin_dots.dart';
import 'widgets/pin_keypad.dart';

/// First-boot flow: choose a 6-digit PIN, then confirm it. Mirrors
/// PAGE_PASSWORD_SETUP from the ESP32 reference project.
class PinSetupScreen extends ConsumerStatefulWidget {
  const PinSetupScreen({super.key});

  @override
  ConsumerState<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends ConsumerState<PinSetupScreen> {
  String _firstEntry = '';
  String _buffer = '';
  bool _confirming = false;
  String? _error;

  void _onDigit(String digit) {
    if (_buffer.length >= 6) return;
    setState(() {
      _error = null;
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
    if (!_confirming) {
      setState(() {
        _firstEntry = _buffer;
        _buffer = '';
        _confirming = true;
      });
      return;
    }

    if (_buffer == _firstEntry) {
      ref.read(settingsControllerProvider.notifier).setPin(_buffer);
      return;
    }

    setState(() {
      _error = 'PINs did not match — try again';
      _firstEntry = '';
      _buffer = '';
      _confirming = false;
    });
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
            Text(
              _confirming ? 'CONFIRM PIN' : 'CREATE A 6-DIGIT PIN',
              style: AppTextStyles.sectionLabel.copyWith(letterSpacing: 3),
            ),
            const SizedBox(height: 24),
            PinDots(length: _buffer.length),
            const SizedBox(height: 16),
            SizedBox(
              height: 20,
              child: _error != null
                  ? Text(_error!, style: AppTextStyles.caption.copyWith(color: AppColors.warning))
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
