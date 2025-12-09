import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/blocs/recycle_order_cubit.dart';
import 'package:user_app/components/register/action_button.dart';

import 'package:flutter/gestures.dart';
import '../../models/recycle_models.dart';
import '../../models/subscription_models.dart';
import '../../utils/snack.dart';

class InitialBagDeliveryCard extends StatelessWidget {
  final String? trackingNumber;

  const InitialBagDeliveryCard(this.trackingNumber, {super.key});

  final String bullet = "\u2022";
  Widget _buildItemForSF() {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 16, color: Colors.black),
        children: [
          TextSpan(text: "$bullet Please use the "),
          TextSpan(text: "SF Express App", style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(
            text: " for latest tracking updates.",
          ),
        ],
      ),
    );
  }
  Widget _buildMessage(String message) {
    return Text(bullet + " " +message, style: TextStyle(fontSize: 16, color: Colors.black));
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
                  "Tracking #${trackingNumber ?? ""}",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                _buildItemForSF(),
                _buildMessage("Please refresh this page once you’ve received the bag and tap on the button below to schedule a pick up."),

                ActionButton("Schedule a recycle pick up", disable: true),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    children: [
                      TextSpan(text: "Please"),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(" contact us ", style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                          ),
                        ),
                      ),
                      TextSpan(
                        text: "is something is wrong",
                      ),
                    ],
                  ),
                )
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

class RecycleOrderCard extends StatelessWidget {
  final RecycleOrderListItem recycleOrder;

  const RecycleOrderCard(this.recycleOrder, {super.key});

  Widget _buildCard(LogisticsOrder? logisticsOrder){
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
        children: [
          // Header
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
                    "Pick Up Schedule Confirmed",
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

          // Body
          Row(
            children: [
              Expanded(
                flex: 8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Tracking #${logisticsOrder?.trackingNo ?? ""}", style: TextStyle(fontSize: 18)),
                          const SizedBox(height: 12),
                          Text("Pick Up on ${recycleOrder.pickupDate} | ${recycleOrder.pickupTime}", style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Icon(Icons.chevron_right)
              )
            ],
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => RecycleOrderCubit()..loadOrderDetail(recycleOrder.id),
      child: BlocBuilder<RecycleOrderCubit, RecycleOrderState>(
        builder: (context, state) {
          if(state is RecycleOrderDetailLoaded) {
            return InkWell(
                onTap: () => context.push("/order/details", extra: recycleOrder.id),
                child: _buildCard(state.order.logisticsOrder)
            );
          }else if (state is RecycleOrderError){
            return Container();
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}