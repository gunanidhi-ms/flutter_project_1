class PasswordRequirementsService {
  static const Map<String, String> _labels = {
    'minLength': 'At least 8 characters',
    'hasUppercase': 'One uppercase letter',
    'hasLowercase': 'One lowercase letter',
    'hasDigit': 'One digit',
    'hasSpecialChar': 'One special character',
  };

  static Map<String, bool> checkRequirements(String password) {
    return {
      'minLength': password.length >= 8,
      'hasUppercase': password.contains(RegExp(r'[A-Z]')),
      'hasLowercase': password.contains(RegExp(r'[a-z]')),
      'hasDigit': password.contains(RegExp(r'[0-9]')),
      'hasSpecialChar': password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]')),
    };
  }

  static List<String> getFailedRequirements(String password) {
    final reqs = checkRequirements(password);
    return reqs.entries
        .where((e) => !e.value)
        .map((e) => _labels[e.key] ?? e.key)
        .toList();
  }
}