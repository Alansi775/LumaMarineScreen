// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'big_relay_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bigRelayControllerHash() =>
    r'bb659c7bab829d7604b5be64cc2d52775e0fa35a';

/// 16-channel relay bank with real I/O feedback (usrBigRelayPage.h/.c).
/// Every action toggles and stays — [NodeStatusPill] is the honest
/// signal about whether hardware is actually there, not a state that
/// reverts itself.
///
/// Copied from [BigRelayController].
@ProviderFor(BigRelayController)
final bigRelayControllerProvider =
    AutoDisposeNotifierProvider<BigRelayController, BigRelayState>.internal(
      BigRelayController.new,
      name: r'bigRelayControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$bigRelayControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BigRelayController = AutoDisposeNotifier<BigRelayState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
