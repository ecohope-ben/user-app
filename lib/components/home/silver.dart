import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/blocs/entitlement_cubit.dart';
import 'package:user_app/blocs/profile_cubit.dart';
import 'package:user_app/blocs/subscription_cubit.dart';

import '../../style.dart';

class SliverBar extends StatefulWidget {
  const SliverBar({super.key});

  @override
  State<SliverBar> createState() => _SliverBarState();
}

class _SliverBarState extends State<SliverBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/widget/home_bg.png') as ImageProvider,
          )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar and Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFF1A103C),
                radius: 24,
                child: Text(
                  "A",
                  style: TextStyle(color: mainPurple, fontSize: 20),
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
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {

        if(state is ProfileLoaded) {
          return RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 24, color: Colors.black),
              children: [
                TextSpan(text: "Hello, "),
                TextSpan(
                  text: state.profile.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }
        return Container();
      },
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
    return BlocBuilder<EntitlementCubit, EntitlementState>(
      builder: (context, state) {
        if (state is EntitlementLoaded) {
          return _buildStatItem(state.entitlements.isNotEmpty ? state.entitlements.first.quotaRemaining.toString() : "00", "Pick Up");
        }
        return Container();
      },
    );
  }

  Widget _buildSubscription() {
    return BlocBuilder<SubscriptionCubit, SubscriptionState>(
      builder: (context, state) {
        if (state is SubscriptionListLoaded) {
          return _buildStatItem(
              state.subscriptions.isNotEmpty ? state.subscriptions.first.plan.billingCycle.name : "No subscription", "Subscriptions");
        }
        return Container();
      },
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 13, color: Colors.black),
        ),
      ],
    );
  }
}

