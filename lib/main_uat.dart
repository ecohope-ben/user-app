import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:user_app/style.dart';
import 'app.dart';
import 'blocs/bloc_observer.dart';
import 'flavor.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  await EasyLocalization.ensureInitialized();
  // setup Strip
  // String stripePublishableKey = "pk_test_51SWuMM1Jfb61gpEIzzpyPQjT6ac4QsV9G0Q1TztigtuLLNOlvrgkhpCGDY8II6GU41N94tzHBwbyGgLVmzYprQSi00wYbyrMjy";
  String stripePublishableKey = "pk_live_51S3vvt1lC88bC1PzKnSsK0RDwYGxS8Y5jCBb4FrwDSDD5Sg39P3rkxoe1RuZsQM4ZDYf80o7v5mG2Y0h2B7s0xg00091zssxaz";
  Stripe.merchantIdentifier = 'merchant.com.ecohope.user-app';
  Stripe.publishableKey = stripePublishableKey;
  await Stripe.instance.applySettings();
  String baseUrl = "https://customer-api-uat.eco-hope.org";

  SystemUiOverlayStyle mySystemTheme = SystemUiOverlayStyle.light.copyWith(systemNavigationBarColor: backgroundColor, systemNavigationBarIconBrightness: Brightness.dark);
  SystemChrome.setSystemUIOverlayStyle(mySystemTheme);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]); // Only allow portrait modes

  FlavorConfig.initialize(
    name: 'prod',
    baseUrl: baseUrl,
    isDebug: false
  );

  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en', 'US'), Locale('zh', 'HK')],
        path: 'assets/translations',
        fallbackLocale: Locale('en', 'US'),

        // String baseUrl = "https://customer-int.eco-hope.org";
        child: MyApp(baseUrl: baseUrl)
    ),
  );
}


