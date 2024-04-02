extension DurationExtensions on Duration {
  /// like toString() but skips all 0 parts
  String toBetterString() {
    var microseconds = inMicroseconds;
    var sign = '';
    var negative = microseconds < 0;

    var hours = microseconds ~/ Duration.microsecondsPerHour;
    microseconds = microseconds.remainder(Duration.microsecondsPerHour);

    // Correcting for being negative after first division, instead of before,
    // to avoid negating min-int, -(2^31-1), of a native int64.
    if (negative) {
      hours = 0 - hours; // Not using `-hours` to avoid creating -0.0 on web.
      microseconds = 0 - microseconds;
      sign = '-';
    }

    var minutes = microseconds ~/ Duration.microsecondsPerMinute;
    microseconds = microseconds.remainder(Duration.microsecondsPerMinute);

    var minutesPadding = minutes < 10 ? '0' : '';

    var seconds = microseconds ~/ Duration.microsecondsPerSecond;
    microseconds = microseconds.remainder(Duration.microsecondsPerSecond);

    var secondsPadding = seconds < 10 ? '0' : '';

    // Padding up to six digits for microseconds.
    var microsecondsText = microseconds.toString().padLeft(6, '0');

    String units = '';
    String s = '';
    if (hours != 0) {
      s += '$sign$hours:';
      units += 'hh:';
    }
    if (hours != 0 || minutes != 0) {
      s += '$minutesPadding$minutes:';
      units += 'mm:';
    }
    if (hours != 0 || minutes != 0 || seconds != 0) {
      units += s.isEmpty ? 'sec' : 'ss';
      s += '$secondsPadding$seconds';
    }

    if (microseconds != 0) {
      s += '.$microsecondsText';
    }

    return '$s $units';
  }
}
