import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/control_panel/control_page_header.dart';
import '../../../core/widgets/section_label.dart';
import '../../tv/presentation/widgets/tv_control_card.dart';
import '../application/doors_controller.dart';
import 'widgets/door_tile.dart';

class DoorsScreen extends ConsumerWidget {
  const DoorsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doors = ref.watch(doorsControllerProvider);
    final notifier = ref.read(doorsControllerProvider.notifier);

    return Container(
      color: const Color(0xFF07080A),
      child: SafeArea(
        child: Column(
          children: [
            const ControlPageHeader(
              icon: Icons.meeting_room_outlined,
              title: 'DOORS',
              subtitle: 'ACCESS CONTROL',
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.pagePadding,
                  0,
                  AppDimensions.pagePadding,
                  AppDimensions.pagePadding + 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        for (final door in doors) ...[
                          Expanded(
                            child: DoorTile(
                              door: door,
                              onTrigger: () => notifier.trigger(door.id),
                            ),
                          ),
                          if (door != doors.last) const SizedBox(width: AppDimensions.gutter),
                        ],
                      ],
                    ),
                    const SizedBox(height: 40),
                    const SectionLabel('ENTERTAINMENT'),
                    const SizedBox(height: 20),
                    const TvControlCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
