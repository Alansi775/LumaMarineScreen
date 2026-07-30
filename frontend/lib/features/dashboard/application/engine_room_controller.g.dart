// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'engine_room_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$engineRoomControllerHash() =>
    r'97b9bde62ee1a15fa4fdcc0ab5f7b6b848dd128c';

/// MAKİNE BİLGİLERİ — İskele/Sancak motor readings. Not explicitly
/// classified real-vs-placeholder in the client's spec (only system
/// control toggles + tank levels were confirmed "fully real now"), so
/// this is mock-backed like generators/electrical until engine sensors
/// are confirmed installed.
///
/// Copied from [EngineRoomController].
@ProviderFor(EngineRoomController)
final engineRoomControllerProvider =
    AutoDisposeNotifierProvider<EngineRoomController, EngineRoomState>.internal(
      EngineRoomController.new,
      name: r'engineRoomControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$engineRoomControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$EngineRoomController = AutoDisposeNotifier<EngineRoomState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
