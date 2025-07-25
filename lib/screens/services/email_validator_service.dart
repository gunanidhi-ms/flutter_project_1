import '/db_helper.dart';

bool isEmailValid(String? email) {
  if (email == null || email.trim().isEmpty) return false;

  email = email.trim();

  // Improved regex that requires at least one dot in domain and valid TLD
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@' // local part
    r'(?:[a-zA-Z0-9-]+\.)+' // domain name(s)
    r'[a-zA-Z]{2,}$', // TLD (e.g. com, org, in)
  );

  return emailRegex.hasMatch(email);
}

Future<void> validateEmail(
  String email,
  bool isLogin, // true for login, false for signup
  void Function(String? error) onErrorUpdate,
) async {
  if (!isEmailValid(email)) {
    onErrorUpdate('Please enter a valid email address');
    return;
  } else {
    bool exists = await DBHelper().userExists(email);

    if (isLogin) {
      if (!exists) {
        onErrorUpdate('Email not registered');
      } else {
        onErrorUpdate(null); // valid
      }
    } else {
      // Signup: return error if email already exists
      if (exists) {
        onErrorUpdate('Email already registered');
      } else {
        onErrorUpdate(null); // valid
      }
    }
  }
}
