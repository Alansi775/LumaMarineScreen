// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lights_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$lightsControllerHash() => r'6c63de7e72db617a51104bbef061907823d07d78';

/// In-memory light registry. Fully user-managed: toggle on/off, add new
/// named lights. Persistence across app restarts plugs in here later by
/// swapping [build]'s seed + adding a save-on-mutation call — no UI change.
/// The first 6 channels default to "PWM-1".."PWM-6" — the exact default
/// names the ESP32 firmware ships with (`button_names[1]` in
/// usrSettingsPage.c) before a user renames them via Settings.
///
/// Copied from [LightsController].
@ProviderFor(LightsController)
final lightsControllerProvider =
    AutoDisposeNotifierProvider<LightsController, List<Light>>.internal(
      LightsController.new,
      name: r'lightsControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$lightsControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LightsController = AutoDisposeNotifier<List<Light>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
