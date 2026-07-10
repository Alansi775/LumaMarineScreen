/// A single CAN bus frame: an 11-bit identifier plus up to 8 data bytes.
/// Mirrors the wire format the ESP32 master control unit uses
/// (see `usrCAN.c` / `sendCanMessage` in the reference project).
class CanFrame {
  const CanFrame({required this.id, required this.data})
      : assert(data.length <= 8, 'CAN frames carry at most 8 data bytes');

  final int id;
  final List<int> data;

  /// Matches the ESP32's own `ESP_LOGI(tag, "TX: ID=0x%03lX DLC=%d
  /// Data=[...]")` format exactly, so logs from both systems read the same
  /// way side by side.
  String toLogString() {
    final hexId = id.toRadixString(16).padLeft(3, '0').toUpperCase();
    final bytes = List.generate(8, (i) => i < data.length ? data[i] : 0);
    final hexBytes = bytes
        .map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase())
        .join(' ');
    return 'TX: ID=0x$hexId DLC=${data.length} Data=[$hexBytes]';
  }
}
