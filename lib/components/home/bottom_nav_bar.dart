import 'package:easy_localization/easy_localization.dart';
import 'package:el_tooltip/el_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/subscription_models.dart';
import '../../utils/snack.dart';
import '../../utils/time.dart';

class CustomBottomNavBar extends StatelessWidget {

  final ElTooltipController tooltipController;
  final SubscriptionDetail? subscriptionDetail;
  final bool hasEntitlement;
  const CustomBottomNavBar(this.tooltipController, {this.subscriptionDetail, required this.hasEntitlement, super.key});

  Widget _buildMainLogo(BuildContext context){

    return InkWell(
      onTap: () {
        if(subscriptionDetail == null){
          popSnackBar(context, tr("subscription.subscribe_plan_first"));
        }
        // else if(!hasEntitlement){
        //   popSnackBar(context, tr("order.pick_up_unavailable", args: [convertDateTimeToString(context, subscriptionDetail?.currentPeriodEnd)]));
        // }
        else if(subscriptionDetail?.recyclingProfile?.initialBagStatus != "delivered"){
          popSnackBar(context, tr("order.pick_after_receive_bag"));
        }else {
          context.push("/order/create", extra: subscriptionDetail);
        }
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.black, // 黑色背景
          shape: BoxShape.circle,
          // border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Image.asset("assets/icon/nav_main.png", scale: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Center(
      child: SizedBox(
        width: 200, // 控制導航列寬度
        height: 70, // 總高度包含突出的按鈕
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // 底部白色膠囊背景
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.home_filled, color: Colors.black),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 40),
                  IconButton(
                    icon: const Icon(Icons.star_border, color: Colors.black),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Main logo button
            Positioned(
                top: 0,
                child: _buildMainLogo(context)
              // ElTooltip(
              //   controller: tooltipController,
              //   content: Text("Schedule a pickup here", softWrap: true, style: TextStyle(color: Colors.white)),
              //   radius: Radius.zero,
              //   showModal: false,
              //   color: Colors.black,
              //   child: _buildMainLogo()
              // ),
            ),
          ],
        ),
      ),
    );
  }
}

