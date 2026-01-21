import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CancelPlanNoticeBanner extends StatelessWidget {
  final String date;
  const CancelPlanNoticeBanner(this.date, {super.key});

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
              tr("subscription.your_subscription_will_end", args: [date]),
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
class ChangePlanNoticeBanner extends StatelessWidget {
  final String? newPlanName;
  final String date;
  const ChangePlanNoticeBanner(this.newPlanName, this.date, {super.key});

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
              tr("subscription.your_subscription_will_change", args: [date, newPlanName ?? ""]),
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

