extension DateTimeExt on DateTime {
  /// Returns the start of the day.
  DateTime get startOfDay => DateTime(year, month, day);

  /// Returns the end of the day.
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);
}
