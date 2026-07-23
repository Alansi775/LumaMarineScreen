import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// The animated "more below" pill pinned bottom-center — a gently
/// bouncing chevron that scrolls the grid down by one row when pressed.
class TankScrollMoreButton extends StatefulWidget {
  const TankScrollMoreButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  State<TankScrollMoreButton> createState() => _TankScrollMoreButtonState();
}

class _TankScrollMoreButtonState extends State<TankScrollMoreButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  late final Animation<double> _bounce = Tween<double>(begin: 0, end: 6).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 56,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.surfaceRaised,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
          boxShadow: [
            BoxShadow(color: AppColors.accent.withValues(alpha: 0.25), blurRadius: 16),
          ],
        ),
        child: AnimatedBuilder(
          animation: _bounce,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _bounce.value),
              child: child,
            );
          },
          child: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.accent, size: 28),
        ),
      ),
    );
  }
}
