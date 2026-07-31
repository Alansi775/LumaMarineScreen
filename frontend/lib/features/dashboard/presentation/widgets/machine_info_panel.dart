import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/luma_card.dart';
import '../../application/engine_room_controller.dart';
import '../../domain/engine_reading.dart';

/// MAKİNE BİLGİLERİ — İskele Motor / Sancak Motor columns, each with
/// RPM, temperature (red once hot), oil pressure, and load %.
class MachineInfoPanel extends ConsumerWidget {
  const MachineInfoPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(engineRoomControllerProvider);

    return LumaCard(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.makineBilgileri,
            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _EngineColumn(title: AppStrings.iskeleMotor, reading: state.iskele)),
                Container(width: 1, color: AppColors.hairline, margin: const EdgeInsets.symmetric(horizontal: 10)),
                Expanded(child: _EngineColumn(title: AppStrings.sancakMotor, reading: state.sancak)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EngineColumn extends StatelessWidget {
  const _EngineColumn({required this.title, required this.reading});

  final String title;
  final EngineReading reading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textTertiary, fontSize: 11, letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(
          '${reading.rpm} RPM',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.thermostat_outlined, size: 13, color: reading.isHot ? AppColors.warning : AppColors.textSecondary),
            const SizedBox(width: 3),
            Text(
              '${reading.tempC.toStringAsFixed(0)}°C',
              style: TextStyle(
                color: reading.isHot ? AppColors.warning : AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          '${AppStrings.yagBasinciLabel} ${reading.oilBar.toStringAsFixed(1)} bar',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
        ),
        const SizedBox(height: 3),
        Text(
          '${AppStrings.yukLabel} %${reading.loadPercent.toStringAsFixed(0)}',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
        ),
      ],
    );
  }
}
