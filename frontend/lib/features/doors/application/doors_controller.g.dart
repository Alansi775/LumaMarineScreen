// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doors_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$doorsControllerHash() => r'a9585b9185b9ee47a28b8c378cb84c769b7fbbeb';

/// Two monitored doors. [trigger] opens a door and automatically closes it
/// again one second later — a real release pulse, not a sticky toggle.
///
/// Copied from [DoorsController].
@ProviderFor(DoorsController)
final doorsControllerProvider =
    AutoDisposeNotifierProvider<DoorsController, List<Door>>.internal(
      DoorsController.new,
      name: r'doorsControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$doorsControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DoorsController = AutoDisposeNotifier<List<Door>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
