import 'dart:io';

import 'package:assetPileViewer/common/version_info.dart';
import 'package:sqlite3/sqlite3.dart';

final currentSchemaVersion = VersionInfo(major: 0, minor: 2, patch: 0);
VersionInfo? foundSchemaVersion;
bool dbSchemaVersionUnsupported = false;

//creates, updates db schema
class AssetPileViewerDbSchema {
  final String dbFilePath;

  AssetPileViewerDbSchema(this.dbFilePath);

  List<String> _getAllTableNames(Database db) {
    final resultSet =
        db.select('select name from sqlite_schema where type = ?', ['table']);

    List<String> tableNames = [];

    for (var row in resultSet) {
      tableNames.add(row['name']);
    }

    return tableNames;
  }

  VersionInfo _getDbVersion(Database db, List<String> allTableNames) {
    if (!allTableNames.contains('db_version_history')) {
      return VersionInfo.empty();
    }
    final resultSet = db.select(
        'select version from db_version_history order by id desc limit 1');

    return VersionInfo.fromString(resultSet.firstOrNull?['version'] ?? '');
  }

  void _insertDbVersion(Database db, VersionInfo version) {
    final now = DateTime.now().toUtc().toIso8601String();
    db.execute(
        'insert into db_version_history (version, date_time) values (?, ?)',
        [version.toString(), now]);
  }

  void _ensureTables(Database db, List<String> allTableNames,
      Map<String, String> tableCreateStatements) {
    for (final tableName in tableCreateStatements.keys) {
      if (allTableNames.contains(tableName)) {
        continue;
      }
      db.execute(tableCreateStatements[tableName]!);
    }
  }

  void _ensureSchemaVersion0_1_0(Database db, List<String> allTableNames) {
    final schemaVersion = VersionInfo(major: 0, minor: 1, patch: 0);
    final currentDbVersion = _getDbVersion(db, allTableNames);
    if (currentDbVersion >= schemaVersion) {
      return;
    }
    _ensureTables(
      db,
      allTableNames,
      {
        'db_version_history': 'CREATE TABLE "db_version_history" ('
            '   "id"  INTEGER NOT NULL UNIQUE,'
            '   "version"   TEXT NOT NULL UNIQUE,'
            '   "date_time" TEXT NOT NULL,'
            '   PRIMARY KEY("id" AUTOINCREMENT)'
            ')',
        'keywords': 'CREATE TABLE "keywords" ('
            '   "id"  INTEGER NOT NULL UNIQUE,'
            '   "name"   TEXT NOT NULL UNIQUE,'
            '   PRIMARY KEY("id" AUTOINCREMENT)'
            ')',
        'directories': 'CREATE TABLE "directories" ('
            '   "id"  INTEGER NOT NULL UNIQUE,'
            '   "path"   TEXT NOT NULL UNIQUE,'
            '   "hidden" INTEGER NOT NULL DEFAULT 0,'
            '   PRIMARY KEY("id" AUTOINCREMENT)'
            ')',
        'directory_keywords': 'CREATE TABLE "directory_keywords" ('
            '   "directory_id" INTEGER NOT NULL,'
            '   "keyword_id"   INTEGER NOT NULL,'
            '   UNIQUE("directory_id","keyword_id"),'
            '   FOREIGN KEY("directory_id") REFERENCES "directories"("id"),'
            '   FOREIGN KEY("keyword_id") REFERENCES "keywords"("id")'
            ')',
        'files': 'CREATE TABLE "files" ('
            '   "id"  INTEGER NOT NULL UNIQUE,'
            '   "path"   TEXT NOT NULL UNIQUE,'
            '   "hidden" INTEGER NOT NULL DEFAULT 0,'
            '   PRIMARY KEY("id" AUTOINCREMENT)'
            ')',
        'file_keywords': 'CREATE TABLE "file_keywords" ('
            '   "file_id"   INTEGER NOT NULL,'
            '   "keyword_id"   INTEGER NOT NULL,'
            '   UNIQUE("file_id","keyword_id"),'
            '   FOREIGN KEY("file_id") REFERENCES "files"("id"),'
            '   FOREIGN KEY("keyword_id") REFERENCES "keywords"("id")'
            ')',
      },
    );

    _insertDbVersion(db, schemaVersion);
  }

  void _ensureSchemaVersion0_2_0(Database db, List<String> allTableNames) {
    final schemaVersion = VersionInfo(major: 0, minor: 2, patch: 0);
    final currentDbVersion = _getDbVersion(db, allTableNames);
    if (currentDbVersion >= schemaVersion) {
      return;
    }

    _ensureTables(
      db,
      allTableNames,
      {
        'lists': 'CREATE TABLE "lists" ( '
            '   "id"  INTEGER NOT NULL, '
            '   "name"   TEXT NOT NULL UNIQUE, '
            '   PRIMARY KEY("id" AUTOINCREMENT) '
            ')',
        'list_files': 'CREATE TABLE "list_files" ( '
            '   "id"  INTEGER NOT NULL, '
            '   "list_id"   INTEGER NOT NULL, '
            '   "file_id"   INTEGER NOT NULL, '
            '   UNIQUE("list_id","file_id"), '
            '   FOREIGN KEY("file_id") REFERENCES "files"("id") ON DELETE CASCADE, '
            '   FOREIGN KEY("list_id") REFERENCES "lists"("id") ON DELETE CASCADE, '
            '   PRIMARY KEY("id" AUTOINCREMENT) '
            ') ',
      },
    );

    _insertDbVersion(db, schemaVersion);
  }

  bool _isDbNewerVersion(VersionInfo dbSchemaVersion) {
    if (dbSchemaVersion > currentSchemaVersion) {
      foundSchemaVersion = dbSchemaVersion;
      dbSchemaVersionUnsupported = true;
      return true;
    }

    return false;
  }

  void _backupDbFile(VersionInfo dbSchemaVersion) {
    if (dbSchemaVersion.isEmpty() || dbSchemaVersion >= currentSchemaVersion) {
      return;
    }
    var dbFile = File(dbFilePath);
    dbFile.copySync('$dbFilePath.$dbSchemaVersion');
  }

  void update() {
    final db = sqlite3.open(dbFilePath);
    final allTableNames = _getAllTableNames(db);

    final dbSchemaVersion = _getDbVersion(db, allTableNames);

    if (_isDbNewerVersion(dbSchemaVersion)) {
      return;
    }

    _backupDbFile(dbSchemaVersion);

    _ensureSchemaVersion0_1_0(db, allTableNames);
    _ensureSchemaVersion0_2_0(db, allTableNames);
  }

  //recreates db file with schema. WARNING!  EXISTING DATA LOST!
  void reInit() {
    var f = File(dbFilePath);
    if (f.existsSync()) {
      f.deleteSync();
    }
    update();
  }
}
