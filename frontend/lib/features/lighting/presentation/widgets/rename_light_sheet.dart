// lib/features/lighting/presentation/widgets/rename_light_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/keyboard/app_text_field.dart';
import '../../../../core/widgets/keyboard/keyboard_target.dart';
import '../../application/lighting_controller.dart';

final _lastRenameControllerProvider = StateProvider<TextEditingController?>((ref) => null);

Future<void> showRenameLightSheet(BuildContext context, int ledNumber, String currentName) {
  final container = ProviderScope.containerOf(context, listen: false);
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _RenameLightSheet(ledNumber: ledNumber, currentName: currentName),
  ).whenComplete(() {
    final controller = container.read(_lastRenameControllerProvider);
    if (controller != null) clearKeyboardTargetIfMatches(container, controller);
  });
}

class _RenameLightSheet extends ConsumerStatefulWidget {
  const _RenameLightSheet({required this.ledNumber, required this.currentName});

  final int ledNumber;
  final String currentName;

  @override
  ConsumerState<_RenameLightSheet> createState() => _RenameLightSheetState();
}

class _RenameLightSheetState extends ConsumerState<_RenameLightSheet> {
  late final _controller = TextEditingController(text: widget.currentName);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(_lastRenameControllerProvider.notifier).state = _controller;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    ref.read(lightingControllerProvider.notifier).rename(widget.ledNumber, _controller.text);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardShowing = ref.watch(keyboardTargetProvider) == _controller;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + (keyboardShowing ? kAppKeyboardHeight : 0),
        left: 24,
        right: 24,
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 32),
          decoration: BoxDecoration(
            color: AppColors.surfaceRaised,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusLarge)),
            border: Border.all(color: AppColors.hairline),
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
              Text('IŞIK ADINI DEĞİŞTİR', style: AppTextStyles.sectionLabel),
              const SizedBox(height: 8),
              Text('LED ${widget.ledNumber}', style: AppTextStyles.caption),
              const SizedBox(height: 16),
              AppTextField(controller: _controller, hintText: 'ör. FLOOR 1'),
              const SizedBox(height: 22),
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
                  child: const Text(
                    'KAYDET',
                    style: TextStyle(color: AppColors.background, fontWeight: FontWeight.w700, letterSpacing: 1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
