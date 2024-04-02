import 'package:assetPileViewer/common/providers/audio_tag_provider.dart';
import 'package:assetPileViewer/common/util/duration_extensions.dart';
import 'package:audiotags/audiotags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AudioFileDetails extends ConsumerWidget {
  final String filePath;
  const AudioFileDetails({super.key, required this.filePath});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(audioTagProvider(filePath));

    return results.when(
      data: (tag) {
        return Column(
          children: [..._tagToWidgets(tag)],
        );
      },
      error: (e, __) {
        return Text('Error getting tags: ${e.toString()}');
      },
      loading: () => const Text('loading audio tags ...'),
    );
  }

  List<Widget> _tagToWidgets(Tag? tag) {
    if (tag == null) {
      return [const Text('no tag info retrieved')];
    }
    final tagMap = _tagToMap(tag);
    if (tagMap.isEmpty) {
      return [const Text('no tag info retrieved')];
    }
    final widgets = <Widget>[];
    for (final key in tagMap.keys) {
      widgets.add(Text('$key: ${tagMap[key]}'));
    }

    return widgets;
  }

  Map<String, String?> _tagToMap(Tag tag) {
    final tagMap = {
      'title': tag.title,
      'trackArtist': tag.trackArtist,
      'album': tag.album,
      'albumArtist': tag.albumArtist,
      'year': tag.year == null ? '' : tag.year.toString(),
      'genre': tag.genre,
      'trackNumber': tag.trackNumber == null ? '' : tag.trackNumber.toString(),
      'trackTotal': tag.trackTotal == null ? '' : tag.trackTotal.toString(),
      'discNumber': tag.discNumber == null ? '' : tag.discNumber.toString(),
      'discTotal': tag.discTotal == null ? '' : tag.discTotal.toString(),
      'duration': tag.duration == null
          ? ''
          : Duration(seconds: tag.duration!).toBetterString(),
    };

    tagMap.removeWhere((key, value) => value == null || value.isEmpty);

    return tagMap;
  }
}
