import 'dart:io';

import 'package:sqlite3/sqlite3.dart';

class VersionInfo {
  final int major;
  final int minor;
  final int patch;

  VersionInfo({required this.major, required this.minor, required this.patch});

  factory VersionInfo.fromString(String versionString) {
    final versionParts = versionString.split('.');
    return VersionInfo(
        major: int.parse(versionParts[0]),
        minor: int.parse(versionParts[1]),
        patch: int.parse(versionParts[2]));
  }

  @override
  String toString() => '$major.$minor.$patch';

  //@override
  bool operator >(VersionInfo other) {
    final result = major > other.major
        ? true
        : minor > other.minor
            ? true
            : patch > other.patch
                ? true
                : false;
    return result;
  }
}

final currentSchemaVersion = VersionInfo(major: 0, minor: 1, patch: 0);
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

  String _getDbVersion(Database db) {
    final resultSet = db.select(
        'select version from db_version_history order by id desc limit 1');

    return resultSet.firstOrNull?['version'] ?? '';
  }

  void _insertDbVersion(Database db, String version) {
    final now = DateTime.now().toUtc().toIso8601String();
    db.execute(
        'insert into db_version_history (version, date_time) values (?, ?)',
        [version, now]);
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
    final currentDbVersion =
        allTableNames.contains('db_version_history') ? _getDbVersion(db) : '';
    if (currentDbVersion == '0.1.0') {
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

    _insertDbVersion(db, '0.1.0');
  }

  bool _isDbNewerVersion(Database db, List<String> allTableNames) {
    if (!allTableNames.contains('db_version_history')) {
      return false;
    }

    final results = db.select('select version from db_version_history');
    for (final row in results) {
      final version = VersionInfo.fromString(row['version']);
      if (version > currentSchemaVersion) {
        // throw 'Database version greater than expected: db version: $version, expected: $currentSchemaVersion';
        foundSchemaVersion = version;
        dbSchemaVersionUnsupported = true;
        return true;
      }
    }

    return false;
  }

  void update() {
    final db = sqlite3.open(dbFilePath);
    final allTableNames = _getAllTableNames(db);

    if (_isDbNewerVersion(db, allTableNames)) {
      return;
    }

    _ensureSchemaVersion0_1_0(db, allTableNames);
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
