// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'electrical_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$electricalControllerHash() =>
    r'f2f53bf4e1615ba255416523504da359dba5331e';

/// ELEKTRİK SİSTEMİ — SERVİS / İNVERTÖR / AKÜ BANKASI. Same DC-only
/// caveat as JENERATÖRLER: reference shows AC fields, hardware is
/// DC-only, confirmed with client to show DC volt+amp for now.
///
/// Copied from [ElectricalController].
@ProviderFor(ElectricalController)
final electricalControllerProvider =
    AutoDisposeNotifierProvider<ElectricalController, ElectricalState>.internal(
      ElectricalController.new,
      name: r'electricalControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$electricalControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ElectricalController = AutoDisposeNotifier<ElectricalState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
