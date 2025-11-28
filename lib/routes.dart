import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/pages/guest/login/index.dart';
import 'package:user_app/pages/guest/register/index.dart';
import 'package:user_app/pages/home.dart';
import 'package:user_app/pages/subscription/list.dart';
import 'package:user_app/pages/subscription/signup.dart';
import 'package:user_app/pages/launch.dart';

import 'blocs/login_cubit.dart';
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
    GoRoute(path: '/subscription/list', builder: (context, state) => SubscriptionListPage()),
    GoRoute(path: '/subscription/signup', builder: (context, state) => SubscriptionSignUp()),
  ],
);

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