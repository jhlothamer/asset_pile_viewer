import 'package:flutter/material.dart';

extension StopwatchExtensions on Stopwatch {
  Future<T> timeThis<T>(Future<T> Function() func,
      [String Function(Duration, T?)? debugStringCreator]) async {
    reset();
    start();
    T? results;
    try {
      results = await func();
      return results!;
    } finally {
      stop();
      if (debugStringCreator != null) {
        debugPrint(debugStringCreator(elapsed, results));
      }
    }
  }

  T timeThisSync<T>(T Function() func,
      [String Function(Duration, T?)? debugStringCreator]) {
    reset();
    start();
    T? results;
    try {
      results = func();
      return results!;
    } finally {
      stop();
      if (debugStringCreator != null) {
        debugPrint(debugStringCreator(elapsed, results));
      }
    }
  }
}
