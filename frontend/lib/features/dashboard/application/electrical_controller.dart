import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/telemetry/dashboard_bus_service.dart';
import '../../../core/telemetry/dashboard_can_ids.dart';
import '../domain/dc_reading.dart';

part 'electrical_controller.g.dart';

class ElectricalState {
  const ElectricalState({required this.servis, required this.invertor, required this.akuBankasi});

  final DcReading servis;
  final DcReading invertor;
  final DcReading akuBankasi;
}

DcReading _mockElectrical(Random random, {required double baseVoltage, required double baseAmps}) {
  return DcReading(
    voltageDc: baseVoltage + random.nextDouble() * 0.4 - 0.2,
    ampsDc: baseAmps + random.nextDouble() * 4 - 2,
  );
}

/// ELEKTRİK SİSTEMİ — SERVİS / İNVERTÖR / AKÜ BANKASI. Same DC-only
/// caveat as JENERATÖRLER: reference shows AC fields, hardware is
/// DC-only, confirmed with client to show DC volt+amp for now.
@riverpod
class ElectricalController extends _$ElectricalController {
  final _random = Random();

  @override
  ElectricalState build() {
    final bus = ref.watch(dashboardBusServiceProvider);
    bus.ensureMockChannel(DashboardCanIds.elektrikServis, () => _mockElectrical(_random, baseVoltage: 24.2, baseAmps: 18));
    bus.ensureMockChannel(DashboardCanIds.elektrikInvertor, () => _mockElectrical(_random, baseVoltage: 24.0, baseAmps: 12));
    bus.ensureMockChannel(DashboardCanIds.elektrikAku, () => _mockElectrical(_random, baseVoltage: 25.8, baseAmps: -4));

    final subs = [
      bus.frames(DashboardCanIds.elektrikServis).listen((f) {
        state = ElectricalState(servis: f.payload as DcReading, invertor: state.invertor, akuBankasi: state.akuBankasi);
      }),
      bus.frames(DashboardCanIds.elektrikInvertor).listen((f) {
        state = ElectricalState(servis: state.servis, invertor: f.payload as DcReading, akuBankasi: state.akuBankasi);
      }),
      bus.frames(DashboardCanIds.elektrikAku).listen((f) {
        state = ElectricalState(servis: state.servis, invertor: state.invertor, akuBankasi: f.payload as DcReading);
      }),
    ];
    ref.onDispose(() {
      for (final s in subs) {
        s.cancel();
      }
    });

    return ElectricalState(
      servis: _mockElectrical(_random, baseVoltage: 24.2, baseAmps: 18),
      invertor: _mockElectrical(_random, baseVoltage: 24.0, baseAmps: 12),
      akuBankasi: _mockElectrical(_random, baseVoltage: 25.8, baseAmps: -4),
    );
  }
}
