import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showAdaptativeAlertDialog({
  required BuildContext context,
  required String titleText,
  required Function(String) onSubmit,
  Function()? onDismiss,
}) {
  final textController = TextEditingController();
  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(titleText),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => onSubmit(textController.text),
              child: const Text('Add'),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: onDismiss ?? () => Navigator.pop(context),
              child: const Text('Dismiss'),
            ),
          ],
        );
      },
    );
  } else {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text(titleText),
          content: TextField(
            controller: textController,
          ),
          actions: [
            MaterialButton(
              onPressed: () => onSubmit(textController.text),
              elevation: 5,
              textColor: Colors.blue,
              child: const Text('Add'),
            )
          ],
        );
      },
    );
  }
}
