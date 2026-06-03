// ============================================================
//  WHAT GOES HERE
//  Pure functions that validate form inputs.
//  Return null on success, an error string on failure.
//  No Flutter, no GetX — plain Dart.
//  Wire directly into TextFormField.validator.
// ============================================================

class InputValidators {
  InputValidators._();

  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(value) ? null : 'Enter a valid email';
  }

  static String? password(String? value) {
    if (value == null || value.length < 8) return 'Min 8 characters';
    return null;
  }

  static String? required(String? value) =>
      (value == null || value.isEmpty) ? 'This field is required' : null;
}
