// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tank_levels_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tankLevelsControllerHash() =>
    r'ae1b50dcec47cf07e5ef089deee51f632c7cfef0';

/// TANK SEVİYELERİ — sensors already installed per the client (this is
/// "fully real" once hardware is connected, no placeholder caveat),
/// backed by the mock bus the same way real telemetry will be later.
///
/// Copied from [TankLevelsController].
@ProviderFor(TankLevelsController)
final tankLevelsControllerProvider =
    AutoDisposeNotifierProvider<
      TankLevelsController,
      List<TankReading>
    >.internal(
      TankLevelsController.new,
      name: r'tankLevelsControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$tankLevelsControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TankLevelsController = AutoDisposeNotifier<List<TankReading>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
