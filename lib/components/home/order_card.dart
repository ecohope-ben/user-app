import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/blocs/recycle_order_cubit.dart';
import 'package:user_app/components/register/action_button.dart';

import 'package:flutter/gestures.dart';
import '../../models/recycle_models.dart';
import '../../models/subscription_models.dart';
import '../../utils/time.dart';
import 'tracking_number.dart';



class InitialBagDeliveryCard extends StatelessWidget {
  final String? trackingNumber;

  const InitialBagDeliveryCard(this.trackingNumber, {super.key});

  final String bullet = "\u2022";

  Widget _buildItemForSF() {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 16, color: Colors.black),
        children: [
          TextSpan(text: "$bullet ${tr("please_use")}"),
          TextSpan(text: tr("sf_app"), style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(
            text: tr("for_the_tracking_updates"),
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
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
                Expanded(
                  child: Text(
                    "${tr("recycle_bag_is_delivering")} ...",
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
                TrackingNumber(trackingNumber),
                const SizedBox(height: 12),
                _buildItemForSF(),
                _buildMessage(tr("refresh_page_to_update")),
                _buildMessage(tr("order.pick_after_receive_bag")),

                ActionButton(tr("order.schedule_recycle_pickup"), disable: true),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    children: [
                      TextSpan(text: tr("please")),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(tr("contact_us"), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                          ),
                        ),
                      ),
                      TextSpan(
                        text: tr("if_something_wrong"),
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
                Expanded(
                  child: Text(
                    tr("order.recycle_bag_received_successfully"),
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
                Text(tr("order.congratulations"), style: TextStyle(fontSize: 18)),

                const SizedBox(height: 12),
                Text(tr("order.you_may_now_start_scheduling"), style: TextStyle(fontSize: 16)),
                const SizedBox(height: 24),

                ActionButton(tr("order.schedule_recycle_pickup"), onTap: () => context.push("/order/create", extra: subscriptionDetail))
              ],
            ),
          ),

        ],
      ),
    );
  }
}

class RecycleOrderCard extends StatefulWidget {
  final RecycleOrderListItem recycleOrder;
  final SubscriptionDetail subscriptionDetail;
  const RecycleOrderCard(this.recycleOrder, this.subscriptionDetail, {super.key});

  @override
  State<RecycleOrderCard> createState() => _RecycleOrderCardState();
}

class _RecycleOrderCardState extends State<RecycleOrderCard> {

  Widget _buildCard(BuildContext context, LogisticsOrder? logisticsOrder){
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
                Expanded(
                  child: Text(
                    tr("order.status.${widget.recycleOrder.status.name}"),
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
                          TrackingNumber(logisticsOrder?.trackingNo ?? tr("order.provide_later")),
                          // Text("${tr("tracking")} #${logisticsOrder?.trackingNo ?? tr("order.provide_later")}", style: TextStyle(fontSize: 18)),
                          const SizedBox(height: 12),
                          Text(tr("pick_up_on", args: [convertDateTimeToString(context, widget.recycleOrder.pickupAt, format: tr("format.date_time"))]), style: TextStyle(fontSize: 16)),
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

          // if order complete then show
          if(widget.recycleOrder.status == RecycleOrderStatus.completed) Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: ActionButton(
              tr("order.schedule_recycle_pickup_again"),
              icon: Image.asset("assets/icon/nav_main.png", scale: 3),
              onTap: (){
                context.push("/order/create", extra: widget.subscriptionDetail);

              },
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => RecycleOrderCubit()..loadOrderDetail(widget.recycleOrder.id),
      child: BlocBuilder<RecycleOrderCubit, RecycleOrderState>(
        builder: (context, state) {
          if(state is RecycleOrderDetailLoaded) {
            return InkWell(
                onTap: () => context.push("/order/details", extra: widget.recycleOrder.id),
                child: _buildCard(context, state.order.logisticsOrder)
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
