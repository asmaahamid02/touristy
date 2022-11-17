import 'package:flutter/material.dart';

class CommentButtons extends StatelessWidget {
  const CommentButtons({
    Key? key,
    required this.label,
    required this.color,
    required this.onTap,
  }) : super(key: key);
  final String label;
  final Color color;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.0,
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
