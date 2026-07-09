import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tv_controller.g.dart';

/// Single on/off toggle for the saloon TV.
@riverpod
class TvController extends _$TvController {
  @override
  bool build() => false;

  void toggle() => state = !state;
}
