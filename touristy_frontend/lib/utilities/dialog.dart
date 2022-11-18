import 'package:flutter/material.dart';

class AlertDialogCommon {
  static void show({
    required BuildContext context,
    required String title,
    required String content,
    required String actionText,
    required Function action,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              action();
              Navigator.of(context).pop();
            },
            child: Text(actionText),
          ),
        ],
      ),
    );
  }
}
