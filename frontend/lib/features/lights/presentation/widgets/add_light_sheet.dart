// frontend/lib/features/lights/presentation/widgets/add_light_sheet.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/keyboard/app_text_field.dart';
import '../../../../core/widgets/keyboard/keyboard_target.dart';
import '../../application/lights_controller.dart';
import '../../domain/light_model.dart';

Future<void> showAddLightSheet(BuildContext context) {
  // Captured now, while the context is definitely still valid — used to
  // clear the keyboard target after the sheet closes, however it closes.
  // Doing this via `ref` inside the sheet's own dispose() crashes
  // ("Cannot use ref after the widget was disposed") because Riverpod
  // tears down the element's ref binding before State.dispose() runs
  // during a route-pop unmount cascade.
  final container = ProviderScope.containerOf(context, listen: false);
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    barrierColor: Colors.black.withValues(alpha: 0.6), // تعتيم الخلفية بنعومة
    builder: (_) => const AddLightSheet(),
  ).whenComplete(() {
    final controller = container.read(_lastAddLightControllerProvider);
    if (controller != null) clearKeyboardTargetIfMatches(container, controller);
  });
}

/// Tracks the currently-open sheet's text controller so
/// [showAddLightSheet]'s `whenComplete` can find it without touching a
/// possibly-disposed widget's `ref`.
final _lastAddLightControllerProvider = StateProvider<TextEditingController?>((ref) => null);

class AddLightSheet extends ConsumerStatefulWidget {
  const AddLightSheet({super.key});

  @override
  ConsumerState<AddLightSheet> createState() => _AddLightSheetState();
}

class _AddLightSheetState extends ConsumerState<AddLightSheet> {
  final _controller = TextEditingController();
  IconData _selectedIcon = lightIconChoices.first;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(_lastAddLightControllerProvider.notifier).state = _controller;
    });
  }

  @override
  void dispose() {
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
    final keyboardShowing = ref.watch(keyboardTargetProvider) == _controller;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom +
            24 +
            (keyboardShowing ? kAppKeyboardHeight : 0),
        left: 24,
        right: 24,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16), // تأثير زجاجي قوي
          child: Container(
            padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
            decoration: BoxDecoration(
              color: const Color(0xFF15161A).withValues(alpha: 0.7), // لون داكن شفاف
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            // Scrollable, not just Column(mainAxisSize.min) — the keyboard's
            // extra bottom padding can push total content past the screen's
            // real height on this device, which without a scroll view
            // overflows (the classic yellow/black hazard-stripe warning)
            // instead of just scrolling into view.
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'NEW LIGHT ZONE',
                  style: AppTextStyles.sectionLabel.copyWith(
                    color: Colors.white,
                    letterSpacing: 4,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                // مربع النص يمكن أن يبقى من الـ Core ولكن أحطناه بـ Theme عصري
                Theme(
                  data: Theme.of(context).copyWith(
                    inputDecorationTheme: InputDecorationTheme(
                      filled: true,
                      fillColor: Colors.black.withValues(alpha: 0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      hintStyle: const TextStyle(color: Colors.white38),
                    ),
                  ),
                  child: AppTextField(
                    controller: _controller,
                    hintText: 'e.g. Master Bedroom',
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'SELECT ICON',
                  style: AppTextStyles.sectionLabel.copyWith(
                    color: Colors.white54,
                    letterSpacing: 2,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    for (final icon in lightIconChoices)
                      _ModernIconChoice(
                        icon: icon,
                        selected: icon == _selectedIcon,
                        onTap: () => setState(() => _selectedIcon = icon),
                      ),
                  ],
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF45F5E4), // لون Accent عصري (Cyan)
                      foregroundColor: const Color(0xFF0B0C10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 10,
                      shadowColor: const Color(0xFF45F5E4).withValues(alpha: 0.3),
                    ),
                    child: Text(
                      'ADD ZONE',
                      style: AppTextStyles.bodyStrong.copyWith(
                        color: const Color(0xFF0B0C10),
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ModernIconChoice extends StatelessWidget {
  const _ModernIconChoice({
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
        duration: const Duration(milliseconds: 200),
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? const Color(0xFF45F5E4).withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.05),
          border: Border.all(
            color: selected ? const Color(0xFF45F5E4) : Colors.transparent,
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFF45F5E4).withValues(alpha: 0.2),
                    blurRadius: 12,
                    spreadRadius: 2,
                  )
                ]
              : null,
        ),
        child: Icon(
          icon,
          size: 24,
          color: selected ? const Color(0xFF45F5E4) : Colors.white54,
        ),
      ),
    );
  }
}