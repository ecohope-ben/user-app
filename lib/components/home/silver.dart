import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/blocs/entitlement_cubit.dart';
import 'package:user_app/blocs/profile_cubit.dart';
import 'package:user_app/blocs/subscription_cubit.dart';

import '../../style.dart';

class SliverBar extends StatefulWidget {
  final ProfileLoaded profileState;
  final EntitlementLoaded entitlementState;
  final SubscriptionDetailAndListLoaded subscriptionState;
  const SliverBar({super.key, required this.profileState, required this.entitlementState, required this.subscriptionState});

  @override
  State<SliverBar> createState() => _SliverBarState();
}

class _SliverBarState extends State<SliverBar> {
  String? avatar;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          avatar = widget.profileState.profile.name[0].toUpperCase();
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
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 24,
                child: Text(
                  avatar ?? "",
                  style: TextStyle(color: Color(0xFF509667), fontSize: 20),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 1.5),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(Icons.question_mark, size: 20),
                ),
              )
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
        _buildStatItem("00", "Total collections"),
      ],
    );
  }

  Widget _buildPickupRemining() {
    final state = widget.entitlementState;
    return _buildStatItem(state.entitlements.isNotEmpty ? state.entitlements.first.quotaRemaining.toString() : "00", "Pick Up");

  }

  Widget _buildSubscription() {
   final state = widget.subscriptionState;
    return _buildStatItem(state.subscriptions.isNotEmpty ? state.subscriptions.first.plan.billingCycle.name : "No subscription", "Subscriptions");

  }

  Widget _buildStatItem(String value, String label) {
    return Column(
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
    );
  }
}

