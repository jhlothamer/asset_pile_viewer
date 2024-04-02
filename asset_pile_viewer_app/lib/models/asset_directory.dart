import 'package:assetPileViewer/models/keyword.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_directory.freezed.dart';

@freezed
class AssetDirectory with _$AssetDirectory {
  const factory AssetDirectory({
    required int id,
    required String path,
    required bool hidden,
    @Default([]) List<Keyword> keywords,
  }) = _AssetDirectory;

  factory AssetDirectory.newDirectory(String path,
          [bool hidden = false, List<Keyword>? keywords]) =>
      AssetDirectory(
          id: 0, path: path, hidden: hidden, keywords: keywords ?? []);
}
