import 'package:flutter/material.dart';

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
    Icon? prefixIcon,
    Icon? suffixIcon,
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
      maxLines: maxLines,
      validator: validator,
      focusNode: focusNode,
      controller: controller,
      readOnly: readOnly!,
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
