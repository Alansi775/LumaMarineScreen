import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/luma_card.dart';
import '../../application/electrical_controller.dart';
import '../../domain/dc_reading.dart';

/// ELEKTRİK SİSTEMİ — SERVİS / İNVERTÖR / AKÜ BANKASI columns, DC
/// voltage + amps (same DC-only caveat as JENERATÖRLER).
class ElectricalPanel extends ConsumerWidget {
  const ElectricalPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(electricalControllerProvider);

    return LumaCard(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.elektrikSistemi,
            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _ElecColumn(title: AppStrings.servis, reading: state.servis)),
                _divider(),
                Expanded(child: _ElecColumn(title: AppStrings.invertor, reading: state.invertor)),
                _divider(),
                Expanded(child: _ElecColumn(title: AppStrings.akuBankasi, reading: state.akuBankasi)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(width: 1, color: AppColors.hairline, margin: const EdgeInsets.symmetric(horizontal: 6));
}

class _ElecColumn extends StatelessWidget {
  const _ElecColumn({required this.title, required this.reading});

  final String title;
  final DcReading reading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppColors.textTertiary, fontSize: 8.5, letterSpacing: 0.3),
        ),
        const SizedBox(height: 4),
        Text(
          '${reading.voltageDc.toStringAsFixed(1)}V',
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text('${reading.ampsDc.toStringAsFixed(1)}A', style: const TextStyle(color: AppColors.textSecondary, fontSize: 9.5)),
      ],
    );
  }
}
