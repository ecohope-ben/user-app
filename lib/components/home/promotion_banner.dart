import 'package:flutter/material.dart';

class PromotionBanner extends StatelessWidget {
  final VoidCallback onTap;
  const PromotionBanner(this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6200EA), Color(0xFFB388FF)], // 紫色漸層
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Column(
        children: [
          const Text(
            "SUBSCRIBE NOW TO EARN WELCOME GIFT",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),

          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
              children: [
                const TextSpan(text: "Join our monthly plan with "),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Transform.rotate(
                    angle: -0.06, // rotate
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 0),
                      color: Colors.cyanAccent,
                      child: Transform.rotate(
                        angle: 0.06, // rotate
                        child: const Text(
                          "\$0",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const TextSpan(text: " now to earn\nfree welcome gift!"),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Subscribe
          SizedBox(
            width: double.infinity - 300,
            child: TextButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E1E1E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 0),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: const Text(
                  "Subscribe", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );

  }
}
