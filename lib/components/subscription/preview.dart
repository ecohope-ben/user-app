import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:user_app/components/subscription/payment_detail_row.dart';

class SubscriptionPreviewCard extends StatelessWidget {
  final String billingRecycleType;
  final String renewalText;
  final String amountText;
  final String autoRenewText;
  const SubscriptionPreviewCard({super.key, required this.billingRecycleType, required this.renewalText, required this.amountText, required this.autoRenewText});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PaymentDetailRow("Type", tr("subscription.$billingRecycleType"), isBold: true),
        const SizedBox(height: 8),
        PaymentDetailRow("Renewing on", renewalText, isBold: true),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 100,
              child: Text("Amount", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w700)),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    amountText,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    autoRenewText,
                    style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
