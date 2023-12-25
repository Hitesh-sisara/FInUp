import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showAlert(
    String message,
  ) =>
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 2000),
        ),
      );

  Future<T?> showAlertDialog<T>({
    required String content,
    String? title,
    String? cancelActionText,
    String? defaultActionText,
  }) =>
      showDialog<T>(
        context: this,
        builder: (context) => AlertDialog(
          title: title != null ? Text(title) : null,
          content: Text(content), // Content is always displayed
          actions: <Widget>[
            if (cancelActionText != null)
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(cancelActionText),
              ),
            if (defaultActionText != null)
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(defaultActionText),
              ),
          ],
        ),
      );

  Future<T?> showBottomSheet<T>({
    required Widget child,
  }) =>
      showModalBottomSheet<T>(
        context: this,
        builder: (_) => child,
      );
}
