import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:user_app/api/endpoints/profile_api.dart';
import 'package:user_app/routes.dart';
import 'package:user_app/style.dart';
import 'api/index.dart';
import 'api/interceptors/auth.dart';
import 'api/interceptors/localization.dart';
import 'api/interceptors/refresh_token_interceptor.dart';
import 'api/endpoints/registration_api.dart';
import 'app.dart';
import 'blocs/bloc_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  await EasyLocalization.ensureInitialized();
  // setup Strip
  String stripePublishableKey = "pk_test_51SWuMM1Jfb61gpEIzzpyPQjT6ac4QsV9G0Q1TztigtuLLNOlvrgkhpCGDY8II6GU41N94tzHBwbyGgLVmzYprQSi00wYbyrMjy";
  Stripe.publishableKey = stripePublishableKey;
  await Stripe.instance.applySettings();

  SystemUiOverlayStyle mySystemTheme = SystemUiOverlayStyle.light.copyWith(systemNavigationBarColor: backgroundColor, systemNavigationBarIconBrightness: Brightness.dark);
  SystemChrome.setSystemUIOverlayStyle(mySystemTheme);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]); // Only allow portrait modes
  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en', 'US'), Locale('zh', 'HK')],
        path: 'assets/translations',
        fallbackLocale: Locale('en', 'US'),
        child: MyApp(baseUrl: "https://customer-api-int.eco-hope.org")
    ),
  );
}



