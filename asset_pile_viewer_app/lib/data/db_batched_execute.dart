import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sqlite3/sqlite3.dart';

/// Batched execute for insert statement statements
class DbBatchedExecute<T> {
  final Database _db;
  final String _baseSql;
  final Map<int, PreparedStatement> _prepStatementCache = {};

  /// Returns list of sql parameter values.  Flag of true indicates call is to get parameter count only.
  final List<dynamic> Function(T, bool) sqlParameterFromObject;
  final bool debug;
  int chunkSize;
  DbBatchedExecute(this._db, this._baseSql,
      {required this.sqlParameterFromObject,
      this.chunkSize = 100,
      this.debug = false});

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

    if (!sql.endsWith('values')) {
      sql += ' values';
    }
    var paramString = _getParameterString(paramCount);

    for (int i = 0; i < objectCount; i++) {
      if (i > 0) {
        sql += ',';
      }
      sql += paramString;
    }
    var preppedStatement = _db.prepare(sql);
    _prepStatementCache[objectCount] = preppedStatement;
    return preppedStatement;
  }

  void _doStatement(List objects, int paramCount) {
    if (objects.isEmpty) {
      return;
    }
    final preparedStatement = _getPreppedStatement(objects.length, paramCount);
    List parameterValues = [];
    for (final object in objects) {
      parameterValues.addAll(
        sqlParameterFromObject(object, false),
      );
    }
    preparedStatement.execute(parameterValues);
  }

  void doBatch(List objects) {
    if (objects.isEmpty) {
      return;
    }
    if (debug) debugPrint('DbBatchedExecute: start for $_baseSql');
    final paramCount = sqlParameterFromObject(objects.first, true).length;
    final processObjects = [];
    try {
      for (int i = 0; i < objects.length; i += chunkSize) {
        final chunkEnd = min(i + chunkSize, objects.length);
        final chunk = objects.getRange(i, chunkEnd);
        processObjects.addAll(chunk);
        if (debug) {
          debugPrint(
              'DbBatchedExecute: chuck range: $i -> $chunkEnd, chunk size: ${chunk.length}');
          debugPrint('\t${chunk.toList()}');
        }
        _doStatement(chunk.toList(), paramCount);
      }
      if (processObjects.length != objects.length) {
        debugPrint(
            'DbBatchedExecute: DID NOT PROCESS ALL OBJECTS!! obj count: ${objects.length}, ${processObjects.length} ');
      }
    } catch (e) {
      if (debug) {
        debugPrint('DbBatchedExecute: error ');
        debugPrint(e.toString());
        debugPrint('=====================\nobjects:\n${objects.join('\n')}');
      }
      rethrow;
    }

    if (debug) debugPrint('DbBatchedExecute: finish');
  }
}
