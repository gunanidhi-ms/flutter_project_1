import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


Widget buildText(String text, {double fontSize =32, bool isBold = true}) {
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
  String label,
  String hint,{
  String? errorText,
  bool obscureText = false,
  Widget? prefixIcon,
  IconData? suffixIconData,
  VoidCallback? onPressed,
  TextInputType? keyboardType,
  List<TextInputFormatter>? inputFormatters,
  void Function(String)? onChanged,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 4, 22, 58),
        ),
      ),
      const SizedBox(height: 2),
      TextField(
        controller: controller,
        key: key,
        obscureText: obscureText,
        decoration: buildInputDecoration(
          hint,
          errorText: errorText,
          prefixIcon: prefixIcon,
          suffixIcon:
              suffixIconData != null
                  ? IconButton(icon: Icon(suffixIconData), onPressed: onPressed)
                  : null,
        ),
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
      ),
    ],
  );
}

Widget buildCustomDropdown(
  Key? key,
  String? value,
  String label,
  String hint,
  List<DropdownMenuItem<String>> items,
  void Function(String?) onChanged, {
  bool isExpanded = true,
  bool hideUnderline = false,
  bool useFormField = true,
  String? errorText,
}) {
  final dropdown = DropdownButton<String>(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    key: key,
    value: value,
    items: items,
    hint: Text(label),
    isExpanded: isExpanded,
    onChanged: onChanged,
  );

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 4, 22, 58),
        ),
      ),
      const SizedBox(height: 2),
      DropdownButtonFormField<String>(
        key: key,
        value: value,
        items: items,
        decoration: buildInputDecoration(label, errorText: errorText),
        isExpanded: isExpanded,
        onChanged: onChanged,
      ),
    ],
  );
}

