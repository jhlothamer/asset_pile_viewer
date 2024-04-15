import 'dart:io';

import 'package:assetPileViewer/common/util/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

Image getImage(BuildContext context, String filePath) {
  final isSvg = filePath.extension().toLowerCase() == 'svg';

  if (isSvg) {
    return Image(
      width: 512,
      height: 512,
      image: Svg(
        filePath,
        source: SvgSource.file,
      ),
    );
  }

  return Image.file(
    File(filePath),
    fit: BoxFit.contain,
    filterQuality: FilterQuality.none,
    cacheWidth: 256,
  );
}
