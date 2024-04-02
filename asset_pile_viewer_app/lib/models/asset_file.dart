import 'package:assetPileViewer/models/keyword.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_file.freezed.dart';

@freezed
class AssetFile with _$AssetFile {
  const factory AssetFile({
    required int id,
    required String path,
    required bool hidden,
    @Default([]) List<Keyword> keywords,
  }) = _AssetFile;

  factory AssetFile.newFile(String path,
          [bool hidden = false, List<Keyword>? keywords]) =>
      AssetFile(id: 0, path: path, hidden: hidden, keywords: keywords ?? []);
}
