class EmailValidatorService {
  static bool isEmailValid(String email) {
    // Simple email regex pattern
    final RegExp emailRegex = RegExp(
      r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
    );

    return emailRegex.hasMatch(email);
  }
}
