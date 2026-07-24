// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shunt_relay_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$shuntRelayControllerHash() =>
    r'9fa4d754d8e3134611c59d4833d061457c188e99';

/// The Big Shunt card's 2 relay outputs (BIG_SHUNT_CMD_SET_RELAY,
/// usrShuntPage.h) — index 0 = relay 1, index 1 = relay 2. Toggles and
/// stays — [NodeStatusPill] is the honest signal about whether hardware
/// is actually there, not a state that reverts itself.
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
