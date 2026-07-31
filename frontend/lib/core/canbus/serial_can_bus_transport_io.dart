import 'dart:async';
import 'dart:io';

import 'can_frame.dart';
import 'serial_can_bus_transport.dart';

SerialCanBusTransport createSerialCanBusTransport({required String devicePath, required int baudRate}) {
  return _IoSerialCanBusTransport(devicePath: devicePath, baudRate: baudRate);
}

/// Real serial I/O against the Waveshare RS232/422-to-CAN converter
/// (model MP03252, confirmed) on the kiosk's COM2 (`/dev/ttyS1`).
/// `dart:io` has no termios bindings, so the port is put into raw
/// binary mode by shelling out to `stty` before opening it — needed
/// because the kernel's default canonical/text mode (newline-buffered,
/// CR/LF translation) would corrupt raw CAN frame bytes.
///
/// Wire format — the adapter's **"Format Conversion"** mode, per the
/// official user manual
/// (files.waveshare.com/wiki/RS232-485-422-TO-CAN/RS232-485-422-TO-CAN-User-Manual.pdf,
/// §9.3): each CAN frame is exactly 13 bytes — 1 frame-info byte, 4 ID
/// bytes (big-endian; a standard 11-bit ID only needs the low 11 bits
/// of that field, so bytes 1-2 are 0), 8 data bytes (zero-padded past
/// the real DLC). Byte order for the ID field is confirmed from the
/// manual's Modbus section, which spells out ID1=bits28-24 ... ID4=bits7-0.
///
/// REQUIRES the physical adapter to actually be *configured* into
/// Format Conversion mode via Waveshare's own "WS-CAN-TOOL" software —
/// it ships in "Transparent Transmission" mode by default, which is a
/// completely different (and for us unusable, since it can't vary the
/// CAN ID per message) wire format. Also confirm/set the adapter's CAN
/// bitrate to 500kbps via the same tool — its factory default is
/// 250kbps, which would silently prevent any real bus communication
/// regardless of what this class sends, since it wouldn't match the
/// STM32/ESP32 side's actual 500kbps bus speed.
class _IoSerialCanBusTransport implements SerialCanBusTransport {
  _IoSerialCanBusTransport({required this.devicePath, required this.baudRate});

  final String devicePath;
  final int baudRate;

  RandomAccessFile? _file;
  StreamSubscription<List<int>>? _readSub;
  final _incomingController = StreamController<CanFrame>.broadcast();

  @override
  Future<void> open() async {
    // ignore: avoid_print
    print('[SerialCanBus] open() starting for $devicePath @ $baudRate baud...');
    try {
      // ignore: avoid_print
      print('[SerialCanBus] step 1/3: running stty...');
      final configure = await Process.run(
        'stty',
        ['-F', devicePath, 'raw', '$baudRate', '-echo', '-echoe', '-echok'],
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw TimeoutException('stty did not return within 5s'),
      );
      if (configure.exitCode != 0) {
        // ignore: avoid_print
        print('[SerialCanBus] stty configure FAILED (exit ${configure.exitCode}) on $devicePath: '
            '${configure.stderr}');
      } else {
        // ignore: avoid_print
        print('[SerialCanBus] step 1/3 done: $devicePath configured raw @ $baudRate baud');
      }

      // ignore: avoid_print
      print('[SerialCanBus] step 2/3: opening $devicePath for write...');
      // FileMode.writeOnlyAppend seeks to EOF on open, which fails with
      // "Illegal seek" (errno 29) on a character device like a serial
      // port — ttyS1 isn't seekable at all. writeOnly avoids the seek;
      // its O_TRUNC is a harmless no-op on a char device.
      _file = await File(devicePath).open(mode: FileMode.writeOnly).timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw TimeoutException('File.open() for write did not return within 5s'),
          );
      // ignore: avoid_print
      print('[SerialCanBus] step 2/3 done: write handle open');

      // ignore: avoid_print
      print('[SerialCanBus] step 3/3: opening $devicePath for read...');
      _readSub = File(devicePath).openRead().listen(
        (bytes) {
          // ignore: avoid_print
          print(
            '[SerialCanBus] RX raw (${bytes.length}B): '
            '${bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
          );
          final frame = _tryDecode(bytes);
          if (frame != null) _incomingController.add(frame);
        },
        // ignore: avoid_print
        onError: (Object e) => print('[SerialCanBus] read stream error: $e'),
        cancelOnError: false,
      );
      // ignore: avoid_print
      print('[SerialCanBus] step 3/3 done: read stream listening. OPEN COMPLETE.');
    } catch (e, st) {
      // ignore: avoid_print
      print('[SerialCanBus] FAILED to open $devicePath: $e\n$st — commands will be dropped, not thrown.');
    }
  }

  @override
  Future<void> send(CanFrame frame) async {
    final f = _file;
    if (f == null) {
      // ignore: avoid_print
      print('[SerialCanBus] send() before a successful open() — dropped ${frame.toLogString()}');
      return;
    }
    final bytes = _encode(frame);
    try {
      await f.writeFrom(bytes);
      // No f.flush() — that maps to fsync(), which is only meaningful
      // for regular files (forcing dirty pages to disk); on a character
      // device like a serial port it has nothing to sync and fails with
      // EINVAL. The write itself is already unbuffered at this layer.
      // ignore: avoid_print
      print(
        '[SerialCanBus] WROTE ${bytes.length}B to $devicePath: '
        '${bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')} (${frame.toLogString()})',
      );
    } catch (e) {
      // ignore: avoid_print
      print('[SerialCanBus] write FAILED: $e');
    }
  }

  /// Waveshare "Format Conversion" mode, 13 bytes:
  /// `[frameInfo, id1, id2, id3, id4, d1..d8]`.
  /// frameInfo bit7 = FF (0 = standard frame, all our IDs are standard
  /// 11-bit), bit6 = RTR (0 = data frame), bits5-4 = reserved (0),
  /// bits3-0 = DLC. ID is big-endian across id1(bits28-24)..id4(bits7-0);
  /// a standard 11-bit id only ever sets bits in id3/id4.
  List<int> _encode(CanFrame frame) {
    final dlc = frame.data.length.clamp(0, 8);
    final frameInfo = dlc & 0x0F; // FF=0, RTR=0, reserved=0
    final data = List<int>.filled(8, 0);
    for (var i = 0; i < dlc; i++) {
      data[i] = frame.data[i];
    }
    return [
      frameInfo,
      (frame.id >> 24) & 0xFF,
      (frame.id >> 16) & 0xFF,
      (frame.id >> 8) & 0xFF,
      frame.id & 0xFF,
      ...data,
    ];
  }

  CanFrame? _tryDecode(List<int> bytes) {
    if (bytes.length < 13) return null;
    final frameInfo = bytes[0];
    final dlc = frameInfo & 0x0F;
    final id = (bytes[1] << 24) | (bytes[2] << 16) | (bytes[3] << 8) | bytes[4];
    if (dlc > 8) return null;
    return CanFrame(id: id, data: bytes.sublist(5, 5 + dlc));
  }

  @override
  Stream<CanFrame> get incoming => _incomingController.stream;

  @override
  Future<void> dispose() async {
    await _readSub?.cancel();
    await _file?.close();
    await _incomingController.close();
  }
}
