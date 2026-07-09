import 'package:flutter/material.dart';

import '../../../core/theme/app_dimensions.dart';
import 'widgets/main_battery_hero.dart';
import 'widgets/pressure_card.dart';
import 'widgets/time_date_display.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.pagePadding,
          AppDimensions.pagePadding,
          AppDimensions.pagePadding,
          AppDimensions.pagePadding + 40,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const TimeDateDisplay(),
                  const SizedBox(height: 28),
                  const PressureCard(),
                ],
              ),
            ),
            const SizedBox(width: AppDimensions.gutter),
            const Expanded(
              flex: 4,
              child: Center(child: MainBatteryHero()),
            ),
          ],
        ),
      ),
    );
  }
}
