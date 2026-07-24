// frontend/lib/features/tanks/presentation/tanks_screen.dart
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../application/tanks_controller.dart';
import '../domain/tank_model.dart';
import '../domain/tanks_state.dart';
import 'widgets/add_tank_tile.dart';
import 'widgets/tank_grid_card.dart';

/// One slot in a page's row of 3 — either a real tank or the trailing
/// "add tank" tile.
class _TankSlot {
  const _TankSlot.tank(Tank t) : tank = t, isAdd = false;
  const _TankSlot.add() : tank = null, isAdd = true;

  final Tank? tank;
  final bool isAdd;
}

/// One screen's worth of content: a section label plus up to 3 tanks —
/// always shown as a whole, centered, with nothing else on screen.
class _TankPage {
  const _TankPage({required this.sectionTitle, required this.slots, required this.onAdd});

  final String sectionTitle;
  final List<_TankSlot> slots;
  final VoidCallback onAdd;
}

class TanksScreen extends ConsumerStatefulWidget {
  const TanksScreen({super.key});

  @override
  ConsumerState<TanksScreen> createState() => _TanksScreenState();
}

class _TanksScreenState extends ConsumerState<TanksScreen> {
  int _currentPage = 0;
  int _flipDirection = 1;

  List<_TankPage> _buildPages(TanksState state, TanksController notifier) {
    final ohms0Tanks = state.tanks.where((t) => t.sensorType == TankSensorType.ohms0to190).toList();
    final ohms30Tanks = state.tanks.where((t) => t.sensorType == TankSensorType.ohms30to240).toList();

    final pages = <_TankPage>[];
    void addSection(String title, List<Tank> tanks, TankSensorType type) {
      final slots = [
        for (final t in tanks) _TankSlot.tank(t),
        const _TankSlot.add(),
      ];
      for (var i = 0; i < slots.length; i += 3) {
        pages.add(
          _TankPage(
            sectionTitle: title,
            slots: slots.sublist(i, math.min(i + 3, slots.length)),
            onAdd: () => notifier.addTank(type),
          ),
        );
      }
    }

    addSection('0–190Ω SENSOR LINK', ohms0Tanks, TankSensorType.ohms0to190);
    addSection('30–240Ω SENSOR LINK', ohms30Tanks, TankSensorType.ohms30to240);
    return pages;
  }

  void _step(int delta, int pageCount) {
    final next = (_currentPage + delta).clamp(0, pageCount - 1);
    if (next == _currentPage) return;
    setState(() {
      _flipDirection = delta;
      _currentPage = next;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tanksControllerProvider);
    final notifier = ref.read(tanksControllerProvider.notifier);

    final pages = _buildPages(state, notifier);
    final page = _currentPage.clamp(0, pages.length - 1);
    if (page != _currentPage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _currentPage = page);
      });
    }
    final canGoUp = page > 0;
    final canGoDown = page < pages.length - 1;
    // The header only ever shows at the very first page — "the top of
    // the screen" now that browsing is paged, not scrolled.
    final headerVisible = page == 0;

    return Scaffold(
      backgroundColor: const Color(0xFF07080A), // الخلفية الفضائية الموحدة
      body: Stack(
        children: [
          // ================= الإضاءة الخلفية المحيطية (ترمز للمياه/السوائل) =================
          Positioned(
            top: -100,
            left: 0,
            right: 0,
            height: 400,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 0.8,
                  colors: [
                    const Color(0xFF00E5FF).withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // ================= الهيدر المتمركز (فقط في أول صفحة) =================
                AnimatedSize(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.topCenter,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: headerVisible ? 1 : 0,
                    child: headerVisible
                        ? _TanksHeader(
                            isTestMode: state.testMode,
                            onToggleTestMode: () => notifier.setTestMode(!state.testMode),
                          )
                        : const SizedBox(width: double.infinity),
                  ),
                ),

                // ================= صفحة الخزانات الحالية (مثبتة في المنتصف) =================
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimensions.navArrowGutter),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Center(
                          child: _CubeFlipSwitcher(
                            pageKey: page,
                            direction: _flipDirection,
                            child: pages.isEmpty
                                ? const SizedBox()
                                : _TankPageView(key: ValueKey(page), page: pages[page]),
                          ),
                        ),

                        // ================= أزرار التنقل العائمة =================
                        if (canGoUp)
                          Positioned(
                            top: 0,
                            child: _FloatingScrollButton(
                              icon: Icons.keyboard_arrow_up_rounded,
                              onTap: () => _step(-1, pages.length),
                            ),
                          ),
                        if (canGoDown)
                          Positioned(
                            bottom: 24,
                            child: _FloatingScrollButton(
                              icon: Icons.keyboard_arrow_down_rounded,
                              onTap: () => _step(1, pages.length),
                            ),
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

/// A 3D cube-flip transition — the outgoing page rotates away edge-on,
/// the incoming page rotates in from the same hinge, direction (+1/-1)
/// mirroring whether the down or up button was pressed. Replaces the
/// old plain scroll animation with something that visibly reads as "a
/// new page just arrived".
class _CubeFlipSwitcher extends StatelessWidget {
  const _CubeFlipSwitcher({required this.pageKey, required this.direction, required this.child});

  final int pageKey;
  final int direction;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 480),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return AnimatedBuilder(
          animation: animation,
          child: child,
          builder: (context, child) {
            final angle = (1 - animation.value) * (math.pi / 2.3) * direction;
            return Opacity(
              opacity: animation.value.clamp(0.0, 1.0),
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0018)
                  ..rotateX(angle),
                child: child,
              ),
            );
          },
        );
      },
      child: KeyedSubtree(key: ValueKey(pageKey), child: child),
    );
  }
}

class _TankPageView extends StatelessWidget {
  const _TankPageView({super.key, required this.page});

  final _TankPage page;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SectionHeader(title: page.sectionTitle),
        const SizedBox(height: 40),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < 3; i++) ...[
                if (i != 0) const SizedBox(width: 32),
                SizedBox(
                  width: 260,
                  child: AspectRatio(
                    aspectRatio: 0.65,
                    child: i >= page.slots.length
                        ? const SizedBox()
                        : page.slots[i].isAdd
                            ? AddTankTile(onTap: page.onAdd)
                            : TankGridCard(tank: page.slots[i].tank!),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TanksHeader extends StatelessWidget {
  const _TanksHeader({required this.isTestMode, required this.onToggleTestMode});

  final bool isTestMode;
  final VoidCallback onToggleTestMode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 24),
      child: Column(
        children: [
          const Icon(Icons.water_drop_outlined, color: Color(0xFF00E5FF), size: 28),
          const SizedBox(height: 12),
          Text(
            'FLUID LEVELS', // تغيير الاسم ليكون أفخم من Tank Level
            style: AppTextStyles.title.copyWith(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w300,
              letterSpacing: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'SYSTEM MONITORING',
            style: AppTextStyles.caption.copyWith(
              color: Colors.white38,
              letterSpacing: 8,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 24),
          // زر التبديل العائم بين وضع التجربة والواقع
          _GlassModeToggle(isTestMode: isTestMode, onToggle: onToggleTestMode),
        ],
      ),
    );
  }
}

// ================= المكونات البصرية الجديدة =================

class _GlassModeToggle extends StatelessWidget {
  final bool isTestMode;
  final VoidCallback onToggle;

  const _GlassModeToggle({required this.isTestMode, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isTestMode
              ? const Color(0xFFFF9100).withValues(alpha: 0.1) // لون برتقالي يدل على وضع الاختبار
              : const Color(0xFF00E5FF).withValues(alpha: 0.05), // لون أزرق لوضع التشغيل
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isTestMode
                ? const Color(0xFFFF9100).withValues(alpha: 0.3)
                : const Color(0xFF00E5FF).withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isTestMode ? const Color(0xFFFF9100) : const Color(0xFF00E5FF),
                boxShadow: [
                  BoxShadow(
                    color: isTestMode ? const Color(0xFFFF9100) : const Color(0xFF00E5FF),
                    blurRadius: 6,
                  )
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              isTestMode ? 'TEST MODE ACTIVE' : 'REAL SENSORS',
              style: TextStyle(
                color: isTestMode ? const Color(0xFFFF9100) : const Color(0xFF00E5FF),
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 30, height: 1, color: Colors.white.withValues(alpha: 0.1)),
        const SizedBox(width: 16),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
            letterSpacing: 6,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(width: 16),
        Container(width: 30, height: 1, color: Colors.white.withValues(alpha: 0.1)),
      ],
    );
  }
}

class _FloatingScrollButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _FloatingScrollButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Icon(icon, color: Colors.white54, size: 24),
          ),
        ),
      ),
    );
  }
}
