import 'package:assetPileViewer/features/folder_view/providers/asset_files_provider.dart';
import 'package:assetPileViewer/models/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'asset_file_provider.g.dart';

@riverpod
AssetFile assetFile(AssetFileRef ref, String path) {
  final assetFiles = ref.watch(assetFilesProvider);
  return assetFiles[path] ?? AssetFile.newFile(path);
}
