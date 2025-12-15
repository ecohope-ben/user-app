import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:user_app/routes.dart';
import 'package:user_app/style.dart';

import 'api/index.dart';
import 'api/interceptors/auth.dart';
import 'api/interceptors/localization.dart';
import 'api/interceptors/refresh_token_interceptor.dart';
class MyApp extends StatelessWidget {

  final String baseUrl;
  const MyApp({required this.baseUrl, super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Api.instance().setBaseUrl(baseUrl)
        .addInterceptor(AuthorizationInterceptor())
        .addInterceptor(ApiLocalizationInterceptor(context))
        .addInterceptor(RefreshTokenInterceptor());

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
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
      locale: context.locale,
    );
  }
}