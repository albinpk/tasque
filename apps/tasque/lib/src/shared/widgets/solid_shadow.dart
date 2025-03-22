import '../common_export.dart';

/// A widget that adds a shadow to its child.
///
/// This is a common design used in this app to
/// give a shadow to cards, input, and other widgets.
class SolidShadow extends StatelessWidget {
  const SolidShadow({
    required this.child,
    this.borderRadius = 15.0,
    this.offsetY = 13.0,
    this.enabled = true,
    super.key,
  });

  /// The child widget that will be wrapped with a shadow.
  final Widget child;

  /// Whether the shadow should be enabled.
  final bool enabled;

  /// The border radius of the box shadow. Defaults to `15.0`.
  final double borderRadius;

  /// The y-offset of the box shadow. Defaults to `13.0`.
  final double offsetY;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            offset: Offset(5, offsetY),
            spreadRadius: -10, // negative value will make the shadow depth
          ),
        ],
      ),
      child: child,
    );
  }
}
