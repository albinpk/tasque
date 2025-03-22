import '../../shared/common_export.dart';

// TODO(albin): getter to final

/// Global theme configurations.
abstract class AppTheme {
  static ThemeData get light =>
      _common(FlexThemeData.light(scheme: FlexScheme.mandyRed));

  static ThemeData get dark =>
      _common(FlexThemeData.dark(scheme: FlexScheme.mandyRed));

  static ThemeData _common(ThemeData theme) {
    final cs = theme.colorScheme;
    final inputBorderSide = BorderSide(color: cs.onSurface);
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: inputBorderSide,
    );
    const buttonPadding = EdgeInsets.all(15);
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    );
    return theme.copyWith(
      cardTheme: theme.cardTheme.copyWith(
        margin: EdgeInsets.zero,
        elevation: 0,
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          backgroundColor: cs.onSurface.fade(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: buttonPadding,
          shape: buttonShape,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: buttonPadding,
          shape: buttonShape,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cs.surface,
        // labelStyle: theme.textTheme.bodyMedium,
        floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
          final style = theme.textTheme.bodyMedium!;
          if (states.contains(WidgetState.error)) {
            return style.copyWith(color: cs.error);
          }
          return style;
        }),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: inputBorderSide.copyWith(width: 2),
        ),
        errorBorder: inputBorder.copyWith(
          borderSide: inputBorderSide.copyWith(color: cs.error, width: 2),
        ),
        focusedErrorBorder: inputBorder.copyWith(
          borderSide: inputBorderSide.copyWith(color: cs.error, width: 2),
        ),
      ),
    );
  }
}
