// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_controls_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$systemControlsControllerHash() =>
    r'e214c957f82424826c6873d4c9f2fa020c95d39c';

/// SİSTEM KONTROLLERİ (minus lighting, which reads straight from
/// `lightingControllerProvider`) — every toggle here is confirmed
/// "fully real": each already has its own CAN id and sends a real
/// packet once hardware is connected (currently logged by
/// [MockDashboardBusService] instead of transmitted).
///
/// Copied from [SystemControlsController].
@ProviderFor(SystemControlsController)
final systemControlsControllerProvider =
    AutoDisposeNotifierProvider<
      SystemControlsController,
      SystemControlsState
    >.internal(
      SystemControlsController.new,
      name: r'systemControlsControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$systemControlsControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SystemControlsController = AutoDisposeNotifier<SystemControlsState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
