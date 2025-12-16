import 'package:flutter/material.dart';

class NoticeBanner extends StatelessWidget {
  final String date;
  const NoticeBanner(this.date, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
              child: Icon(Icons.info_outline, color: Colors.white)),
          Expanded(
            flex: 9,
            child: Text(
                "Your subscription will end on $date. You can change your mind anytime before this date.",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
