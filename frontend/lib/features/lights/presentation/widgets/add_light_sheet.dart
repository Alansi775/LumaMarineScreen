import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/keyboard/app_text_field.dart';
import '../../../../core/widgets/keyboard/keyboard_target.dart';
import '../../application/lights_controller.dart';
import '../../domain/light_model.dart';

Future<void> showAddLightSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const AddLightSheet(),
  );
}

class AddLightSheet extends ConsumerStatefulWidget {
  const AddLightSheet({super.key});

  @override
  ConsumerState<AddLightSheet> createState() => _AddLightSheetState();
}

class _AddLightSheetState extends ConsumerState<AddLightSheet> {
  final _controller = TextEditingController();
  IconData _selectedIcon = lightIconChoices.first;

  @override
  void dispose() {
    if (ref.read(keyboardTargetProvider) == _controller) {
      ref.read(keyboardTargetProvider.notifier).state = null;
    }
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    ref.read(lightsControllerProvider.notifier).addLight(
          name: name,
          icon: _selectedIcon,
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(28, 24, 28, 32),
        decoration: const BoxDecoration(
          color: AppColors.surfaceRaised,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusLarge),
          ),
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
                decoration: BoxDecoration(
                  color: AppColors.hairline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 22),
            Text('ADD LIGHT', style: AppTextStyles.sectionLabel),
            const SizedBox(height: 18),
            AppTextField(controller: _controller, hintText: 'e.g. Salon Lamp'),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final icon in lightIconChoices)
                  _IconChoice(
                    icon: icon,
                    selected: icon == _selectedIcon,
                    onTap: () => setState(() => _selectedIcon = icon),
                  ),
              ],
            ),
            const SizedBox(height: 26),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.background,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                  ),
                  elevation: 0,
                ),
                child: Text('ADD', style: AppTextStyles.bodyStrong.copyWith(
                  color: AppColors.background,
                  letterSpacing: 1,
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconChoice extends StatelessWidget {
  const _IconChoice({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? AppColors.accent.withValues(alpha: 0.16) : AppColors.surface,
          border: Border.all(
            color: selected ? AppColors.accent : AppColors.hairline,
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: selected ? AppColors.accent : AppColors.textSecondary,
        ),
      ),
    );
  }
}
