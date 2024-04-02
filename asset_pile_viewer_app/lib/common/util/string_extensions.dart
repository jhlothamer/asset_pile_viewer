import 'package:assetPileViewer/common/supported_file_formats.dart';
import 'package:assetPileViewer/common/util/path.dart';

enum FileType { unknown, sound, texture, model }

extension StringExtensions on String {
  String extension() {
    final index = lastIndexOf('.');
    if (index < 0) {
      return '';
    }
    return substring(index + 1).toLowerCase();
  }

  String fileName() {
    final index = lastIndexOf(pathSeparator);
    if (index < 0) {
      return '';
    }
    return substring(index + 1);
  }

  String justPath() {
    final index = lastIndexOf(pathSeparator);
    if (index < 0) {
      return '';
    }
    return substring(0, index);
  }

  String lastDirectoryName() {
    return fileName();
  }

  bool isSoundFile() {
    final ext = extension();

    return ext.isNotEmpty && supportedAudioExtensions.contains(ext);
  }

  FileType getFileType() {
    final ext = extension();
    if (ext.isEmpty) {
      return FileType.unknown;
    }
    if (supportedAudioExtensions.contains(ext)) {
      return FileType.sound;
    }
    if (supportedImageExtensions.contains(ext)) {
      return FileType.texture;
    }

    return FileType.unknown;
  }
}
