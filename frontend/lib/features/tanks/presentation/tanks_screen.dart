// frontend/lib/features/tanks/presentation/tanks_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_text_styles.dart';
import '../application/tanks_controller.dart';
import '../domain/tank_model.dart';
import 'widgets/add_tank_tile.dart';
import 'widgets/tank_grid_card.dart';

class TanksScreen extends ConsumerStatefulWidget {
  const TanksScreen({super.key});

  @override
  ConsumerState<TanksScreen> createState() => _TanksScreenState();
}

class _TanksScreenState extends ConsumerState<TanksScreen> {
  final _scrollController = ScrollController();
  final _scrollViewportKey = GlobalKey();

  // Keyed by a stable "section-row" id (not tank id) so the same
  // GlobalKey identity survives rebuilds — losing it would make Flutter
  // remount each row's cards on every state tick, restarting their
  // fill-level TweenAnimationBuilder mid-animation.
  final Map<String, GlobalKey> _rowKeys = {};
  List<String> _rowOrder = [];

  bool _canScrollUp = false;
  bool _canScrollDown = false;
  bool _headerVisible = true;
  double _lastScrollPixels = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateScrollState);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateScrollState());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollState);
    _scrollController.dispose();
    super.dispose();
  }

  GlobalKey _keyForRow(String id) => _rowKeys.putIfAbsent(id, () => GlobalKey());

  void _updateScrollState() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final pixels = position.pixels;
    final canUp = pixels > 4;
    final canDown = pixels < position.maxScrollExtent - 4;

    final delta = pixels - _lastScrollPixels;
    bool? headerVisible;
    if (pixels <= 4) {
      headerVisible = true;
    } else if (delta > 6) {
      headerVisible = false;
    } else if (delta < -6) {
      headerVisible = true;
    }
    _lastScrollPixels = pixels;

    if (canUp != _canScrollUp ||
        canDown != _canScrollDown ||
        (headerVisible != null && headerVisible != _headerVisible)) {
      setState(() {
        _canScrollUp = canUp;
        _canScrollDown = canDown;
        if (headerVisible != null) _headerVisible = headerVisible;
      });
    }
  }

  /// The row whose vertical center currently sits closest to the
  /// viewport's center — the reference point the up/down buttons step
  /// from.
  int? _currentCenteredRowIndex() {
    final viewportBox = _scrollViewportKey.currentContext?.findRenderObject() as RenderBox?;
    if (viewportBox == null) return null;
    final viewportCenter = viewportBox.size.height / 2;

    double? bestDist;
    int? bestIndex;
    for (var i = 0; i < _rowOrder.length; i++) {
      final rowBox = _rowKeys[_rowOrder[i]]?.currentContext?.findRenderObject() as RenderBox?;
      if (rowBox == null) continue;
      final rowTop = rowBox.localToGlobal(Offset.zero, ancestor: viewportBox).dy;
      final rowCenter = rowTop + rowBox.size.height / 2;
      final dist = (rowCenter - viewportCenter).abs();
      if (bestDist == null || dist < bestDist) {
        bestDist = dist;
        bestIndex = i;
      }
    }
    return bestIndex;
  }

  void _centerRowAtIndex(int index) {
    if (index < 0 || index >= _rowOrder.length || !_scrollController.hasClients) return;
    final viewportBox = _scrollViewportKey.currentContext?.findRenderObject() as RenderBox?;
    final rowBox = _rowKeys[_rowOrder[index]]?.currentContext?.findRenderObject() as RenderBox?;
    if (viewportBox == null || rowBox == null) return;

    final rowTopInViewport = rowBox.localToGlobal(Offset.zero, ancestor: viewportBox).dy;
    final centeringDelta = rowTopInViewport - (viewportBox.size.height - rowBox.size.height) / 2;
    final target = (_scrollController.offset + centeringDelta)
        .clamp(0.0, _scrollController.position.maxScrollExtent);
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
  }

  /// direction: -1 for the up button, +1 for the down button — always
  /// lands on the next row of 3 tanks centered in the middle of the
  /// screen, never a small arbitrary scroll amount.
  void _stepRow(int direction) {
    final current = _currentCenteredRowIndex();
    if (current == null) return;
    _centerRowAtIndex(current + direction);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tanksControllerProvider);
    final notifier = ref.read(tanksControllerProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateScrollState());

    final ohms0Tanks = state.tanks.where((t) => t.sensorType == TankSensorType.ohms0to190).toList();
    final ohms30Tanks = state.tanks.where((t) => t.sensorType == TankSensorType.ohms30to240).toList();

    _rowOrder = [];

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
                // ================= الهيدر المتمركز (يختفي عند التمرير لأسفل) =================
                AnimatedSize(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.topCenter,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _headerVisible ? 1 : 0,
                    child: _headerVisible
                        ? _TanksHeader(
                            isTestMode: state.testMode,
                            onToggleTestMode: () => notifier.setTestMode(!state.testMode),
                          )
                        : const SizedBox(width: double.infinity),
                  ),
                ),

                // ================= منطقة الخزانات القابلة للتمرير =================
                Expanded(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        key: _scrollViewportKey,
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(), // تمرير ناعم ومطاطي
                        padding: const EdgeInsets.fromLTRB(40, 24, 40, 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center, // توسيط كامل المحتوى
                          children: [
                            _SectionHeader(title: '0–190Ω SENSOR LINK'),
                            const SizedBox(height: 24),
                            _TankRows(
                              sectionId: 'ohms0',
                              tanks: ohms0Tanks,
                              onAdd: () => notifier.addTank(TankSensorType.ohms0to190),
                              keyForRow: _keyForRow,
                              rowOrder: _rowOrder,
                            ),
                            const SizedBox(height: 56),

                            _SectionHeader(title: '30–240Ω SENSOR LINK'),
                            const SizedBox(height: 24),
                            _TankRows(
                              sectionId: 'ohms30',
                              tanks: ohms30Tanks,
                              onAdd: () => notifier.addTank(TankSensorType.ohms30to240),
                              keyForRow: _keyForRow,
                              rowOrder: _rowOrder,
                            ),
                          ],
                        ),
                      ),

                      // ================= أزرار التمرير العائمة (Floating Scroll Indicators) =================
                      if (_canScrollUp)
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: _FloatingScrollButton(
                              icon: Icons.keyboard_arrow_up_rounded,
                              onTap: () => _stepRow(-1),
                            ),
                          ),
                        ),
                      if (_canScrollDown)
                        Positioned(
                          bottom: 24,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: _FloatingScrollButton(
                              icon: Icons.keyboard_arrow_down_rounded,
                              onTap: () => _stepRow(1),
                            ),
                          ),
                        ),
                    ],
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

/// Lays a section's tanks (+ trailing add-tile) out as explicit 3-wide
/// rows instead of a GridView, so each row can carry a stable GlobalKey
/// — that's what lets the floating up/down buttons measure real row
/// positions and center the next one, instead of scrolling by a blind
/// fixed pixel amount.
class _TankRows extends StatelessWidget {
  const _TankRows({
    required this.sectionId,
    required this.tanks,
    required this.onAdd,
    required this.keyForRow,
    required this.rowOrder,
  });

  final String sectionId;
  final List<Tank> tanks;
  final VoidCallback onAdd;
  final GlobalKey Function(String id) keyForRow;
  final List<String> rowOrder;

  @override
  Widget build(BuildContext context) {
    const columns = 3;
    final slotCount = tanks.length + 1; // +1 for the add-tank tile
    final rowCount = (slotCount / columns).ceil();

    final rows = <Widget>[];
    for (var r = 0; r < rowCount; r++) {
      final rowId = '$sectionId-$r';
      rowOrder.add(rowId);

      final start = r * columns;
      final cells = <Widget>[];
      for (var c = 0; c < columns; c++) {
        if (c != 0) cells.add(const SizedBox(width: 32));
        final index = start + c;
        if (index < tanks.length) {
          cells.add(Expanded(child: AspectRatio(aspectRatio: 0.65, child: TankGridCard(tank: tanks[index]))));
        } else if (index == tanks.length) {
          cells.add(Expanded(child: AspectRatio(aspectRatio: 0.65, child: AddTankTile(onTap: onAdd))));
        } else {
          cells.add(const Expanded(child: SizedBox()));
        }
      }

      rows.add(Row(key: keyForRow(rowId), crossAxisAlignment: CrossAxisAlignment.start, children: cells));
      if (r != rowCount - 1) rows.add(const SizedBox(height: 32));
    }

    return Column(children: rows);
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
                fontSize: 10,
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
            fontSize: 11,
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
