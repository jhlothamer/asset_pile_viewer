import 'package:assetPileViewer/common/util/path.dart';
import 'package:path_provider/path_provider.dart';

const _dbFileName = 'assetPileViewer.db';

late final String dbFilepath;

Future<void> initDbFilePath() async {
  final appSupportPath = await getApplicationSupportDirectory();

  dbFilepath = '${appSupportPath.path}$pathSeparator$_dbFileName';
}
