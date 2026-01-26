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
  String stripePublishableKey = "pk_test_51SF7RP03YTV8tfWqh3DIh2mEjAb8IMXGAbUkDGIghvcUrGI4xoBCMz2yFaScTbe1FQuNYzftYLtTsQDPsEJF7wzp00YL9o8FMw";
  String baseUrl = "https://customer-api-dev.eco-hope.org";
  Stripe.publishableKey = stripePublishableKey;
  await Stripe.instance.applySettings();

  SystemUiOverlayStyle mySystemTheme = SystemUiOverlayStyle.light.copyWith(systemNavigationBarColor: backgroundColor, systemNavigationBarIconBrightness: Brightness.dark);
  SystemChrome.setSystemUIOverlayStyle(mySystemTheme);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]); // Only allow portrait modes
  FlavorConfig.initialize(
    name: 'dev',
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


