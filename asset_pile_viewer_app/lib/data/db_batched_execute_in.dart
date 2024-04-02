import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sqlite3/sqlite3.dart';

/// Batched execute for statements of form  [insert,update,delete] ... where ... in (values)
class DbBatchedExecuteIn {
  final Database _db;
  final String _baseSql;
  final Map<int, PreparedStatement> _prepStatementCache = {};

  /// Returns list of sql parameter values.  Flag of true indicates call is to get parameter count only.
  final bool debug;
  int chunkSize;
  DbBatchedExecuteIn(this._db, this._baseSql,
      {this.chunkSize = 100, this.debug = false});

  String _getParameterString(int paramCount) {
    var paramString = ' (';
    for (int i = 0; i < paramCount; i++) {
      if (i > 0) {
        paramString += ', ';
      }
      paramString += '?';
    }
    paramString += ')';
    return paramString;
  }

  PreparedStatement _getPreppedStatement(int objectCount, int paramCount) {
    if (_prepStatementCache.containsKey(objectCount)) {
      return _prepStatementCache[objectCount]!;
    }
    var sql = _baseSql.trim();

    if (!sql.endsWith('in')) {
      sql += ' in';
    }
    var paramString = _getParameterString(paramCount);
    sql += paramString;

    var preppedStatement = _db.prepare(sql);
    _prepStatementCache[objectCount] = preppedStatement;
    return preppedStatement;
  }

  void _doStatement(List objects, List<dynamic> parameterObjects) {
    if (objects.isEmpty) {
      return;
    }
    final preparedStatement =
        _getPreppedStatement(objects.length, parameterObjects.length);
    preparedStatement.execute(parameterObjects);
  }

  void doBatch(List objects) {
    if (objects.isEmpty) {
      return;
    }
    if (debug) debugPrint('DbBatchedExecuteSelect: start for $_baseSql');
    final processObjects = [];
    try {
      for (int i = 0; i < objects.length; i += chunkSize) {
        final chunkEnd = min(i + chunkSize, objects.length);
        final chunk = objects.getRange(i, chunkEnd);
        processObjects.addAll(chunk);
        if (debug) {
          debugPrint(
              'DbBatchedExecuteSelect: chuck range: $i -> $chunkEnd, chunk size: ${chunk.length}');
          debugPrint('\t${chunk.toList()}');
        }
        _doStatement(chunk.toList(), processObjects);
      }
      if (processObjects.length != objects.length) {
        debugPrint(
            'DbBatchedExecuteSelect: DID NOT PROCESS ALL OBJECTS!! obj count: ${objects.length}, ${processObjects.length} ');
      }
    } catch (e) {
      if (debug) {
        debugPrint('DbBatchedExecuteSelect: error ');
        debugPrint(e.toString());
        debugPrint('=====================\nobjects:\n${objects.join('\n')}');
      }
      rethrow;
    }

    if (debug) debugPrint('DbBatchedExecuteSelect: finish');
  }
}
