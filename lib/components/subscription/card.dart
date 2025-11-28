import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/subscription_models.dart';
import '../../style.dart';
import 'features.dart';

class SubscriptionCard extends StatelessWidget {
  final PlanListItem plan;
  final List<String> features;

  const SubscriptionCard({
    super.key,
    required this.plan,
    required this.features,
  });

  String calCurrentPrice(){
    String currentPrice = plan.priceDecimal;
    if (plan.discount != null) {
      final discount = plan.discount!;
      if (discount.discountType == DiscountType.percentage) {
        // Calculate percentage discount (price is in cents)
        final discountAmount = (plan.price * discount.discountValue / 100).round();
        final discountedPrice = plan.price - discountAmount;
        // Convert cents to decimal string
        currentPrice = (discountedPrice / 100).toStringAsFixed(2);
      } else if (discount.discountType == DiscountType.fixedAmount) {
        // Calculate fixed amount discount (discountValue is in cents)
        final discountedPrice = plan.price - discount.discountValue;
        // Ensure price doesn't go negative
        final finalPrice = discountedPrice > 0 ? discountedPrice : 0;
        // Convert cents to decimal string
        currentPrice = (finalPrice / 100).toStringAsFixed(2);
      }
    }
    return currentPrice;
  }

  @override
  Widget build(BuildContext context) {
    // String? originalPrice = plan.priceDecimal;
    String? originalPrice;
    String currentPrice = calCurrentPrice();

    final Color themeColor;
    final String imagePath;

    if (plan.billingCycle == BillingCycle.monthly) {
      themeColor = mainPurple;
      imagePath = "assets/widget/subscription_header_monthly.png";
    } else {
      themeColor = blueBorder;
      imagePath = "assets/widget/subscription_header_yearly.png";
    }

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: themeColor, width: 1),
      ),
      child: Column(
        children: [

          SizedBox(
            height: 95,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(imagePath) as ImageProvider,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 左側文字資訊
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Subscription",
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              // originalPrice
                              if(originalPrice?.isNotEmpty ?? false)Text(
                                "\$$originalPrice",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: Colors.white70,
                                ),
                              ),
                              if(originalPrice?.isNotEmpty ?? false) const SizedBox(width: 8),
                              // currentPrice
                              Text(
                                "\$$currentPrice",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                " | ",
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                              Text(
                                (plan.discount?.discountType == DiscountType.freeCycles) ? "1 Month Free Trial" : plan.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          if(plan.discount?.discountType == DiscountType.freeCycles) Text("(Limited Offer)", style: TextStyle(color: Colors.white))
                        ],
                      ),

                      // Join now button
                      TextButton(
                        onPressed: () {

                          context.push("/subscription/signup", extra: {
                            'plan': plan,
                            'features': features,
                          },);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        ),
                        child: const Text("Join Now"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --- Card Body (Features List) ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: features.map((feature) {
                return FeaturesListItem(feature, color: themeColor);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }


}
