import 'package:flutter/material.dart';

class AlertDialogCommon {
  static void show({
    required BuildContext context,
    required String title,
    required String content,
    required String actionText,
    required Function? action,
    includeCancel = true,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          if (includeCancel)
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          TextButton(
            onPressed: () {
              action != null ? action() : null;
              Navigator.of(context).pop();
            },
            child: Text(actionText),
          ),
        ],
      ),
    );
  }
}
