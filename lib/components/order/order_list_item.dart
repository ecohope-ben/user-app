import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/recycle_models.dart';
import '../../utils/time.dart';

class OrderListItem extends StatelessWidget {
  final RecycleOrderListItem data;
  const OrderListItem(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push("/order/details", extra: data.id),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 左側資訊區塊
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "#${data.recycleOrderNo}",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tr("order.pickup_date_time"),
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  convertDateTimeToString(context, data.pickupAt, format: tr("format.date_time")),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            // 右側狀態區塊
            Row(
              children: [
                Text(
                  tr("order.status.short.${data.status.name}"),
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
