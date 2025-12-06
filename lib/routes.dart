import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/pages/common/confirm_page.dart';
import 'package:user_app/pages/guest/login/index.dart';
import 'package:user_app/pages/guest/register/index.dart';
import 'package:user_app/pages/home.dart';
import 'package:user_app/pages/order/order_details.dart';
import 'package:user_app/pages/order/recycle_order.dart';
import 'package:user_app/pages/subscription/list.dart';
import 'package:user_app/pages/subscription/signup.dart';
import 'package:user_app/pages/launch.dart';

import 'blocs/login_cubit.dart';
import 'models/subscription_models.dart';
import 'pages/guest/login/email_verify.dart';
import 'pages/guest/welcome/get_start.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LaunchPage()),
    GoRoute(path: '/welcome', builder: (context, state) => const IntroPage()),
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
                GoRoute(path: 'verify', builder: (context, state) => const LoginEmailVerification())
              ]
          ),
        ]
    ),
    GoRoute(path: '/home', builder: (context, state) => HomePage()),

    // Subscription
    GoRoute(path: '/subscription/list', builder: (context, state) => SubscriptionListPage()),
    GoRoute(
        path: '/subscription/signup',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final plan = extra['plan'] as PlanListItem;
          final features = extra['features'] as List<String>;
          return SubscriptionSignUp(plan: plan, features: features);
        }
    ),


    // Order
    GoRoute(path: '/order/create', builder: (context, state) => SchedulePickUpOrderPage(state.extra as SubscriptionDetail)),
    GoRoute(path: '/order/details', builder: (context, state) => PickUpOrderDetailsPage(state.extra as String)),
    GoRoute(path: '/order/confirmation', builder: (context, state) => RecycleOrderConfirmationPage(state.extra as String)),
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