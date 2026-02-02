import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/blocs/entitlement_cubit.dart';
import 'package:user_app/blocs/profile_cubit.dart';
import 'package:user_app/blocs/recycle_order_cubit.dart';
import 'package:user_app/blocs/subscription_cubit.dart';
import 'package:user_app/pages/subscription/manage/list.dart';
import 'package:user_app/utils/extension.dart';
import 'package:user_app/utils/time.dart';

import '../../models/entitlement_models.dart';


class SliverBar extends StatefulWidget {
  final ProfileLoaded profileState;
  final EntitlementLoaded entitlementState;
  final SubscriptionListLoaded subscriptionState;
  final RecycleOrderListLoaded recycleOrderState;
  const SliverBar({super.key, required this.profileState, required this.entitlementState, required this.subscriptionState, required this.recycleOrderState});

  @override
  State<SliverBar> createState() => _SliverBarState();
}

class _SliverBarState extends State<SliverBar> {
  String? avatar;

  String setAvatar(String avatarStr) {
    try {
      if(avatarStr.hasEmoji){
        String? firstEmoji = avatarStr.firstEmoji;
        if(firstEmoji == null){
          return "";
        }else {
          return firstEmoji;
        }
      }else {
        return avatarStr[0].toUpperCase();
      }
    } catch (e) {
      return avatarStr[0].toUpperCase();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          avatar = setAvatar(widget.profileState.profile.name);
        });
      }
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SliverBar oldWidget) {
    if(oldWidget.profileState.profile.name != widget.profileState.profile.name){
      setState(() {
        avatar = setAvatar(widget.profileState.profile.name);
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar and Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => context.push("/profile/edit"),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 24,
                  child: Text(
                    avatar ?? "",
                    style: TextStyle(color: Color(0xFF509667), fontSize: 20),
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  context.push("/settings", extra: widget.subscriptionState);
                },
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(Icons.settings , size: 25, color: Colors.white,),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Hello User
          _buildProfile(),

          const SizedBox(height: 24),

          _buildStatColumn()
        ],
      ),
    );
  }

  Widget _buildProfile() {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 24, color: Colors.white),
        children: [
          TextSpan(text: "${tr("hello")}, "),
          TextSpan(
            text: widget.profileState.profile.name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 1, child: _buildPickupRemining()),
        SizedBox(width: 5),
        Expanded(flex: 1, child: _buildSubscription()),
        SizedBox(width: 5),
        Expanded(flex: 1, child: _buildTotalCollection())
      ],
    );
  }

  int calEntitlementsRemaining(List<EntitlementListItem> list){
    int total = 0;
    for (var item in list) {
      total += item.quotaRemaining;
    }
    return total;
  }

  Widget _buildPickupRemining() {
    final state = widget.entitlementState;
    return _buildStatItem(
        value: state.entitlements.isNotEmpty ? calEntitlementsRemaining(state.entitlements).toString() : "00",
        label: tr("remaining_pickups"),

        label2: state.entitlements.isNotEmpty ? "${tr("expired_date")} ${convertDateTimeToString(context, state.entitlements.first.expiresAt, format: "dd/MM/yy")}" : null,

    );
  }

  String? _buildSubscriptionLabel() {
    final state = widget.subscriptionState;
    if(state is SubscriptionDetailAndListLoaded){
      if(state.detail.scheduledCancellation != null){
        return "${tr("expired_date")} ${convertDateTimeToString(context, state.detail.currentPeriodEnd, format: "dd/MM/yy")}";
      }else {
        return "${tr("renew")} ${convertDateTimeToString(context, state.detail.currentPeriodEnd, format: "dd/MM/yy")}";
      }
    }
    if(state.subscriptions.isNotEmpty) {
      return "${tr("renew")} ${convertDateTimeToString(context, state.subscriptions.first.currentPeriodEnd, format: "dd/MM/yy")}";
    }
    return null;


  }

  Widget _buildSubscription() {
   final state = widget.subscriptionState;
    return _buildStatItem(
        value: state.subscriptions.isNotEmpty ? tr("subscription.billing_cycle.${state.subscriptions.first.plan.billingCycle.name}.plan") : "--",
        label: tr("subscriptions"),
        label2: _buildSubscriptionLabel(),

        onTap: () => state.subscriptions.isNotEmpty ? context.push("/subscription/manage/list", extra: SubscriptionManageTarget.manage) : context.push("/subscription/list")
    );
  }

  Widget _buildTotalCollection() {
    final state = widget.recycleOrderState;
    return _buildStatItem(
        value: state.orders.isNotEmpty ? state.orders.length.toString() : "00",
        label: tr("total_collection")
    );
  }

  Widget _buildStatItem({required String value, required String label, String? label2, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white,),
          ),
          const SizedBox(height: 4),

          Wrap(
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 13, color: Colors.white),
              )
            ]
          ),
          if(label2 != null) Text(
            label2,
            style: TextStyle(fontSize: 11, color: Colors.white,),
          ),
          if(label2 != null) SizedBox(height: 4),
        ],
      ),
    );
  }
}

