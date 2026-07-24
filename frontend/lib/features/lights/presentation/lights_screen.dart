// frontend/lib/features/lights/presentation/lights_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/control_panel/segmented_intensity_bar.dart';
import '../../../core/widgets/node_status_pill.dart';
import '../application/lights_controller.dart';
import 'widgets/add_light_sheet.dart';

class LightsScreen extends ConsumerStatefulWidget {
  const LightsScreen({super.key});

  @override
  ConsumerState<LightsScreen> createState() => _LightsScreenState();
}

class _LightsScreenState extends ConsumerState<LightsScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final lights = ref.watch(lightsControllerProvider);
    final notifier = ref.read(lightsControllerProvider.notifier);

    if (lights.isEmpty) {
      return const Scaffold(
        backgroundColor: Color(0xFF07080A),
        body: Center(
          child: Text("NO LIGHTS CONFIGURED", style: TextStyle(color: Colors.white24, letterSpacing: 4)),
        ),
      );
    }

    final index = _selectedIndex.clamp(0, lights.length - 1);
    final selected = lights[index];
    final hasSlider = index < 6;

    return Scaffold(
      backgroundColor: const Color(0xFF07080A), // خلفية داكنة جداً وخالية من التشتت
      body: Stack(
        children: [
          // ================= الإضاءة الخلفية الناعمة المتمركزة =================
          Positioned.fill(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 700),
              opacity: selected.isOn ? 1.0 : 0.0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.8,
                    colors: [
                      const Color(0xFF00E5FF).withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // ================= الهيدر المتمركز (التغيير الجذري) =================
                Padding(
                  padding: const EdgeInsets.only(top: 32, left: 32, right: 32, bottom: 40),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // حالة الاتصال تطفو على اليمين
                      const Align(
                        alignment: Alignment.centerRight,
                        child: NodeStatusPill(),
                      ),
                      // العنوان الرئيسي في المنتصف بكل فخامة
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.blur_on, color: Color(0xFF00E5FF), size: 28),
                          const SizedBox(height: 12),
                          Text(
                            'LIGHTING',
                            style: AppTextStyles.title.copyWith(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 16,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'YACHT CONTROL',
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white38,
                              letterSpacing: 8,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ================= المحتوى الرئيسي =================
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimensions.navArrowGutter),
                    child: Row(
                    children: [
                      // 1. القائمة الجانبية (نظيفة، بدون صناديق)
                      SizedBox(
                        width: 260,
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.symmetric(horizontal: 32),
                                itemCount: lights.length,
                                itemBuilder: (context, i) => _MinimalZoneItem(
                                  label: lights[i].name,
                                  isSelected: i == index,
                                  isOn: lights[i].isOn,
                                  onTap: () => setState(() => _selectedIndex = i),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                children: [
                                  _MinimalActionButton(
                                    label: '+ ADD ZONE',
                                    onTap: () => showAddLightSheet(context),
                                  ),
                                  const SizedBox(height: 16),
                                  _MinimalActionButton(
                                    label: 'CLOSE ALL',
                                    onTap: notifier.closeAll,
                                    isMuted: true,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 2. زر الطاقة المركزي
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                selected.name.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 10,
                                ),
                              ),
                              const SizedBox(height: 60),
                              
                              _CentralPowerButton(
                                isOn: selected.isOn,
                                onTap: () => notifier.toggle(selected.id),
                              ),
                              
                              const SizedBox(height: 50),
                              Text(
                                selected.isOn ? 'ACTIVE' : 'STANDBY',
                                style: TextStyle(
                                  color: selected.isOn ? const Color(0xFF00E5FF) : Colors.white38,
                                  letterSpacing: 6,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 3. شريط السطوع (على اليمين)
                      SizedBox(
                        width: 260,
                        child: hasSlider
                            ? Padding(
                                padding: const EdgeInsets.only(right: 48, bottom: 48, top: 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${(selected.brightness / 10).round()}%',
                                      style: TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.w200,
                                        color: selected.isOn ? Colors.white : Colors.white24,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'INTENSITY',
                                      style: TextStyle(
                                        color: Colors.white38,
                                        letterSpacing: 4,
                                        fontSize: 10,
                                      ),
                                    ),
                                    const SizedBox(height: 40),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: SizedBox(
                                          width: 80, // شريط نحيف وعصري
                                          child: SegmentedIntensityBar(
                                            value: selected.brightness,
                                            enabled: selected.isOn,
                                            onChanged: (v) => notifier.setBrightness(selected.id, v),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================= المكونات البصرية الجديدة =================

class _MinimalZoneItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isOn;
  final VoidCallback onTap;

  const _MinimalZoneItem({
    required this.label,
    required this.isSelected,
    required this.isOn,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            // أيقونة توضح حالة التفعيل: مصباح مضيء أو مطفأ
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Icon(
                isOn ? Icons.lightbulb_rounded : Icons.lightbulb_outline_rounded,
                key: ValueKey(isOn),
                size: 20,
                color: isOn ? const Color(0xFF00E5FF) : (isSelected ? Colors.white54 : Colors.white24),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white38,
                  fontSize: isSelected ? 18 : 17,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  letterSpacing: 2,
                ),
                child: Text(label),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isOn
                    ? const Color(0xFF00E5FF)
                    : (isSelected ? Colors.white54 : Colors.transparent),
                boxShadow: isOn
                    ? [const BoxShadow(color: Color(0xFF00E5FF), blurRadius: 6)]
                    : [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CentralPowerButton extends StatelessWidget {
  final bool isOn;
  final VoidCallback onTap;

  const _CentralPowerButton({required this.isOn, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF0D0E12),
          border: Border.all(
            color: isOn ? const Color(0xFF00E5FF).withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.05),
            width: 1,
          ),
          boxShadow: isOn
              ? [
                  BoxShadow(
                    color: const Color(0xFF00E5FF).withValues(alpha: 0.2),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                  const BoxShadow(
                    color: Color(0xFF0D0E12),
                    blurRadius: 20,
                    spreadRadius: -5,
                    offset: Offset(0, 10), // ظل داخلي للعمق
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.6),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
        ),
        child: Center(
          child: Icon(
            Icons.power_settings_new_rounded,
            size: 56,
            color: isOn ? const Color(0xFF00E5FF) : Colors.white24,
          ),
        ),
      ),
    );
  }
}

class _MinimalActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isMuted;

  const _MinimalActionButton({
    required this.label,
    required this.onTap,
    this.isMuted = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isMuted ? Colors.transparent : Colors.white.withValues(alpha: 0.1),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isMuted ? Colors.white38 : Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}