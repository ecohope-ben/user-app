import 'package:flutter/material.dart';


void popSnackBar(BuildContext context, String? message){
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(message ?? ""),
      behavior: SnackBarBehavior.floating,
    ),
  );
}