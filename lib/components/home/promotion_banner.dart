import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:user_app/components/register/action_button.dart';
import 'package:user_app/models/discount/index.dart';
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
            Text(
              tr("promote.subscription_to_earn_gift"),
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
                  TextSpan(text: tr("promote.join_our_monthly_plan")),
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
                  TextSpan(text: tr("promote.now_to_earn_free_welcome_gift")),

                ],
              ),
            ),
            if(Discount.instance().promotionCode != null) const SizedBox(height: 10),
            if(Discount.instance().promotionCode != null) Text(Discount.instance().promotionCode!, style: TextStyle(color: Colors.black54),),

            const SizedBox(height: 10),
            Text(tr("promote.limited_offer_first_come_first_served"), style: TextStyle(color: Colors.black54),),
            const SizedBox(height: 20),

            // Subscribe
            SizedBox(
              width: 280,
              child: ActionButton(tr("subscribe"), onTap: onTap, needPadding: false)
            ),
          ],
        ),
      ),
    );

  }
}
