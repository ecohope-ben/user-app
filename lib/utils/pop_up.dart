import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../components/pop_up/button.dart';

Future<void> showPopup(
    BuildContext context,
    {
      String? title,
      String? message,
      String? confirmText,
      String? cancelText,
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
        title: (title != null) ? Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Text(
            title,
            style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ) : null,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: Text(message ?? "", textAlign: TextAlign.center),
            ),
            SizedBox(height: 20),
            PositiveButton(title: confirmText ?? tr("ok"), onTap: onConfirm),
            SizedBox(height: 2),
            if(isShowNegativeButton) NegativeButton(title: cancelText ?? tr('cancel'))
          ],
        ),
      ),
    ),
  );
}

Future<void> showForcePopup(
  BuildContext context, {
      String? title,
      String? message,
      String? confirmText,
      String? cancelText,
      VoidCallback? onConfirm,
}) {
  return showPopup(
    context, title: title, message: message, onConfirm: onConfirm, isShowNegativeButton: false
  );
}