import 'package:flutter/material.dart';

class DialogUtils {
  static void showsDialog({
    BuildContext? context,
    String? title,
    String? message,
    VoidCallback? onPressed,
  }) {
    showDialog(
      context: context!,
      builder: (context) {
        return AlertDialog(
          title: Text(title.toString()),
          content: Text(message.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog

                // Check if onPressed is provided and execute it
                if (onPressed != null) {
                  onPressed();
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
