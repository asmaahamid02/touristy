import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    Key? key,
    required this.focusNode,
    required this.controller,
    required this.labelText,
    required this.onTap,
    required this.readOnly,
    this.autoFocus = false,
  }) : super(key: key);

  final FocusNode focusNode;
  final TextEditingController controller;
  final String labelText;
  final Function()? onTap;
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
    );
  }
}
