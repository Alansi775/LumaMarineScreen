/// Sintine Pompa (bilge pump) is tri-state in the reference design —
/// KAPALI / AÇIK / OTOMATİK — everything else is a plain boolean toggle.
/// Lighting (Floor 1/2/3, Water Light) lives in the Aydınlatma Sistemi
/// feature's own controller now, not here — the Sistem Kontrolleri panel
/// on Ana Ekran shows the same 4 channels by reading that state directly,
/// so there's only one source of truth for whether a light is on.
enum SintineMode { kapali, acik, otomatik }

class SystemControlsState {
  const SystemControlsState({
    this.sintinePompa = SintineMode.kapali,
    this.irgat = false,
    this.horn = false,
  });

  final SintineMode sintinePompa;
  final bool irgat;
  final bool horn;

  SystemControlsState copyWith({
    SintineMode? sintinePompa,
    bool? irgat,
    bool? horn,
  }) {
    return SystemControlsState(
      sintinePompa: sintinePompa ?? this.sintinePompa,
      irgat: irgat ?? this.irgat,
      horn: horn ?? this.horn,
    );
  }
}
