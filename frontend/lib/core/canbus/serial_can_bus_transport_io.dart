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
/// One RDWR file handle serves both directions — reading uses a manual
/// polling loop (`RandomAccessFile.read`), not `File.openRead()`: that
/// stream API assumes a regular file with a known size (it stats the
/// file to know when to signal done), and a character device reports
/// size 0, so the stream was silently completing right after open,
/// before any real data could ever arrive — confirmed live: writes
/// worked (Waveshare's own RX LED blinked) but zero bytes were ever
/// seen coming back, even with a real CAN frame known to be on the bus.
class _IoSerialCanBusTransport implements SerialCanBusTransport {
  _IoSerialCanBusTransport({required this.devicePath, required this.baudRate});

  final String devicePath;
  final int baudRate;

  RandomAccessFile? _file;
  bool _reading = false;
  final List<int> _rxBuffer = [];
  final _incomingController = StreamController<CanFrame>.broadcast();

  @override
  Future<void> open() async {
    // ignore: avoid_print
    print('[SerialCanBus] open() starting for $devicePath @ $baudRate baud...');
    try {
      // ignore: avoid_print
      print('[SerialCanBus] step 1/2: running stty...');
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
        print('[SerialCanBus] step 1/2 done: $devicePath configured raw @ $baudRate baud');
      }

      // ignore: avoid_print
      print('[SerialCanBus] step 2/2: opening $devicePath read+write...');
      // FileMode.write = O_RDWR|O_CREAT|O_TRUNC — no O_APPEND (which
      // seeks to EOF on open and fails with "Illegal seek" on a
      // character device) and gives both directions on one fd. O_TRUNC
      // is a harmless no-op on a char device.
      _file = await File(devicePath).open(mode: FileMode.write).timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw TimeoutException('File.open() did not return within 5s'),
          );
      // ignore: avoid_print
      print('[SerialCanBus] step 2/2 done: handle open. OPEN COMPLETE.');

      _reading = true;
      unawaited(_readLoop());
    } catch (e, st) {
      // ignore: avoid_print
      print('[SerialCanBus] FAILED to open $devicePath: $e\n$st — commands will be dropped, not thrown.');
    }
  }

  Future<void> _readLoop() async {
    while (_reading) {
      final f = _file;
      if (f == null) break;
      try {
        final chunk = await f.read(256);
        if (chunk.isEmpty) {
          // A real character device read blocks until data or error, so
          // this shouldn't spin, but guard against a runaway loop
          // regardless.
          await Future.delayed(const Duration(milliseconds: 50));
          continue;
        }
        // ignore: avoid_print
        print(
          '[SerialCanBus] RX raw (${chunk.length}B): '
          '${chunk.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
        );
        _rxBuffer.addAll(chunk);
        _drainFrames();
      } catch (e) {
        if (!_reading) break;
        // ignore: avoid_print
        print('[SerialCanBus] read loop error: $e');
        await Future.delayed(const Duration(milliseconds: 200));
      }
    }
  }

  void _drainFrames() {
    while (_rxBuffer.length >= 13) {
      final frameBytes = _rxBuffer.sublist(0, 13);
      _rxBuffer.removeRange(0, 13);
      final frame = _tryDecode(frameBytes);
      if (frame != null) _incomingController.add(frame);
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
    _reading = false;
    await _file?.close();
    await _incomingController.close();
  }
}
