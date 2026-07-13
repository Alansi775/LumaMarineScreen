import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/node_status_pill.dart';
import '../../../core/widgets/section_label.dart';
import '../application/lights_controller.dart';
import 'widgets/add_light_tile.dart';
import 'widgets/light_tile.dart';

class LightsScreen extends ConsumerWidget {
  const LightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lights = ref.watch(lightsControllerProvider);
    final notifier = ref.read(lightsControllerProvider.notifier);
    final onCount = lights.where((l) => l.isOn).length;

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
              'LIGHTS',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const NodeStatusPill(),
                  const SizedBox(width: 16),
                  Text('$onCount / ${lights.length} ON', style: AppTextStyles.sectionLabel),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: notifier.closeAll,
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
                crossAxisCount: 5,
                mainAxisSpacing: AppDimensions.gutter,
                crossAxisSpacing: AppDimensions.gutter,
                childAspectRatio: 1.05,
                children: [
                  for (final light in lights)
                    LightTile(
                      light: light,
                      onToggle: () => notifier.toggle(light.id),
                    ),
                  const AddLightTile(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
