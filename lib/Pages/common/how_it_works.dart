import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HowItWorksPage extends StatelessWidget {
  const HowItWorksPage({super.key});

  final Color timelineColor = const Color(0xFF56AD82); // timeline
  final Color bannerColor = const Color(0xFF1F7A66); // banner color

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
          icon: const Icon(Icons.close, color: Colors.white, size: 28),
          onPressed: () => context.pop,
        ),
        title: const Text(
          'How it Works',
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
              const Text(
                'How it works?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              // Timeline
              _buildTimelineStep(
                text: 'Join a subscription plan',
                isFirst: true,
              ),
              _buildTimelineStep(
                text: 'Receive a FREE brand new Eco Hope recycle bag',
              ),
              _buildTimelineStep(
                text: 'Schedule a pick up time',
              ),
              _buildTimelineStep(
                text: 'Clean and pack the plastic bottles with Eco Hope recycle bag. (please pour out all liquid)',
              ),
              _buildTimelineStep(
                text: 'Courier will come to collect the bag. Start Tracking your recycle impact! One foe One****',
              ),
              _buildTimelineStep(
                text: 'We upcycle your plastic bottles into new products, giving plastic a second life.',
                isLast: true,
              ),

              const SizedBox(height: 30),
              const Divider(thickness: 1, color: Colors.black12),
              const SizedBox(height: 30),
              _buildBanner(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBanner(){
    return
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bannerColor,
          borderRadius: BorderRadius.zero,
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              const Color(0xFF1A5E4D),
              const Color(0xFF2A9D84),
            ],
          ),
        ),
        child: Row(
          children: [
            // Star
            const Icon(
              Icons.auto_awesome_outlined,
              color: Colors.white,
              size: 36,
            ),
            const SizedBox(width: 16),

            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Limited Offer, Join Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Free Trial available',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Explore
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              ),
              child: const Text('Explore'),
            ),
          ],
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