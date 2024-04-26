import 'package:assetPileViewer/data/db_batched_execute.dart';
import 'package:assetPileViewer/data/db_batched_execute_in.dart';
import 'package:assetPileViewer/models/models.dart';
import 'package:sqlite3/sqlite3.dart';

class AssetPileViewerRepository {
  final String dbfilePath;
  late Database _db;
  AssetPileViewerRepository(this.dbfilePath) {
    _db = sqlite3.open(dbfilePath);
  }

  List<Keyword> _stringToKeywords(String delimKeywords) {
    if (delimKeywords.isEmpty) {
      return [];
    }
    final keywords = <Keyword>[];

    for (final idNameString in delimKeywords.split(',')) {
      final idName = idNameString.split('%');
      keywords.add(Keyword(id: int.parse(idName[0]), name: idName[1]));
    }

    return keywords;
  }

  List<AssetList> _stringToAssetLists(String delimLists) {
    if (delimLists.isEmpty) {
      return [];
    }
    final lists = <AssetList>[];

    for (final idNameString in delimLists.split(',')) {
      final idName = idNameString.split('%');
      lists.add(
          AssetList(id: int.parse(idName[0]), name: idName[1], fileCount: 0));
    }

    return lists;
  }

  List<Keyword> getKeywords() {
    var resultSet = _db.select('select id, name from keywords');

    final keywords = <Keyword>[];

    for (final row in resultSet) {
      keywords.add(Keyword(id: row['id'], name: row['name']));
    }

    return keywords;
  }

  Keyword _insertKeyword(Keyword keyword) {
    _db.execute('insert into keywords (name) values(?)', [keyword.name]);
    return keyword.copyWith(id: _db.lastInsertRowId);
  }

  void _updateKeyword(Keyword keyword) {
    _db.execute('update keywords set name = ? where id = ?',
        [keyword.name, keyword.id]);
  }

  Keyword? getKeyword(String keyword) {
    final resultSet =
        _db.select('select id, name from keywords where name = ?', [keyword]);
    final row = resultSet.firstOrNull;
    if (row == null) {
      return null;
    }
    return Keyword(id: row['id'], name: row['name']);
  }

  Keyword saveKeyword(Keyword keyword) {
    final isNew = keyword.id == 0;
    final existingKeyword = getKeyword(keyword.name);
    if (existingKeyword != null) {
      if (!isNew && existingKeyword.id != keyword.id) {
        //move uses of keyword to existing keyword
        _db.execute(
            'update directory_keywords set keyword_id = ? where keyword_id = ? ',
            [existingKeyword.id, keyword.id]);
        _db.execute(
            'update file_keywords set keyword_id = ? where keyword_id = ? ',
            [existingKeyword.id, keyword.id]);
        //delete keyword - it's no longer used
        _db.execute('delete from keywords where id = ?', [keyword.id]);
      }
      return existingKeyword;
    }

    if (isNew) {
      return _insertKeyword(keyword);
    }

    _updateKeyword(keyword);
    return keyword;
  }

  bool purgeUnusedKeywords() {
    _db.execute('delete from keywords '
        'WHERE  '
        'id in ( '
        '   select k.id from keywords k  '
        '   WHERE  '
        '   not exists (select * from directory_keywords dk where dk.keyword_id = k.id)  '
        '   AND  '
        '   not exists (select * from file_keywords fk where fk.keyword_id = k.id) '
        ')  ');

    return _db.updatedRows > 0;
  }

  List<AssetDirectory> getDirectories() {
    var resultSet = _db.select('select '
        'd.id, d.path, d.hidden, ( '
        '   select group_concat(k.id || \'%\' || k.name) from '
        '   directory_keywords dk inner join keywords k on k.id = dk.keyword_id '
        '   where dk.directory_id = d.id '
        ') delim_keywords '
        'from directories d');

    final directories = <AssetDirectory>[];

    for (final row in resultSet) {
      final keywords = _stringToKeywords(row['delim_keywords'] ?? '');
      directories.add(
        AssetDirectory(
            id: row['id'],
            path: row['path'],
            hidden: row['hidden'] == 1,
            keywords: keywords),
      );
    }

    return directories;
  }

  AssetDirectory saveDirectory(AssetDirectory assetDirectory) {
    _db.execute(
        'insert into directories (path, hidden) '
        'values(?, ?) '
        'on conflict(path) do UPDATE '
        'set hidden = ? '
        'where path = ? ',
        [
          assetDirectory.path,
          assetDirectory.hidden,
          assetDirectory.hidden,
          assetDirectory.path
        ]);

    final id = assetDirectory.id != 0 ? assetDirectory.id : _db.lastInsertRowId;

    _db.execute('delete from directory_keywords where directory_id = ?', [id]);

    final keywordNames = assetDirectory.keywords.map((e) => e.name).toList();
    final batch = DbBatchedExecuteIn(
        _db,
        'insert into directory_keywords '
        '(directory_id, keyword_id) '
        'select $id, id from keywords where '
        'name in');

    batch.doBatch(keywordNames);

    return assetDirectory.copyWith(id: id);
  }

  List<AssetFile> getAssetFiles() {
    var resultSet = _db.select('select '
        'f.id, f.path, f.hidden, ( '
        '   select group_concat(k.id || \'%\' || k.name) from '
        '   file_keywords fk inner join keywords k on k.id = fk.keyword_id '
        '   where fk.file_id = f.id '
        ') delim_keywords, '
        ' ( select group_concat(l.id || \'%\' || l.name) from '
        '   list_files lf inner join lists l on l.id = lf.list_id '
        '   where lf.file_id = f.id '
        ') delim_lists '
        'from files f');

    final files = <AssetFile>[];

    for (final row in resultSet) {
      final keywords = _stringToKeywords(row['delim_keywords'] ?? '');
      final lists = _stringToAssetLists(row['delim_lists'] ?? '');
      files.add(
        AssetFile(
          id: row['id'],
          path: row['path'],
          hidden: row['hidden'] == 1,
          keywords: keywords,
          lists: lists,
        ),
      );
    }

    return files;
  }

  AssetFile saveFile(AssetFile assetFile) {
    _db.execute(
        'insert into files (path, hidden) '
        'values(?, ?) '
        'on conflict(path) do UPDATE '
        'set hidden = ? '
        'where path = ? ',
        [assetFile.path, assetFile.hidden, assetFile.hidden, assetFile.path]);

    final id = assetFile.id != 0 ? assetFile.id : _db.lastInsertRowId;

    _db.execute('delete from file_keywords where file_id = ?', [id]);

    final keywordNames = assetFile.keywords.map((e) => e.name).toList();
    final keywordInsertBatch = DbBatchedExecuteIn(
        _db,
        'insert into file_keywords '
        '(file_id, keyword_id) '
        'select $id, id from keywords where '
        'name in');

    keywordInsertBatch.doBatch(keywordNames);

    _db.execute('delete from list_files where file_id = ?', [id]);

    final listFilesInsertBatch =
        DbBatchedExecute(_db, 'insert into list_files (list_id, file_id)',
            sqlParameterFromObject: (AssetList list, _) {
      return [list.id, id];
    });

    listFilesInsertBatch.doBatch(assetFile.lists);

    return assetFile.copyWith(id: id);
  }

  List<AssetList> getAssetLists() {
    var resultSet = _db.select(
        'select id, name, (select count(*) from list_files lf where lf.list_id = l.id) file_count from lists l order by name');

    final lists = <AssetList>[];

    for (final row in resultSet) {
      lists.add(
        AssetList(
          id: row['id'],
          name: row['name'],
          fileCount: row['file_count'],
        ),
      );
    }

    return lists;
  }

  List<AssetListFile> getAssetListFiles(int listId) {
    var resultSet = _db.select(
        'select id, list_id, file_id, f.path from list_files lf '
        'inner join files f on f.id = lf.file_id '
        'where list_id = ? order by path',
        [listId]);

    final lists = <AssetListFile>[];

    for (final row in resultSet) {
      lists.add(
        AssetListFile(
            id: row['id'],
            listId: row['list_id'],
            fileId: row['file_id'],
            path: row['path']),
      );
    }

    return lists;
  }

  AssetList saveAssetList(AssetList list) {
    if (list.id != 0) {
      _db.execute(
          'update lists set name = ? where id = ?', [list.name, list.id]);
      return list;
    }
    _db.execute(
        'insert into lists (name) '
        'values(?) ',
        [
          list.name,
        ]);

    return list.copyWith(id: _db.lastInsertRowId);
  }

  void deleteAssetList(AssetList list) {
    _db.execute('delete from lists where id = ?', [list.id]);
  }

  AssetListFile saveAssetListFile(AssetListFile listFile) {
    if (listFile.id != 0) {
      _db.execute('update list_files set list_id = ? where id = ?',
          [listFile.listId, listFile.id]);
      return listFile;
    }
    _db.execute(
        'insert into list_files (list_id, file_id) '
        'values(?) ',
        [
          listFile.listId,
          listFile.fileId,
        ]);

    return listFile.copyWith(id: _db.lastInsertRowId);
  }

  void deleteAssetListFile(AssetListFile file) {
    _db.execute('delete from list_files where id = ?', [file.id]);
  }

  bool moveAssetListFiles(int sourceListId, int destinationListId) {
    _db.execute('update list_files set list_id = ? where list_id = ?',
        [destinationListId, sourceListId]);
    return _db.updatedRows > 0;
  }
}
