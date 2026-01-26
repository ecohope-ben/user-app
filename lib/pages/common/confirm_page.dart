import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/components/register/action_button.dart';
import 'package:user_app/pages/subscription/manage/list.dart';
import 'package:user_app/style.dart';


class ChangPlanConfirmationPage extends StatelessWidget {
  final String planName;
  const ChangPlanConfirmationPage(this.planName, {super.key});

  @override
  Widget build(BuildContext context) {
    return ConfirmationPage(
        iconPath: 'assets/icon/confirmation_tick.png',
        title: tr("subscription.changing_plan_to") + planName,
        subTitle: tr("subscription.change_plan_confirmation"),
        // subTitle2: 'Your first recycle bag is on the way, Get Ready!',
        mainButtonTitle: tr("subscription.manage_subscription"),
        mainButtonOnTap: () => context.go("/subscription/manage/list", extra: SubscriptionManageTarget.manage)
    );
  }
}

class SubscriptionConfirmationPage extends StatelessWidget {
  const SubscriptionConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ConfirmationPage(
      iconPath: 'assets/icon/confirmation_subscription.png',
      title: tr("subscription.confirmation_info"),
      subTitle: tr("subscription.confirmation_info2"),
      // subTitle2: 'Your first recycle bag is on the way, Get Ready!',
      mainButtonTitle: tr("subscription.manage_subscription"),
      mainButtonOnTap: () => context.go("/subscription/manage/list", extra: SubscriptionManageTarget.manage)
    );
  }
}

class RecycleOrderConfirmationPage extends StatelessWidget {
  final String orderId;
  const RecycleOrderConfirmationPage(this.orderId, {super.key});

  @override
  Widget build(BuildContext context) {
    return ConfirmationPage(
        iconPath: 'assets/icon/confirmation_tick.png',
        title: tr("order.pickup_order_confirmed"),
        subTitle: tr("order.pickup_order_confirmed2"),
        mainButtonTitle: tr("order.view_schedule_detail"),
        mainButtonOnTap: () => context.go("/order/details", extra: orderId)
    );
  }
}

class ConfirmationPage extends StatelessWidget {
  final String iconPath;
  final String title;
  final String subTitle;
  final String? subTitle2;
  final String mainButtonTitle;
  final VoidCallback mainButtonOnTap;
  const ConfirmationPage({super.key, required this.iconPath, required this.title, required this.subTitle, this.subTitle2, required this.mainButtonTitle, required this.mainButtonOnTap});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: mainPurple,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(iconPath, width: 120),
              const SizedBox(height: 40),

              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 20),

              // 3. 副標題/說明文字
              Text(
                subTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 60),

              ActionButton(mainButtonTitle, onTap: mainButtonOnTap),
              const SizedBox(height: 20),

              TextButton(
                onPressed: () => context.go("/home"),
                child: Text(
                  tr("back_to_home"),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}