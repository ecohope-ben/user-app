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
  String stripePublishableKey = "pk_test_51SWuMM1Jfb61gpEIzzpyPQjT6ac4QsV9G0Q1TztigtuLLNOlvrgkhpCGDY8II6GU41N94tzHBwbyGgLVmzYprQSi00wYbyrMjy";
  Stripe.publishableKey = stripePublishableKey;
  Stripe.merchantIdentifier = 'merchant.com.ecohope.user-app';
  await Stripe.instance.applySettings();

  SystemUiOverlayStyle mySystemTheme = SystemUiOverlayStyle.light.copyWith(systemNavigationBarColor: backgroundColor, systemNavigationBarIconBrightness: Brightness.dark);
  SystemChrome.setSystemUIOverlayStyle(mySystemTheme);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]); // Only allow portrait modes
  String baseUrl = "https://customer-api-int.eco-hope.org";
  FlavorConfig.initialize(
      name: 'int',
      baseUrl: baseUrl,
      isDebug: true
  );

  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en', 'US'), Locale('zh', 'HK')],
        path: 'assets/translations',
        fallbackLocale: Locale('en', 'US'),
        child: MyApp(baseUrl: baseUrl)
    ),
  );
}



