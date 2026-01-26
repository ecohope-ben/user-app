import 'package:flutter/material.dart';


class TitleText extends StatelessWidget {
  final String title;
  final double? fontSize;
  const TitleText(this.title, {this.fontSize, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: TextStyle(
            fontSize: fontSize ?? 30,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}

class SubTitleText extends StatelessWidget {
  final String title;
  const SubTitleText(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 15
        ),
      ),
    );
  }
}


