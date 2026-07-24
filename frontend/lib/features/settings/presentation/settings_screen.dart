import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/control_panel/control_page_header.dart';
import '../../../core/widgets/luma_card.dart';
import '../application/settings_controller.dart';
import 'widgets/pin_dots.dart';
import 'widgets/pin_keypad.dart';

enum _ChangePinStep { idle, enterOld, enterNew, confirmNew }

/// PAGE_SETTINGS from the ESP32 reference project — currently just PIN
/// management. More settings plug in here later.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  _ChangePinStep _step = _ChangePinStep.idle;
  String _oldPin = '';
  String _newPin = '';
  String _buffer = '';
  String? _error;
  String? _success;

  void _startChange() {
    setState(() {
      _step = _ChangePinStep.enterOld;
      _oldPin = '';
      _newPin = '';
      _buffer = '';
      _error = null;
      _success = null;
    });
  }

  void _onDigit(String digit) {
    if (_buffer.length >= 6) return;
    setState(() {
      _error = null;
      _buffer += digit;
    });
    if (_buffer.length == 6) {
      Future.delayed(const Duration(milliseconds: 150), _advance);
    }
  }

  void _onBackspace() {
    if (_buffer.isEmpty) return;
    setState(() => _buffer = _buffer.substring(0, _buffer.length - 1));
  }

  void _advance() {
    switch (_step) {
      case _ChangePinStep.enterOld:
        setState(() {
          _oldPin = _buffer;
          _buffer = '';
          _step = _ChangePinStep.enterNew;
        });
      case _ChangePinStep.enterNew:
        setState(() {
          _newPin = _buffer;
          _buffer = '';
          _step = _ChangePinStep.confirmNew;
        });
      case _ChangePinStep.confirmNew:
        if (_buffer != _newPin) {
          setState(() {
            _error = 'PINs did not match';
            _buffer = '';
            _step = _ChangePinStep.enterNew;
          });
          return;
        }
        final ok = ref
            .read(settingsControllerProvider.notifier)
            .changePin(oldPin: _oldPin, newPin: _newPin);
        setState(() {
          _step = _ChangePinStep.idle;
          _buffer = '';
          _error = ok ? null : 'Current PIN was incorrect';
          _success = ok ? 'PIN updated' : null;
        });
      case _ChangePinStep.idle:
        break;
    }
  }

  String get _label {
    return switch (_step) {
      _ChangePinStep.enterOld => 'ENTER CURRENT PIN',
      _ChangePinStep.enterNew => 'ENTER NEW PIN',
      _ChangePinStep.confirmNew => 'CONFIRM NEW PIN',
      _ChangePinStep.idle => '',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF07080A),
      child: SafeArea(
        child: Column(
          children: [
            const ControlPageHeader(
              icon: Icons.settings_outlined,
              title: 'SETTINGS',
              subtitle: 'ACCESS & SECURITY',
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.pagePadding,
                  0,
                  AppDimensions.pagePadding,
                  AppDimensions.pagePadding + 40,
                ),
                child: Center(
                  child: _step == _ChangePinStep.idle
                      ? _IdleCard(
                          onChangePin: _startChange,
                          message: _error ?? _success,
                          isError: _error != null,
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_label, style: AppTextStyles.sectionLabel.copyWith(letterSpacing: 3)),
                            const SizedBox(height: 24),
                            PinDots(length: _buffer.length),
                            const SizedBox(height: 24),
                            PinKeypad(onDigit: _onDigit, onBackspace: _onBackspace),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IdleCard extends StatelessWidget {
  const _IdleCard({required this.onChangePin, this.message, this.isError = false});

  final VoidCallback onChangePin;
  final String? message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return LumaCard(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock_outline_rounded, size: 32, color: AppColors.accent),
          const SizedBox(height: 16),
          Text('Security PIN', style: AppTextStyles.bodyStrong),
          const SizedBox(height: 8),
          Text('Change the 6-digit PIN used to unlock this panel.', style: AppTextStyles.body),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onChangePin,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.background,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              ),
              elevation: 0,
            ),
            child: Text(
              'CHANGE PIN',
              style: AppTextStyles.bodyStrong.copyWith(color: AppColors.background, letterSpacing: 1),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: AppTextStyles.caption.copyWith(
                color: isError ? AppColors.warning : AppColors.success,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
