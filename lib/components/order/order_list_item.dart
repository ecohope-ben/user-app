import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/recycle_models.dart';

class OrderListItem extends StatelessWidget {
  final RecycleOrderListItem data;
  const OrderListItem(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push("/order/details", extra: data.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 左側資訊區塊
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.id,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Pick Up Date and Time",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${data.pickupDate} | ${data.pickupTime}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            // 右側狀態區塊
            Row(
              children: [
                Text(
                  data.status.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.grey,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
