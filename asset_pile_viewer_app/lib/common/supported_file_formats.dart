import 'dart:io';

const _supportedImageExtensions = [
  'bmp',
  'jpeg',
  'jpg',
  'png',
  'svg',
  'webp',
];

const _supportedAudioExtensions = [
  'aif',
  'flac',
  'mp3',
  'ogg',
  'wav',
];

List<String> _supportedAudioExtensionsForPlatform(List<String> extensions) {
  if(Platform.isWindows){
    return extensions.where((ext) => ext != 'ogg').toList();
  }
  return extensions;
}

const _supportedExtensions = [
  '',
  ..._supportedImageExtensions,
  ..._supportedAudioExtensions,
  '',
];

final supportedImageExtensions = _supportedImageExtensions.join(',');
final supportedAudioExtensions = _supportedAudioExtensionsForPlatform(_supportedAudioExtensions).join(',');
final supportedExtensions = _supportedExtensions.join(',');

