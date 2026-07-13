// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shunt_relay_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$shuntRelayControllerHash() =>
    r'5a1f896d0ed322c4d6c114406ca0846b910464b7';

/// The Big Shunt card's 2 relay outputs (BIG_SHUNT_CMD_SET_RELAY,
/// usrShuntPage.h) — index 0 = relay 1, index 1 = relay 2. Snaps back
/// after [NodeConnection.revertDelay] since no shunt node is connected.
///
/// Copied from [ShuntRelayController].
@ProviderFor(ShuntRelayController)
final shuntRelayControllerProvider =
    AutoDisposeNotifierProvider<ShuntRelayController, List<bool>>.internal(
      ShuntRelayController.new,
      name: r'shuntRelayControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$shuntRelayControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ShuntRelayController = AutoDisposeNotifier<List<bool>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
