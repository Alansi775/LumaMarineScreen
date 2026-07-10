// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tvControllerHash() => r'bcee28a4c7bef3ecca720ef55b5b3dc2e255fc1b';

/// Single on/off toggle for the saloon TV — wired to relay channel 1
/// (RELAY_CMD_SET, see usrSocketsPage.c).
///
/// Copied from [TvController].
@ProviderFor(TvController)
final tvControllerProvider =
    AutoDisposeNotifierProvider<TvController, bool>.internal(
      TvController.new,
      name: r'tvControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$tvControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TvController = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
