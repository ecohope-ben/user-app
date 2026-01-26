import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../style.dart';

class PositiveButton extends StatelessWidget {
  final String? title;
  final VoidCallback? onTap;
  const PositiveButton({this.title, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
          onPressed: () {
            context.pop(context);
            onTap?.call();
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero
            ),
          ),
          child: Text(title ?? tr("ok"))
      ),
    );
  }
}

class NegativeButton extends StatelessWidget {
  final String? title;
  const NegativeButton({this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
          onPressed: () {
            context.pop(context);
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero
            ),
          ),
          child: Text(title ?? tr("cancel"), style: TextStyle(color: blueRegisterText))
      ),
    );
  }
}
