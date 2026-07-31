import 'dart:async';
import 'dart:io';

import 'can_frame.dart';
import 'serial_can_bus_transport.dart';

SerialCanBusTransport createSerialCanBusTransport({required String devicePath, required int baudRate}) {
  return _IoSerialCanBusTransport(devicePath: devicePath, baudRate: baudRate);
}

/// Real serial I/O against the Waveshare RS232/422-to-CAN converter on
/// the kiosk's COM2 (`/dev/ttyS1`) — confirmed reachable (a manual
/// `sudo tee /dev/ttyS1` test got through). `dart:io` has no termios
/// bindings, so the port is put into raw binary mode by shelling out to
/// `stty` before opening it — needed because the kernel's default
/// canonical/text mode (newline-buffered, CR/LF translation) would
/// corrupt raw CAN frame bytes.
///
/// CAVEAT — the byte envelope `_encode`/`_tryDecode` use
/// (`[idHi, idLo, dlc, ...data]`) is NOT a confirmed spec for this
/// Waveshare model, just a reasonable placeholder. Every outgoing byte
/// is logged so real hardware behavior (or silence) can be compared
/// against whatever the adapter actually expects once its datasheet is
/// in hand; swap these two methods for the real framing then — nothing
/// else in the app depends on the wire format.
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
      await f.flush();
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

  List<int> _encode(CanFrame frame) {
    return [(frame.id >> 8) & 0xFF, frame.id & 0xFF, frame.data.length, ...frame.data];
  }

  CanFrame? _tryDecode(List<int> bytes) {
    if (bytes.length < 3) return null;
    final id = (bytes[0] << 8) | bytes[1];
    final dlc = bytes[2];
    if (dlc > 8 || bytes.length < 3 + dlc) return null;
    return CanFrame(id: id, data: bytes.sublist(3, 3 + dlc));
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
