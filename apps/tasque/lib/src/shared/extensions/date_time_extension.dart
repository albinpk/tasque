import '../common_export.dart';

extension DateTimeExt on DateTime {
  /// Returns the start of the day.
  DateTime get startOfDay => DateTime(year, month, day);

  /// Returns the end of the day.
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);

  /// Formats the date. Defaults to `dd MMM yyyy`.
  String format([String format = 'dd MMM yyyy']) =>
      DateFormat(format).format(this);

  /// Returns the number of days left as a string.
  String daysLeft() => '${difference(DateTime.now()).inDays + 1} days left';

  /// Checks if the date is the same day as [other].
  bool isSameDay(DateTime other) => DateUtils.isSameDay(this, other);

  /// Checks if the date is today.
  bool get isToday => isSameDay(DateTime.now());
}
