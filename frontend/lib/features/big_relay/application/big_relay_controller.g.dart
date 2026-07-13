// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'big_relay_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bigRelayControllerHash() =>
    r'84380251c48acfc54ec7e8aff6a4215c08426163';

/// 16-channel relay bank with real I/O feedback (usrBigRelayPage.h/.c).
/// Every action is rejected outright when no node is connected, exactly
/// like the real firmware's "NODE NOT CONNECTED" status — including
/// Auto Pair, which on the real device visibly refuses to toggle.
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
