// lib/features/lighting/application/lighting_controller.g.dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lighting_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ledNodeAssignmentHash() => r'4bc427a98ebd0220f7b8becd667f7eb986f616ba';

/// Reactive LED board connection status for the screen's status pill —
/// null/inactive until the real board completes the ID handshake.
///
/// Copied from [ledNodeAssignment].
@ProviderFor(ledNodeAssignment)
final ledNodeAssignmentProvider =
    AutoDisposeStreamProvider<AssignedCanNode?>.internal(
      ledNodeAssignment,
      name: r'ledNodeAssignmentProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$ledNodeAssignmentHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LedNodeAssignmentRef = AutoDisposeStreamProviderRef<AssignedCanNode?>;
String _$lightingControllerHash() =>
    r'194afcd98aff39aaf2e3b738bf06bca971d34683';

/// AYDINLATMA SİSTEMİ — the 4 physically-wired LED channels (led# 1-4 on
/// the real board; 5-6 are unused on this yacht). Every toggle/dimmer
/// change sends the exact frame the STM32 LED board firmware expects
/// (LED_CMD_SET / LED_CMD_SET_BRIGHTNESS), addressed to whatever CAN ID
/// [CanIdMaster] has dynamically assigned that board — never a fixed ID,
/// since the real board doesn't have one until the handshake completes.
///
/// Copied from [LightingController].
@ProviderFor(LightingController)
final lightingControllerProvider =
    AutoDisposeNotifierProvider<
      LightingController,
      List<LightChannel>
    >.internal(
      LightingController.new,
      name: r'lightingControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$lightingControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LightingController = AutoDisposeNotifier<List<LightChannel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
