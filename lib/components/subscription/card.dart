import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/pages/subscription/manage/list.dart';
import 'package:user_app/utils/snack.dart';

import '../../models/discount/index.dart';
import '../../models/subscription_models.dart';
import '../../style.dart';
import 'features.dart';

class SubscriptionCard extends StatelessWidget {
  final PlanListItem plan;
  final List<String> features;
  final bool isCurrentPlan;
  final bool isPaymentFailed;
  final bool isSubscriptionCanceled;
  final bool isSubscriptionScheduledPlanChange;
  final String? subscriptionId;
  final bool hasDiscount;
  final SubscriptionManageTarget target;
  const SubscriptionCard({
    super.key,
    required this.plan,
    required this.features,
    this.hasDiscount = false,
    this.target = SubscriptionManageTarget.normal,
    this.isCurrentPlan = false,
    this.isPaymentFailed = false,
    this.isSubscriptionCanceled = false,
    this.isSubscriptionScheduledPlanChange = false,
    this.subscriptionId,
  });

  String calCurrentPrice(){
    if(hasDiscount) return Discount.instance().amount.toString();
    print("--plan price");
    print(plan.priceDecimal);
    String currentPrice = plan.priceDecimal;

    return currentPrice;
  }

  @override
  Widget build(BuildContext context) {
    // String? originalPrice = plan.priceDecimal;
    String? originalPrice;
    String currentPrice = calCurrentPrice();

    final String imagePath = "assets/widget/subscription_header.png";

    return Container(
      margin: EdgeInsets.only(bottom: verticalCardGapPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                      Expanded(
                        flex: 7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              tr("subscription.title"),
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
                                Flexible(
                                  child: Text(
                                    (false) ? tr("promote.1_month_free_trial") : plan.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      height: 1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // if(plan.id == Discount.instance().planId) Text(tr("promote.limited_offer"), style: TextStyle(color: Colors.white))
                          ],
                        ),
                      ),

                      // Join now button
                      Expanded(
                        flex: 3,
                        child: TextButton(
                          onPressed: () {
                            if(isCurrentPlan) {
                              if (subscriptionId == null) {
                                // Show error if subscriptionId is missing
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(tr("subscription.id_no_exist"))),
                                );
                                return;
                              }
                              context.push("/subscription/manage/detail", extra: {
                                'plan': plan,
                                'features': features,
                                'subscriptionId': subscriptionId!,
                              });
                            }else {
                              if(target == SubscriptionManageTarget.change){
                                if(isSubscriptionCanceled){
                                  popSnackBar(context, tr("subscription.keep.first"));
                                  return;
                                }
                                if(isSubscriptionScheduledPlanChange){
                                  popSnackBar(context, tr("subscription.cancel_subscription_change_first"));
                                  return;
                                }
                                if (subscriptionId == null) {
                                  // Show error if subscriptionId is missing
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(tr("subscription.id_no_exist"))),
                                  );
                                  return;
                                }
                                context.push("/subscription/manage/change_plan", extra: {
                                  'plan': plan,
                                  'features': features,
                                  'subscriptionId': subscriptionId!
                                });
                              }else {
                                context.push("/subscription/signup", extra: {
                                  'plan': plan,
                                  'features': features,
                                });
                              }
                            }
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                          ),
                          child: Text(_buildButtonText(), textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildActiveLabel(),
          // --- Card Body (Features List) ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: features.map((feature) {
                return FeaturesListItem(feature, color: listItemGreen);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _buildButtonText(){
    if(isCurrentPlan) {
      return tr("subscription.manage");
    } else {
      if(target == SubscriptionManageTarget.change){
        return tr("subscription.change_plan");
      }else {
        return tr("subscription.join_now");
      }
    }

  }

  Widget _buildActiveLabel(){
    if(isCurrentPlan){
      if(isPaymentFailed){
        return Padding(
          padding: const EdgeInsets.only(left: 20, top: 10),
          child: Text(tr("subscription.payment_failed"), style: TextStyle(color: Colors.red),),
        );
      }else if (isSubscriptionCanceled){
        return Padding(
          padding: const EdgeInsets.only(left: 20, top: 10),
          child: Text(tr("subscription.ending_soon"), style: TextStyle(color: Colors.red),),
        );
      }else {
        return Row(
        children: [
          Container(
            width: 12,
            height: 12,
            margin: EdgeInsets.only(left: 20, top: 10, right: 14),
            decoration: BoxDecoration(
              color: listItemGreen,
              shape: BoxShape.circle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(tr("active"), style: TextStyle(color: listItemGreen),),
          )
        ],
      );
      }
    }else return Container();
  }
}
