import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/pages/guest/login/index.dart';
import 'package:user_app/pages/guest/register/index.dart';
import 'package:user_app/pages/home_page.dart';

import 'blocs/login_cubit.dart';
import 'pages/guest/login/email_verify.dart';

final router = GoRouter(
  routes: [
    ShellRoute(
        builder: (context, state, child) => BlocProvider(
          create: (_) => LoginCubit(),              // 這裡建立一次就夠了
          child: child,                             // 所有子路由都會繼承到
        ),
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginIndex(),
          // builder: (context, state) => BlocProvider(
          //   create: (_) => LoginCubit(),
          //   child: const LoginIndex(),
          // ),
        ),
        GoRoute(
          path: '/login/verify',
          builder: (context, state) => const LoginEmailVerification(),
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
        )
      ]
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => HomePage(),
    ),


  ],
);


typedef RouteWidgetBuilder = Widget Function(
    BuildContext context, RouteArguments arguments);

// Map<String, WidgetBuilder> routes = {
//   "/": (context) => LoginIndex(),
//   "/register": (context) => RegisterIndex(),
//   "/login/verify": (context) => LoginEmailVerification(),
//
//   "/login": (context) {
//     final loginCubit = ModalRoute.of(context)!.settings.arguments as LoginCubit;
//     return BlocProvider.value(
//       value: loginCubit,
//       child: const LoginIndex(),
//     );
//   },
//
//   "/home": (context) => HomePage(),
//
// };

Map<String, RouteWidgetBuilder> routesWithArgs = {

  // "/user/common_order": (context, args) => CommonOrderPage(args as CommonOrderPageArgument),
};

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  final Function builder = routesWithArgs[settings.name] as Function;
    return MaterialPageRoute(
        builder: (context) {
          return builder(context, settings.arguments);
        }, settings: settings);
}


// extension NavigatorBlocExtension on BuildContext {
//   Future<T?> pushNamedWithBloc<T extends Object?>(
//       String routeName,
//       BlocBase bloc,
//       ) {
//     return Navigator.of(this).pushNamed<T>(
//       routeName,
//       arguments: bloc,
//     );
//   }
// }

abstract class RouteArguments {}