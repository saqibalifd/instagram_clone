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

  // 👇 Add this
  static String? phone(String? value) {
    if (value == null || value.isEmpty) return 'Phone number is required';
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length < 7) return 'Enter a valid phone number';
    if (digitsOnly.length > 15) return 'Phone number is too long';
    return null;
  }
}
