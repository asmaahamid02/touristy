import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  SearchTextField({
    Key? key,
    required this.focusNode,
    required this.controller,
    required this.labelText,
    required this.onTap,
    required this.readOnly,
    this.validator,
    this.autoFocus = false,
  }) : super(key: key);

  final FocusNode focusNode;
  final TextEditingController controller;
  final String labelText;
  final Function()? onTap;
  String? Function(String?)? validator;
  final bool readOnly;
  final bool autoFocus;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        labelText: labelText,
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
