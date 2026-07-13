import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/node_status_pill.dart';
import '../../../core/widgets/section_label.dart';
import '../application/sockets_controller.dart';
import 'widgets/socket_tile.dart';

class SocketsScreen extends ConsumerWidget {
  const SocketsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sockets = ref.watch(socketsControllerProvider);
    final notifier = ref.read(socketsControllerProvider.notifier);
    final onCount = sockets.where((s) => s.isOn).length;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.pagePadding,
          AppDimensions.pagePadding,
          AppDimensions.pagePadding,
          AppDimensions.pagePadding + 40,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionLabel(
              'SOCKETS',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const NodeStatusPill(),
                  const SizedBox(width: 16),
                  Text('$onCount / ${sockets.length} ON', style: AppTextStyles.sectionLabel),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: notifier.allOff,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                        border: Border.all(color: AppColors.hairline),
                      ),
                      child: Text('CLOSE ALL', style: AppTextStyles.caption.copyWith(letterSpacing: 1.2)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: AppDimensions.gutter,
                crossAxisSpacing: AppDimensions.gutter,
                childAspectRatio: 1.6,
                children: [
                  for (final socket in sockets)
                    SocketTile(socket: socket, onToggle: () => notifier.toggle(socket.id)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
