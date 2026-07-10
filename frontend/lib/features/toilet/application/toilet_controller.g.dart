// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toilet_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$toiletControllerHash() => r'bdc787b96c579002cccd0ed1add8c03a764157a7';

/// 6-channel PWM pump control (usrToiletPage.c). Channel index is 0-based
/// and added directly to the fixed base CAN IDs — no dynamic node lookup.
///
/// Copied from [ToiletController].
@ProviderFor(ToiletController)
final toiletControllerProvider =
    AutoDisposeNotifierProvider<ToiletController, List<ToiletChannel>>.internal(
      ToiletController.new,
      name: r'toiletControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$toiletControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ToiletController = AutoDisposeNotifier<List<ToiletChannel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
