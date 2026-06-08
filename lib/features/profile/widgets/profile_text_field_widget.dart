import 'package:flutter/material.dart';
import 'package:instagram/core/theme/app_theme.dart';

class ProfileTextFieldWidget extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? textInputType;
  final bool? obSecure;
  final Widget? suffix;
  final FocusNode? focusNode;
  final int? maxLines;
  final bool? readOnly;
  final VoidCallback? onChanged;
  const ProfileTextFieldWidget({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.validator,
    this.textInputType,
    this.obSecure,
    this.suffix,
    this.focusNode,
    this.maxLines,
    this.readOnly,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TextFormField(
      cursorColor: cs.secondary,
      minLines: 1,
      maxLines: maxLines ?? 1,
      validator: validator,
      controller: controller,
      keyboardType: textInputType,
      obscureText: obSecure ?? false,
      focusNode: focusNode,
      readOnly: readOnly ?? false,
      onChanged: (value) => onChanged?.call(),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: IGColors.bgDark),

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: IGColors.gray.withValues(alpha: 0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),

        hintText: hintText,
        suffixIcon: suffix,
      ),
    );
  }
}
