import 'package:flutter/material.dart';
import 'package:touristy_frontend/utilities/theme.dart';

enum Gender { female, male, other }

class GenderRadioButton extends StatelessWidget {
  const GenderRadioButton(
      {required this.value,
      required this.gender,
      required this.onChanged,
      super.key});

  final Gender value;
  final Gender gender;

  final Function(Gender?)? onChanged;
  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Expanded(
      child: RadioListTile(
        value: value,
        groupValue: gender,
        title: Text(value.name),
        contentPadding: const EdgeInsets.all(0.0),
        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
        tileColor: brightness != Brightness.light
            ? Theme.of(context).cardColor
            : AppColors.textFaded,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onChanged: onChanged,
        dense: true,
      ),
    );
  }
}
