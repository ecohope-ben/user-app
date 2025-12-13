import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/blocs/subscription_cubit.dart';
import 'package:user_app/pages/common/confirm_page.dart';
import 'package:user_app/pages/common/how_it_works.dart';
import 'package:user_app/pages/common/recycling_guide.dart';
import 'package:user_app/pages/guest/login/index.dart';
import 'package:user_app/pages/guest/login/onboarding_profile.dart';
import 'package:user_app/pages/guest/register/index.dart';
import 'package:user_app/pages/guest/register/steps/create_profile.dart';
import 'package:user_app/pages/guest/welcome/index.dart';
import 'package:user_app/pages/guest/welcome/page1.dart';
import 'package:user_app/pages/history/order/index.dart';
import 'package:user_app/pages/history/transaction/detail.dart';
import 'package:user_app/pages/history/transaction/index.dart';
import 'package:user_app/pages/home.dart';
import 'package:user_app/pages/order/order_details.dart';
import 'package:user_app/pages/order/recycle_order.dart';
import 'package:user_app/pages/setting/index.dart';
import 'package:user_app/pages/subscription/list.dart';
import 'package:user_app/pages/subscription/manage/change_address.dart';
import 'package:user_app/pages/subscription/manage/change_payment_method.dart';
import 'package:user_app/pages/subscription/manage/change_plan.dart';
import 'package:user_app/pages/subscription/manage/detail.dart';
import 'package:user_app/pages/subscription/manage/list.dart';
import 'package:user_app/pages/subscription/signup.dart';
import 'package:user_app/pages/launch.dart';

import 'blocs/login_cubit.dart';
import 'models/payment_models.dart';
import 'models/subscription_models.dart';
import 'pages/guest/login/email_verify.dart';
import 'pages/guest/welcome/get_start.dart';
import 'pages/profile/edit.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LaunchPage()),
    GoRoute(path: '/welcome', builder: (context, state) => const IntroPage()),
    GoRoute(path: '/get_start', builder: (context, state) => const GetStartPage()),

    GoRoute(path: '/how_it_works', builder: (context, state) => const HowItWorksPage()),
    GoRoute(path: '/recycling_guide', builder: (context, state) => const RecyclingGuidePage()),
    GoRoute(path: '/settings', builder: (context, state) => SettingsPage(state.extra as SubscriptionListLoaded)),
    GoRoute(path: '/register', builder: (context, state) => RegisterIndex()),
    ShellRoute(
        builder: (context, state, child) => BlocProvider(
          create: (_) => LoginCubit(),
          child: child,
        ),
        routes: [
          GoRoute(
              path: '/login', builder: (context, state) => const LoginIndex(),
              routes: [
                GoRoute(path: 'verify', builder: (context, state) => const LoginEmailVerification()),
              ]
          ),
        ]
    ),

    GoRoute(path: '/onboarding_profile', builder: (context, state) => OnboardingProfile()),
    GoRoute(path: '/home', builder: (context, state) => HomePage()),
    GoRoute(path: '/subscription/manage/list', builder: (context, state) => SubscriptionManageListPage(state.extra as SubscriptionManageTarget)),
    GoRoute(path: '/subscription/list', builder: (context, state) => SubscriptionListPage()),

    // Subscription
    GoRoute(
      path: "/subscription", builder: (context, state) => Container(),
      routes: [
        GoRoute(path: 'list', builder: (context, state) => SubscriptionListPage()),
        GoRoute(path: 'confirmation', builder: (context, state) => SubscriptionConfirmationPage()),
        GoRoute(path: 'manage/list', builder: (context, state) => SubscriptionManageListPage(state.extra as SubscriptionManageTarget)),
        GoRoute(path: 'manage/change_address', builder: (context, state) => SubscriptionChangeAddress(state.extra as SubscriptionDetail)),
        GoRoute(path: 'manage/change_payment_method', builder: (context, state) => SubscriptionChangePaymentMethod(subscriptionId: state.extra as String)),
        GoRoute(path: 'manage/detail', builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final plan = extra['plan'] as PlanListItem;
          final features = extra['features'] as List<String>;
          final subscriptionId = extra['subscriptionId'] as String;
          return SubscriptionManageDetail(plan: plan, features: features, subscriptionId: subscriptionId);
        }),
        GoRoute(path: 'manage/change_plan', builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final plan = extra['plan'] as PlanListItem;
          final features = extra['features'] as List<String>;
          final subscriptionId = extra['subscriptionId'] as String;
          return SubscriptionPlanChange(plan: plan, features: features, subscriptionId: subscriptionId);
        }),
        GoRoute(
            path: 'signup',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>;
              final plan = extra['plan'] as PlanListItem;
              final features = extra['features'] as List<String>;
              return SubscriptionSignUp(plan: plan, features: features);
            }
        ),
      ]
    ),



    // Order
    GoRoute(path: '/order/create', builder: (context, state) => SchedulePickUpOrderPage(state.extra as SubscriptionDetail)),
    GoRoute(path: '/order/history', builder: (context, state) => RecycleOrderHistoryPage()),
    GoRoute(path: '/order/details', builder: (context, state) => PickUpOrderDetailsPage(state.extra as String)),
    GoRoute(path: '/order/confirmation', builder: (context, state) => RecycleOrderConfirmationPage(state.extra as String)),

    GoRoute(path: '/payments/history', builder: (context, state) => TransactionHistoryPage()),
    GoRoute(path: '/payment/details', builder: (context, state) => TransactionHistoryDetailsPage(state.extra as PaymentListItem)),

    GoRoute(path: '/profile/edit', builder: (context, state) => EditProfilePage()),
  ],
);

// In a widget where you have access to the BuildContext
void printRouteStack(BuildContext context) {
  final GoRouter goRouter = GoRouter.of(context);
  final matches = goRouter.routerDelegate.currentConfiguration.matches;

  print('--- GoRouter Route Stack ---');
  for (int i = 0; i < matches.length; i++) {
    final match = matches[i];
    print('  ${i + 1}: ${match.matchedLocation}');
  }
  print('--------------------------');
}

// builder: (context, state) {
//   final loginCubit = state.extra as LoginCubit?;
//   if (loginCubit == null) {
//     return const LoginEmailVerification(); // 或顯示錯誤頁
//   }
//   return BlocProvider.value(
//     value: loginCubit,
//     child: const LoginEmailVerification(),
//   );
// },