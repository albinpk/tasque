import '../common_export.dart';

extension TextStyleExt on TextStyle {
  /// Sets the font weight to bold.
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);

  /// Sets the text color to fade. Defaults to 60% opacity.
  TextStyle fade([double alpha = 0.6]) =>
      copyWith(color: color?.withValues(alpha: alpha));
}

extension ColorExt on Color {
  /// Sets the color to fade. Defaults to 50% opacity.
  Color fade([double alpha = 0.5]) => withValues(alpha: alpha);
}
