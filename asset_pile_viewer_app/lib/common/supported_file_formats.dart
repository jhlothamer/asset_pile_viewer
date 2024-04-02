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

const _supportedExtensions = [
  '',
  ..._supportedImageExtensions,
  ..._supportedAudioExtensions,
  '',
];

final supportedImageExtensions = _supportedImageExtensions.join(',');
final supportedAudioExtensions = _supportedAudioExtensions.join(',');
final supportedExtensions = _supportedExtensions.join(',');
