import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';

/// Mirrors the ESP32 reference project's per-page status label (e.g. "LED
/// kartı bağlı değil" / "Big relay node not connected") — every control
/// page there honestly shows whether its CAN node has actually responded.
/// Phase 1 has no real hardware yet, so this always reads disconnected;
/// wire it to real node-presence state once the dynamic ID handshake
/// (usrCanDynamicIDMaster.c) is implemented.
class NodeStatusPill extends StatelessWidget {
  const NodeStatusPill({super.key, this.isConnected = false});

  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    final color = isConnected ? AppColors.success : AppColors.warning;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 8),
          Text(
            isConnected ? 'NODE CONNECTED' : 'NODE NOT CONNECTED',
            style: AppTextStyles.caption.copyWith(color: color, letterSpacing: 1.2),
          ),
        ],
      ),
    );
  }
}
