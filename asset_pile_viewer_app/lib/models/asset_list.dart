import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_list.freezed.dart';

@freezed
class AssetList with _$AssetList {
  const factory AssetList(
      {required int id,
      required String name,
      required int fileCount}) = _AssetList;

  factory AssetList.newAssetList({required String name}) =>
      AssetList(id: 0, name: name, fileCount: 0);
}
