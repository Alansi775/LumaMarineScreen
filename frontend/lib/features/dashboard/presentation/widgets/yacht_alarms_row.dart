import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/luma_card.dart';
import '../../application/alarm_list_controller.dart';
import '../../domain/alarm_entry.dart';

/// Middle row: the yacht photo (roughly 2/3 width) beside the Active
/// Alarms panel (roughly 1/3 width) — matches the reference layout.
class YachtAlarmsRow extends ConsumerWidget {
  const YachtAlarmsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarms = ref.watch(alarmListProvider);

    return SizedBox(
      height: 200,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.hairline),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    'assets/images/yacht_photo.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                 ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: LumaCard(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppStrings.aktifAlarmlar,
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: alarms.length,
                      separatorBuilder: (_, _) => const Divider(color: AppColors.hairline, height: 12),
                      itemBuilder: (context, i) => _AlarmRow(alarm: alarms[i]),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => debugPrint('[Dashboard] TÜM ALARMLARI GÖR tapped (placeholder)'),
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.surfaceHighlight,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusSmall)),
                      ),
                      child: const Text(
                        AppStrings.tumAlarmlariGor,
                        style: TextStyle(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AlarmRow extends StatelessWidget {
  const _AlarmRow({required this.alarm});

  final AlarmEntry alarm;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(alarm.severity.icon, size: 16, color: alarm.severity.color),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                alarm.message,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w600),
              ),
              Text(
                '${alarm.time} · ${alarm.location}',
                style: const TextStyle(color: AppColors.textTertiary, fontSize: 9.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
