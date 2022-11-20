import 'package:flutter/material.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.color,
    required this.textColor,
    required this.onPressed,
  }) : super(key: key);
  final String label;
  final IconData icon;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        elevation: 5.0,
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: textColor),
              const SizedBox(width: 4.0),
              Text(label,
                  style: TextStyle(
                      fontSize: 14,
                      color: textColor,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}
