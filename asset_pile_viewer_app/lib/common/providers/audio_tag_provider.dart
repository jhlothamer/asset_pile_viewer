import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:audiotags/audiotags.dart';

part 'audio_tag_provider.g.dart';

@riverpod
FutureOr<Tag?> audioTag(AudioTagRef ref, String filePath) async {
  return AudioTags.read(filePath);
}
