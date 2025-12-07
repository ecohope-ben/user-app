import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/components/register/action_button.dart';

import '../../models/subscription_models.dart';

class InitialBagDeliveryCard extends StatelessWidget {
  final String? trackingNumber;
  const InitialBagDeliveryCard(this.trackingNumber, {super.key});

  Widget _buildItem(){
    String bullet = "\u2022 ";
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 16, color: Colors.black),
        children: [
          TextSpan(text: "$bullet Check your phone", style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(
            text: " for the latest courier’s updates",
            style: TextStyle(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. 頂部黑色標題欄 (Header)
          Container(
            color: const Color(0xFF1A1A1A),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Recycle bag is Delivering ...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. 中間內容區域 (Body)
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tracking #$trackingNumber",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                _buildItem(),
                const SizedBox(height: 24),

                ActionButton("Schedule a recycle pick up", disable: true)
              ],
            ),
          ),

        ],
      ),
    );
  }
}

class ScheduleRecycleOrderCard extends StatelessWidget {
  final SubscriptionDetail subscriptionDetail;
  const ScheduleRecycleOrderCard(this.subscriptionDetail, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. 頂部黑色標題欄 (Header)
          Container(
            color: const Color(0xFF1A1A1A),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Recycle bag received successfully",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. 中間內容區域 (Body)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Congratulations!", style: TextStyle(fontSize: 18)),

                const SizedBox(height: 12),
                Text("You may now start scheduling your first recycle pick up here.", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 24),

                ActionButton("Schedule a recycle pick up", onTap: () => context.push("/order/create", extra: subscriptionDetail))
              ],
            ),
          ),

        ],
      ),
    );
  }
}