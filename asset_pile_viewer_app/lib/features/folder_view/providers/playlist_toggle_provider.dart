import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'playlist_toggle_provider.g.dart';

@riverpod
class PlayListToggle extends _$PlayListToggle {
  @override
  bool build() {
    return false;
  }

  void toggle() {
    state = !state;
  }
}
