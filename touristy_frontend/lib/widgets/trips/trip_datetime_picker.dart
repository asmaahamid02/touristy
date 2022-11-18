import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

class TripDateTimePicker extends StatelessWidget {
  const TripDateTimePicker(
      {super.key,
      required this.dateLabel,
      required this.firstDate,
      required this.lastDate,
      required this.controller,
      this.initialValue,
      required this.changeDate});
  final String dateLabel;
  final DateTime firstDate;
  final DateTime lastDate;
  final TextEditingController controller;
  final String? initialValue;
  final Function(String, TextEditingController) changeDate;
  @override
  Widget build(BuildContext context) {
    return DateTimePicker(
      type: DateTimePickerType.dateTimeSeparate,
      dateMask: 'MMM d, yyyy',
      initialValue: initialValue,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDate: firstDate,
      icon: const Icon(Icons.event),
      dateLabelText: dateLabel,
      timeLabelText: "Hour",
      onChanged: ((value) => changeDate(value, controller)),
    );
  }
}
