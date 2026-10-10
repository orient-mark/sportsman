/// Display-only formatting. Never use these strings for storage or transfer.
abstract final class DisplayDateTime {
  static String _two(int value) => value.toString().padLeft(2, '0');

  /// Uses local clock time, preserving the stored instant and its precision.
  static String dateTime(DateTime? value) {
    if (value == null) return 'Нет отметки';
    final local = value.toLocal();
    return '${_two(local.day)}.${_two(local.month)}.'
        '${local.year.toString().padLeft(4, '0')} ${time(local)}';
  }

  static String time(DateTime value) {
    final local = value.toLocal();
    return '${_two(local.hour)}:${_two(local.minute)}:${_two(local.second)}';
  }

  /// Hides fractional seconds without rounding. Hours do not wrap at 24.
  static String interval(Duration? value) {
    if (value == null) return '—';
    final seconds =
        value.inMicroseconds.abs() ~/ Duration.microsecondsPerSecond;
    return '${value.isNegative ? '-' : ''}${_two(seconds ~/ 3600)}:'
        '${_two(seconds ~/ 60 % 60)}:${_two(seconds % 60)}';
  }
}
