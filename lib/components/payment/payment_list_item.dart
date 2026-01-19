import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/payment_models.dart';
import '../../utils/time.dart';


class PaymentHistoryListItem extends StatelessWidget {
  final PaymentListItem data;
  const PaymentHistoryListItem(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push("/payment/details", extra: data),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 左側資訊區塊
            Expanded(
              flex: 9,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    convertDateTimeToString(context, data.occurredAt),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.description,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.id,
                    style: const TextStyle(
                      color: Colors.black,
                      // fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 3,
              child: Row(
                children: [
                  FittedBox(

                    child: Text(
                      "\$" + data.amountDecimal,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.grey,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}