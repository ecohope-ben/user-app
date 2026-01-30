import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/subscription_cubit.dart';
import '../../components/common/explore_banner.dart';

class HowItWorksPage extends StatelessWidget {
  final SubscriptionListLoaded subscriptionState;
  const HowItWorksPage(this.subscriptionState, {super.key});

  final Color timelineColor = const Color(0xFF005D2F); // timeline

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF376752),
                Color(0xFF294F55),
                Color(0xFF294F55),
                Color(0xFF294F55),
              ],
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 28),
          onPressed: () => context.pop(),
        ),
        title: Text(
          tr("how_it_works.title"),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tr("how_it_works.title"),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              // Timeline
              _buildTimelineStep(
                text: tr("how_it_works.items.join_subscription"),
                isFirst: true,
              ),
              _buildTimelineStep(
                text: tr("how_it_works.items.receive_recycle_bag"),
              ),
              _buildTimelineStep(
                text: tr("how_it_works.items.schedule_pickup_time"),
              ),
              _buildTimelineStep(
                text: tr("how_it_works.items.clean_bottles"),
              ),
              _buildTimelineStep(
                text: tr("how_it_works.items.collect_bag"),
              ),
              _buildTimelineStep(
                text: tr("how_it_works.items.upcycle"),
                isLast: true,
              ),

              const SizedBox(height: 30),
              const Divider(thickness: 1, color: Colors.black12),
              const SizedBox(height: 30),
              // ExploreBanner(subscriptionState),
              // const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildTimelineStep({
    required String text,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20,
            child: Column(
              children: [

                // Dot
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: timelineColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                // Line
                if (!isLast)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Container(
                        width: 1.5,
                        color: timelineColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}