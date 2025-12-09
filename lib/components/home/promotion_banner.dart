import 'package:flutter/material.dart';
import 'package:user_app/components/register/action_button.dart';
class PromotionBanner extends StatelessWidget {
  final VoidCallback onTap;
  const PromotionBanner(this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    BorderSide borderSide = BorderSide(
      color: Colors.white,
      width: 2,
    );
    return Container(
      width: double.infinity,
      // padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        border: Border(
          top: borderSide,
          bottom: borderSide,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 20,
              // offset: const Offset(10, 12),
            ),
          ]
        ),
        child: Column(
          children: [
            const Text(
              "SUBSCRIBE NOW TO EARN WELCOME GIFT",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),

            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(color: Colors.black,
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
            const SizedBox(height: 10),
            Text("Limited Offer, First come first served!", style: TextStyle(color: Colors.black54),),
            const SizedBox(height: 20),

            // Subscribe
            SizedBox(
              width: 280,
              child: ActionButton("Subscribe", onTap: onTap, needPadding: false)
            ),
          ],
        ),
      ),
    );

  }
}
