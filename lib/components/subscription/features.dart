import 'package:flutter/material.dart';

class FeatureCard extends StatelessWidget {
  final List<String> features;
  final bool isSubscriptionCanceled;
  final Color themColor;
  const FeatureCard({required this.features, required this.themColor, this.isSubscriptionCanceled = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(isSubscriptionCanceled) Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              "Your subscription is ending soon",
              style: const TextStyle(
                fontSize: 15,
                color: Colors.red,
                height: 1.2,
              ),
            ),
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: features.map((feature){
                return FeaturesListItem(feature, color: themColor);
              }).toList()
          ),
        ],
      ),
    );
  }
}


class FeaturesListItem extends StatelessWidget {
  final String feature;
  final Color color;
  const FeaturesListItem(this.feature, {required this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              feature,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
