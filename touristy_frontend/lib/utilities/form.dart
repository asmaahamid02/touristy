import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormUtility {
  static String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter your email';
    }
    const emailPattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
    final result = RegExp(emailPattern, caseSensitive: false).hasMatch(value);
    //check if email is valid
    if (!result) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validateName(String value, String fieldName) {
    if (value.isEmpty) {
      return 'Please enter $fieldName';
    }
    return null;
  }

  static String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateConfirmPassword(String value, String password) {
    if (value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validateDateOfBirth(String value) {
    if (value.isEmpty) {
      return 'Please enter your date of birth';
    }

    //check if less than 16 years old
    final date = DateFormat.yMMMd().parse(value);
    final age = DateTime.now().difference(date).inDays / 365;
    if (age < 16) {
      return 'You must be at least 16 years old';
    }

    return null;
  }

//onsubmit
  static void onSubmitField({
    required BuildContext context,
    required FocusNode focusNode,
  }) {
    FocusScope.of(context).requestFocus(focusNode);
  }
//onSaved

  //build a text field for name
  static TextFormField buildTextField({
    required String label,
    Widget? prefixIcon,
    Widget? suffixIcon,
    TextEditingController? controller,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    void Function(String?)? onFieldSubmitted,
    TextInputType? keyboardType,
    String? initialValue,
    bool? readOnly = false,
    bool? autoFocus = false,
    VoidCallback? onTap,
    String? helperText,
    int? maxLines,
    bool? obscureText = false,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        labelText: label,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        helperText: helperText,
      ),
      initialValue: initialValue,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      validator: validator,
      focusNode: focusNode,
      controller: controller,
      readOnly: readOnly!,
      obscureText: obscureText!,
      autofocus: autoFocus!,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      onSaved: onSaved,
      onTap: onTap,
    );
  }

  //date picker
  static Future<DateTime?> showDatePickerDialog({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
  }
}
