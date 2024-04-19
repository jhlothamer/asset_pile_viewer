import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_list_file.freezed.dart';

@freezed
class AssetListFile with _$AssetListFile {
  const factory AssetListFile(
      {required int id,
      required int listId,
      required String path}) = _AssetListFile;
  factory AssetListFile.newAssetListFile(
          {required int listId, required String path}) =>
      AssetListFile(id: 0, listId: listId, path: path);
}
