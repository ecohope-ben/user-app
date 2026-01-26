import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AdditionalOrderNoticeBanner extends StatelessWidget {
  const AdditionalOrderNoticeBanner({super.key});

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
              tr("order.additional_order_notice"),
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

