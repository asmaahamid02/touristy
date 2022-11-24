import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  SearchTextField({
    Key? key,
    this.focusNode,
    required this.controller,
    required this.labelText,
    required this.onTap,
    required this.readOnly,
    this.border,
    this.validator,
    this.autoFocus = false,
  }) : super(key: key);

  final FocusNode? focusNode;
  final TextEditingController controller;
  final String labelText;
  final Function()? onTap;
  String? Function(String?)? validator;
  final bool readOnly;
  final bool autoFocus;
  final InputBorder? border;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: border ?? const UnderlineInputBorder(),
        // labelText: labelText,
        hintText: labelText,
        prefixIcon: const Icon(Icons.location_on_outlined),
      ),
      readOnly: readOnly,
      autofocus: autoFocus,
      controller: controller,
      onTap: onTap,
      focusNode: focusNode,
      validator: validator,
    );
  }
}
