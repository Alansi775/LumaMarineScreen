/// DC voltage + amps — shared shape for JENERATÖRLER and ELEKTRİK
/// SİSTEMİ panels. The reference design shows AC fields (Volt/Hz/kW);
/// current hardware only measures DC, so this is the confirmed
/// placeholder mapping until real AC metering is added.
class DcReading {
  const DcReading({required this.voltageDc, required this.ampsDc});

  final double voltageDc;
  final double ampsDc;

  double get wattsDc => voltageDc * ampsDc;
}
