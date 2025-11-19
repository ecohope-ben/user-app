import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../style.dart';

Future<void> showForcePopup(
  BuildContext context, {
  String title = '確認',
  String message = '請確認您的操作',
  String confirmText = 'OK',
  VoidCallback? onConfirm,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => PopScope(
      canPop: false,
      child: AlertDialog(
        titlePadding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        title: Container(
          color: mainPurple,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Text(
            tr(title),
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(message),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onConfirm?.call();
            },
            style: ButtonStyle(
              overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
              backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
            ),
            child: Text(confirmText, style: TextStyle(color: mainPurple, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ),
  );
}