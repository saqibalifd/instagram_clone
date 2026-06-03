import 'package:flutter/material.dart';
import 'package:instagram/core/theme/app_theme.dart';

class AuthTextfieldWidget extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? textInputType;
  final bool? obSecure;
  final Widget? suffix;
  final FocusNode? focusNode;
  final int? maxLines;
  final bool? readOnly;
  final void Function(String)? onChanged;
  const AuthTextfieldWidget({
    super.key,
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
      maxLines: maxLines ?? 1,
      validator: validator,
      controller: controller,
      keyboardType: textInputType,
      obscureText: obSecure ?? false,
      focusNode: focusNode,
      readOnly: readOnly ?? false,
      onChanged: onChanged,
      decoration: InputDecoration(hintText: hintText, suffixIcon: suffix),
    );
  }
}
