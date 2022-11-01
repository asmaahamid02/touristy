import 'package:flutter/material.dart';

enum Gender { female, male, other }

class GenderRadioButton extends StatelessWidget {
  const GenderRadioButton(
      {required this.value,
      required this.title,
      required this.gender,
      required this.onChanged,
      super.key});

  final Gender value;
  final String title;
  final Gender gender;

  final Function(Gender?)? onChanged;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RadioListTile(
        value: value,
        groupValue: gender,
        title: Text(title),
        contentPadding: const EdgeInsets.all(0.0),
        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
        tileColor: gender == value ? Colors.lightBlue[50] : Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
