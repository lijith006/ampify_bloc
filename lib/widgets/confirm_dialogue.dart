import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText = 'Remove',
    this.cancelText = 'Cancel',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: Theme.of(context).cardColor,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(
        content,
        style: const TextStyle(fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText, style: const TextStyle(color: Colors.grey)),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            confirmText,
            style:
                const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
