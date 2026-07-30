import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/weather_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/luma_card.dart';

/// Top row of the reference design: 6 small status cards. GPS/Speed/
/// Heading/Outside Temp show a "MODÜL YOK" placeholder (no hardware
/// installed yet); System Status is a simple static-good state; Weather
/// is real, fetched over the device's Ethernet connection for a fixed
/// Istanbul location (no GPS yet to know the yacht's real position).
class StatusCardsRow extends ConsumerWidget {
  const StatusCardsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weather = ref.watch(weatherProvider).valueOrNull;

    return SizedBox(
      height: 92,
      child: Row(
        children: [
          Expanded(
            child: _StatusCard(
              icon: Icons.shield_outlined,
              iconColor: AppColors.success,
              title: AppStrings.cardSistemDurumu,
              value: AppStrings.sistemDurumuNormal,
              valueColor: AppColors.success,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatusCard(
              icon: Icons.gps_fixed_rounded,
              iconColor: AppColors.textTertiary,
              title: AppStrings.cardGpsKonumu,
              value: AppStrings.placeholderDash,
              subtitle: AppStrings.gpsModuluYok,
              unavailable: true,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatusCard(
              icon: Icons.speed_rounded,
              iconColor: AppColors.textTertiary,
              title: AppStrings.cardHiz,
              value: AppStrings.placeholderDash,
              subtitle: AppStrings.hizSensoruYok,
              unavailable: true,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatusCard(
              icon: Icons.explore_outlined,
              iconColor: AppColors.textTertiary,
              title: AppStrings.cardRota,
              value: AppStrings.placeholderDash,
              subtitle: AppStrings.pusulaModuluYok,
              unavailable: true,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatusCard(
              icon: Icons.thermostat_outlined,
              iconColor: AppColors.textTertiary,
              title: AppStrings.cardDisSicaklik,
              value: AppStrings.placeholderDash,
              subtitle: AppStrings.sicaklikSensoruYok,
              unavailable: true,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatusCard(
              icon: weather?.icon ?? Icons.cloud_outlined,
              iconColor: AppColors.solar,
              title: AppStrings.cardHavaDurumu,
              value: weather != null ? '${weather.temperatureC.round()}°C' : AppStrings.placeholderDash,
              subtitle: weather?.condition ?? 'İSTANBUL',
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    this.subtitle,
    this.valueColor,
    this.unavailable = false,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String? subtitle;
  final Color? valueColor;
  final bool unavailable;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: unavailable ? 0.55 : 1,
      child: LumaCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Icon(icon, size: 22, color: iconColor),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.textTertiary, fontSize: 9, letterSpacing: 0.8),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: valueColor ?? Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.textTertiary, fontSize: 8.5),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
