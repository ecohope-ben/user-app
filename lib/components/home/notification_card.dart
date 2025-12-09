import 'package:flutter/material.dart';

import '../../blocs/subscription_cubit.dart';
import '../../utils/time.dart';


class NotificationCard extends StatelessWidget {
  final SubscriptionDetailAndListLoaded subscriptionState;
  const NotificationCard(this.subscriptionState, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      width: double.infinity,
      color: Colors.black.withValues(alpha: 0.7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 9,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.check_circle_outline_outlined, color: Colors.white, size: 18),
                  SizedBox(width: 4),
                  Text("Great Job! Thanks for recycling.", style: TextStyle(color: Colors.white))
                ],
              ),
              Text("Wait until ${convertDateTimeToString(subscriptionState.detail.currentPeriodEnd, "dd MMM y")} for you next recycle.", style: TextStyle(color: Colors.white))
            ],
          )),
          Expanded(flex: 1, child: Icon(Icons.close, color: Colors.white)),
        ],
      ),
    );
  }
}
