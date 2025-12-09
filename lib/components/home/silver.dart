import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/blocs/entitlement_cubit.dart';
import 'package:user_app/blocs/profile_cubit.dart';
import 'package:user_app/blocs/subscription_cubit.dart';
import 'package:user_app/pages/subscription/manage/list.dart';
import 'package:user_app/utils/extension.dart';

import '../../style.dart';

class SliverBar extends StatefulWidget {
  final ProfileLoaded profileState;
  final EntitlementLoaded entitlementState;
  final SubscriptionListLoaded subscriptionState;
  const SliverBar({super.key, required this.profileState, required this.entitlementState, required this.subscriptionState});

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
          TextSpan(text: "Hello, "),
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
      children: [
        _buildPickupRemining(),
        _buildSubscription(),
        _buildStatItem(value: "00", label: "Total collections"),
      ],
    );
  }

  Widget _buildPickupRemining() {
    final state = widget.entitlementState;
    return _buildStatItem(
        value: state.entitlements.isNotEmpty ? state.entitlements.first.quotaRemaining.toString() : "00",
        label: "Pick Up"
    );

  }

  Widget _buildSubscription() {
   final state = widget.subscriptionState;
    return _buildStatItem(
        value: state.subscriptions.isNotEmpty ? state.subscriptions.first.plan.billingCycle.name : "No subscription",
        label: "Subscriptions",
        onTap: () => context.push("/subscription/manage/list", extra: SubscriptionManageTarget.manage)
    );

  }

  Widget _buildStatItem({required String value, required String label, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

