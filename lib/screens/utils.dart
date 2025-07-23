import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project_1/screens/services/email_validator_service.dart';

Widget buildText(
  String text, {
  double fontSize = 32,
  bool isBold = true,
}) {
  return Text(
    text,
    style: TextStyle(
      fontSize: fontSize,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      color: const Color.fromARGB(255, 4, 22, 58),
    ),
  );
}

InputDecoration buildInputDecoration(
  String label, {
  Widget? suffixIcon,
  String? errorText,
  Widget? prefixIcon,
}) {
  return InputDecoration(
    hintText: label,
    filled: true,
    fillColor: Colors.white70,
    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    errorText: errorText,
  );
}

Widget buildCustomTextField(
  TextEditingController controller,
  Key? key,
  String label, {
  String? errorText,
  bool obscureText = false, 
  Widget? prefixIcon,
  IconData? suffixIconData,
  VoidCallback? onPressed,
  TextInputType? keyboardType,
  List<TextInputFormatter>? inputFormatters,
  void Function(String)? onChanged,
}) {
  return TextField(
    controller: controller,
    key: key,
    obscureText: obscureText, 
    decoration: buildInputDecoration(
      label,
      errorText: errorText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIconData != null
          ? IconButton(
              icon: Icon(suffixIconData),
              onPressed: onPressed,
            )
          : null,
    ),
    keyboardType: keyboardType,
    inputFormatters: inputFormatters,
    onChanged: onChanged,
  );
}

Widget buildCustomDropdown(
  Key? key,
  String? value,
  List<DropdownMenuItem<String>> items,
  String hintText,
   void Function(String?) onChanged,
  {bool isExpanded = true,
  bool hideUnderline = false,
  bool useFormField = true,
  String? errorText,
}) {
  final dropdown = DropdownButton<String>(
    key: key,
    value: value,
    items: items,
    hint: Text(hintText),
    isExpanded: isExpanded,
    onChanged: onChanged,
  );

  if (!useFormField) {
    return hideUnderline
        ? DropdownButtonHideUnderline(child: dropdown)
        : dropdown;
  }

  return DropdownButtonFormField<String>(
    key: key,
    value: value,
    items: items,
    decoration: buildInputDecoration(hintText, errorText: errorText),
    isExpanded: isExpanded,
    onChanged: onChanged,
  );
}


// utils.dart
bool getEmailValidationError(String email) {
  return !EmailValidatorService.isEmailValid(email);
}


