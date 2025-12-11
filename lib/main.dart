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

  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en', 'US'), Locale('zh', 'HK')],
        path: 'assets/translations',
        fallbackLocale: Locale('en', 'US'),
        child: MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // String baseUrl = "http://192.168.50.237:3001";
    // String baseUrl = "http://172.19.44.17:3001";
    String baseUrl = "https://customer-int.eco-hope.org";
    Api.instance().setBaseUrl(baseUrl)
        .addInterceptor(AuthorizationInterceptor())
        .addInterceptor(ApiLocalizationInterceptor(context))
        .addInterceptor(RefreshTokenInterceptor());

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          progressIndicatorTheme: ProgressIndicatorThemeData(
            color: Colors.black
          ),
          snackBarTheme: SnackBarThemeData(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
          inputDecorationTheme: InputDecorationTheme(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: purpleUnderline,
              ),
              borderRadius: BorderRadius.zero
            ),
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: backgroundColor,
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(
            surfaceTintColor: Colors.transparent,
            backgroundColor: backgroundColor, // Set your desired color here
            foregroundColor: Colors.white, // Color for icons and text in the app bar
            // You can also set other properties like elevation, iconTheme, etc.
          ),
          scaffoldBackgroundColor: backgroundColor
      ),
      // Routes are defined in another function
      routerConfig: router,
      // routes: routes,
      // onGenerateRoute: onGenerateRoute,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: Locale("en", "US"),
    );
  }
}


