extension StringExt on String {
  /// Returns null if the string is empty.
  String? get nullIfEmpty => isEmpty ? null : this;
}
