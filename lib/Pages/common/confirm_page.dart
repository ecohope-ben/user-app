import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/components/register/action_button.dart';
import 'package:user_app/style.dart';

class SubscriptionConfirmationPage extends StatelessWidget {
  const SubscriptionConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ConfirmationPage(
      iconPath: 'assets/icon/confirmation_subscription.png',
      title: 'Thank you for subscribing!',
      subTitle: 'You have successfully subscribed to our monthly recycle plan.',
      subTitle2: 'Your first recycle bag is on the way, Get Ready!',
      mainButtonTitle: "Manage Subscription",
      mainButtonOnTap: () => context.go("/home")
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
        subTitle: 'Driver will contact you within 24 hours before the scheduled pick up time via your email and phone number.',
        mainButtonTitle: "View Schedule Details",
        mainButtonOnTap: () => context.replace("/order/details", extra: orderId)
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
                  color: Colors.white70,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 60),

              ActionButton(mainButtonTitle, onTap: mainButtonOnTap),
              const SizedBox(height: 20),

              TextButton(
                onPressed: mainButtonOnTap,
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