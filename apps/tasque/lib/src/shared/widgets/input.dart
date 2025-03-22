import '../common_export.dart';

/// Text input field with a shadow.
class Input extends StatelessWidget {
  const Input({
    required this.label,
    super.key,
    this.controller,
    this.maxLines = 1,
    this.onTap,
    this.readOnly = false,
    this.validator,
    this.textInputAction,
  });

  final TextEditingController? controller;
  final String label;
  final int? maxLines;
  final VoidCallback? onTap;
  final bool readOnly;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return SolidShadow(
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          alignLabelWithHint: true,
          errorStyle: const TextStyle(height: 0.01),
        ),
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
        validator: validator,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: textInputAction,
      ),
    );
  }
}
