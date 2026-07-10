// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sockets_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$socketsControllerHash() => r'00b837b6e89cc07a3b8dac2c01b6935ff27b0b33';

/// Fixed 6-channel relay bank — matches the ESP32 Sockets Control page
/// (RELAY_CMD_SET, usrSocketsPage.c) exactly, including the channel count.
///
/// Copied from [SocketsController].
@ProviderFor(SocketsController)
final socketsControllerProvider =
    AutoDisposeNotifierProvider<SocketsController, List<SocketModel>>.internal(
      SocketsController.new,
      name: r'socketsControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$socketsControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SocketsController = AutoDisposeNotifier<List<SocketModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
