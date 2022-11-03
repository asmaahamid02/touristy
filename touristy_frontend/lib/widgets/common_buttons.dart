import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key? key,
    required this.textLabel,
    required this.onTap,
  }) : super(key: key);

  final String textLabel;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: ElevatedButton(
        onPressed: onTap,
        child: Text(textLabel),
      ),
    );
  }
}
