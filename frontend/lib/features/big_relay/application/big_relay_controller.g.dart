// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'big_relay_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bigRelayControllerHash() =>
    r'43bcb413ff495e78ff102201fab824a6fe264faa';

/// 16-channel relay bank with real I/O feedback (usrBigRelayPage.h/.c).
/// Every action responds immediately (so the app demos smoothly) but
/// snaps back after [NodeConnection.revertDelay] since no node is
/// connected to actually confirm it — including Auto Pair.
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
