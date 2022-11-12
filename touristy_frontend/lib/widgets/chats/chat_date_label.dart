import 'package:flutter/material.dart';
import '../../utilities/utilities.dart';

class ChatDateLabel extends StatelessWidget {
  const ChatDateLabel({super.key, required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textFaded,
                fontSize: 12.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
