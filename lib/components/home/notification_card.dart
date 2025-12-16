import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/subscription_cubit.dart';
import '../../pages/subscription/manage/list.dart';
import '../../utils/time.dart';

class SubscriptionCanceledNotificationCard extends StatelessWidget {
  final String expiredDate;
  const SubscriptionCanceledNotificationCard(this.expiredDate, {super.key});

  Widget _buildButton(BuildContext context){
    return Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.white)
        ),
        child: TextButton(
          onPressed:() => context.push("/subscription/manage/list", extra: SubscriptionManageTarget.manage),
          child: Text(
            "Update",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return NotificationCard(
      iconData: Icons.info_outline,
      title: null,
      description: "Your subscription will end on $expiredDate. You can change your mind anytime before this date.",
      action: _buildButton(context),
    );
  }
}

class PaymentFailedNotificationCard extends StatelessWidget {
  final String subscriptionId;
  const PaymentFailedNotificationCard(this.subscriptionId, {super.key});

  Widget _buildButton(BuildContext context){
    return Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.white)
        ),
        child: TextButton(
          onPressed:() => context.push("/subscription/manage/list", extra: SubscriptionManageTarget.manage),
          child: Text(
            "Update Now",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return NotificationCard(
      iconData: Icons.info_outline,
      title: "Payment Failed",
      description: "Update your payment method",
      action: _buildButton(context),
    );
  }
}

class FinishedRecycleOrderNotificationCard extends StatelessWidget {

  final SubscriptionDetailAndListLoaded subscriptionState;
  const FinishedRecycleOrderNotificationCard(this.subscriptionState, {super.key});

  @override
  Widget build(BuildContext context) {
    return NotificationCard(
      iconData: Icons.check_circle_outline_outlined,
      title: "Great Job! Thanks for recycling.",
      description: "Wait until ${convertDateTimeToString(context, subscriptionState.detail.currentPeriodEnd, format: "dd MMM y")} for you next recycle.",

    );
  }
}

class NotificationCard extends StatelessWidget {
  final IconData iconData;
  final String? title;
  final String description;
  final Widget? action;

  const NotificationCard({super.key, required this.iconData, required this.title, required this.description, this.action});

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
              if(title != null) Row(
                children: [
                  Icon(iconData, color: Colors.white, size: 18),
                  SizedBox(width: 4),
                  Text(title!, style: TextStyle(color: Colors.white))
                ],
              ),
              Text(description, style: TextStyle(color: Colors.white))
            ],
          )),
          if(action != null) Expanded(
            flex: 3,
            child: action!
          ),
          if(action != null) SizedBox(width: 8),
          // Expanded(flex: 1, child: Icon(Icons.close, color: Colors.white)),
        ],
      ),
    );
  }
}
