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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text('Audio Tags:'),
              ],
            ),
            const SizedBox(
              height: 8.0,
            ),
            ..._tagToWidgets(tag),
          ],
        );
      },
      error: (e, __) {
        return Text('Error getting tags: ${e.toString()}');
      },
      loading: () => Container(),
    );
  }

  List<Widget> _tagToWidgets(Tag? tag) {
    if (tag == null) {
      return [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'no tag info retrieved',
            ),
          ],
        )
      ];
    }
    final tagMap = _tagToMap(tag);
    if (tagMap.isEmpty) {
      return [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'no tag info retrieved',
            ),
          ],
        )
      ];
    }

    final altWidgets = <Widget>[
      Table(
        columnWidths: const {0: IntrinsicColumnWidth()},
        children: [
          ...tagMap.entries.map(
            (e) => TableRow(
              children: [
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      '${e.key}:',
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      e.value.toString(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    ];

    return altWidgets;
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
      'duration': tag.duration == null || tag.duration == 0
          ? ''
          : Duration(seconds: tag.duration!).toBetterString(),
    };

    tagMap.removeWhere((key, value) => value == null || value.isEmpty);

    return tagMap;
  }
}
