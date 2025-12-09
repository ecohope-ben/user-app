import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../components/pop_up/button.dart';
import '../routes.dart';
import '../style.dart';

Future<void> showPopup(
    BuildContext context,
    {
      String title = '確認',
      String message = '請確認您的操作',
      String confirmText = 'OK',
      String cancelText = 'Cancel',
      VoidCallback? onConfirm,
      bool isShowNegativeButton = true
    }){
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => PopScope(
      canPop: false,
      child: AlertDialog(
        titlePadding: EdgeInsets.only(top: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        title: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Text(
            tr(title),
            style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: Text(message, textAlign: TextAlign.center),
            ),
            SizedBox(height: 20),
            PositiveButton(title: confirmText, onTap: onConfirm),
            SizedBox(height: 2),
            if(isShowNegativeButton) NegativeButton(title: cancelText)
          ],
        ),
      ),
    ),
  );
}

Future<void> showForcePopup(
  BuildContext context, {
  String title = '確認',
  String message = '請確認您的操作',
  String confirmText = 'OK',
  VoidCallback? onConfirm,
}) {
  return showPopup(
    context, title: title, message: message, onConfirm: onConfirm, isShowNegativeButton: false
  );
}