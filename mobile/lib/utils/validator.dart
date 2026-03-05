class Validators {
  static String? name(String? v) {
    if (v == null || v.trim().isEmpty) return 'Name is required';
    if (v.trim().length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(v.trim())) return 'Enter a valid email';
    return null;
  }

  static String? password(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? confirmPassword(String? v, String password) {
    if (v == null || v.isEmpty) return 'Please confirm your password';
    if (v != password) return 'Passwords do not match';
    return null;
  }

  static String? title(String? v) {
    if (v == null || v.trim().isEmpty) return 'Title is required';
    if (v.trim().length < 3) return 'Title must be at least 3 characters';
    return null;
  }
}