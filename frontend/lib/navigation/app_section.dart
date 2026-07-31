import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/constants/app_strings.dart';

part 'app_section.g.dart';

/// The fixed sidebar's 9 sections. Replaces the old swipe/PageView
/// model entirely — this is now the only navigation, driven by a
/// left-sidebar tap instead of a horizontal drag.
enum AppSection {
  home,
  navigation,
  engineRoom,
  lighting,
  electrical,
  tanks,
  alarms,
  trends,
  settings,
  systemInfo,
}

extension AppSectionMeta on AppSection {
  String get label => switch (this) {
        AppSection.home => AppStrings.navAnaEkran,
        AppSection.navigation => AppStrings.navSeyirBilgileri,
        AppSection.engineRoom => AppStrings.navMakineDairesi,
        AppSection.lighting => AppStrings.navAydinlatmaSistemi,
        AppSection.electrical => AppStrings.navElektrikSistemi,
        AppSection.tanks => AppStrings.navTankSeviyeleri,
        AppSection.alarms => AppStrings.navAlarmListesi,
        AppSection.trends => AppStrings.navTrendGrafikleri,
        AppSection.settings => AppStrings.navAyarlar,
        AppSection.systemInfo => AppStrings.navSistemBilgisi,
      };

  IconData get icon => switch (this) {
        AppSection.home => Icons.dashboard_outlined,
        AppSection.navigation => Icons.explore_outlined,
        AppSection.engineRoom => Icons.precision_manufacturing_outlined,
        AppSection.lighting => Icons.lightbulb_outline_rounded,
        AppSection.electrical => Icons.bolt_outlined,
        AppSection.tanks => Icons.water_drop_outlined,
        AppSection.alarms => Icons.warning_amber_rounded,
        AppSection.trends => Icons.show_chart_rounded,
        AppSection.settings => Icons.settings_outlined,
        AppSection.systemInfo => Icons.info_outline,
      };
}

@riverpod
class AppSectionController extends _$AppSectionController {
  @override
  AppSection build() => AppSection.home;

  void select(AppSection section) => state = section;
}
