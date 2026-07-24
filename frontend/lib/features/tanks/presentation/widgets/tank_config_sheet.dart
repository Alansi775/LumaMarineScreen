import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/keyboard/app_text_field.dart';
import '../../../../core/widgets/keyboard/keyboard_target.dart';
import '../../application/tanks_controller.dart';
import '../../domain/tank_model.dart';

/// Tracks whichever text controller (name or capacity) the currently
/// open sheet last bound to the keyboard — lets `whenComplete` clear it
/// without touching a possibly-disposed widget's `ref`.
final _lastTankFieldControllerProvider = StateProvider<TextEditingController?>((ref) => null);

Future<void> showTankConfigSheet(BuildContext context, Tank tank) {
  final container = ProviderScope.containerOf(context, listen: false);
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => TankConfigSheet(tank: tank),
  ).whenComplete(() {
    final controller = container.read(_lastTankFieldControllerProvider);
    if (controller != null) clearKeyboardTargetIfMatches(container, controller);
  });
}

/// Capacity + sensor type editor — mirrors the ESP32 tank config popup
/// (usrTankLevelPage_showConfigPopup).
class TankConfigSheet extends ConsumerStatefulWidget {
  const TankConfigSheet({super.key, required this.tank});

  final Tank tank;

  @override
  ConsumerState<TankConfigSheet> createState() => _TankConfigSheetState();
}

class _TankConfigSheetState extends ConsumerState<TankConfigSheet> {
  late final TextEditingController _nameController =
      TextEditingController(text: widget.tank.name);
  late final TextEditingController _capacityController =
      TextEditingController(text: widget.tank.capacityLiters.round().toString());
  late TankSensorType _sensorType = widget.tank.sensorType;

  @override
  void dispose() {
    _nameController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();
    final capacity = double.tryParse(_capacityController.text) ?? widget.tank.capacityLiters;
    ref.read(tanksControllerProvider.notifier).configure(
          widget.tank.id,
          name: name.isEmpty ? widget.tank.name : name,
          capacityLiters: capacity,
          sensorType: _sensorType,
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final active = ref.watch(keyboardTargetProvider);
    final keyboardShowing = active == _nameController || active == _capacityController;
    if (keyboardShowing) {
      // Recorded reactively (not via a tap handler) so `whenComplete` in
      // showTankConfigSheet can find the right controller to clear later.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) ref.read(_lastTankFieldControllerProvider.notifier).state = active;
      });
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + (keyboardShowing ? kAppKeyboardHeight : 0),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(28, 24, 28, 32),
        decoration: const BoxDecoration(
          color: AppColors.surfaceRaised,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusLarge)),
          border: Border(
            top: BorderSide(color: AppColors.hairline),
            left: BorderSide(color: AppColors.hairline),
            right: BorderSide(color: AppColors.hairline),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppColors.hairline, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 22),
            Text('CONFIGURE TANK', style: AppTextStyles.sectionLabel),
            const SizedBox(height: 18),
            Text('NAME', style: AppTextStyles.caption),
            const SizedBox(height: 8),
            AppTextField(controller: _nameController, hintText: 'Tank name'),
            const SizedBox(height: 20),
            Text('CAPACITY (LITERS)', style: AppTextStyles.caption),
            const SizedBox(height: 8),
            AppTextField(controller: _capacityController, hintText: '200', numeric: true),
            const SizedBox(height: 20),
            Text('SENSOR TYPE', style: AppTextStyles.caption),
            const SizedBox(height: 10),
            Row(
              children: [
                for (final type in TankSensorType.values) ...[
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _sensorType = type),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _sensorType == type ? AppColors.accent.withValues(alpha: 0.16) : AppColors.surface,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                          border: Border.all(
                            color: _sensorType == type ? AppColors.accent : AppColors.hairline,
                          ),
                        ),
                        child: Text(
                          type.label,
                          style: AppTextStyles.bodyStrong.copyWith(
                            color: _sensorType == type ? AppColors.accent : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (type != TankSensorType.values.last) const SizedBox(width: 12),
                ],
              ],
            ),
            const SizedBox(height: 26),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.background,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusSmall)),
                  elevation: 0,
                ),
                child: Text(
                  'SAVE',
                  style: AppTextStyles.bodyStrong.copyWith(color: AppColors.background, letterSpacing: 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
