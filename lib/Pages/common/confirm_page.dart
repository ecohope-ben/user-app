import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/components/register/action_button.dart';
import 'package:user_app/pages/subscription/manage/list.dart';
import 'package:user_app/style.dart';

import '../../routes.dart';

class ChangPlanConfirmationPage extends StatelessWidget {
  const ChangPlanConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ConfirmationPage(
        iconPath: 'assets/icon/confirmation_tick.png',
        title: 'Your subscription is changing to Yearly Plan on 20 Nov 2025.',
        subTitle: 'You will still be able to recycle with your current monthly plan and you can change your mind anytime before this date.',
        // subTitle2: 'Your first recycle bag is on the way, Get Ready!',
        mainButtonTitle: "Manage Subscription",
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
      title: 'Thank you for subscribing!',
      subTitle: 'You have successfully subscribed to our monthly plan. The first ECO HOPE recycling bag is ready for dispatch — Courier may notify you via phone once it’s dispatched.',
      // subTitle2: 'Your first recycle bag is on the way, Get Ready!',
      mainButtonTitle: "Manage Subscription",
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
        title: 'Your Next Recycle Pick Up Schedule is Confirmed!',
        subTitle: 'Pick up time depends on the courier’s schedule and may be subject to change. The courier may call you shortly before arrival.',
        mainButtonTitle: "View Schedule Details",
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
                child: const Text(
                  "Back to Home",
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