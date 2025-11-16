import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/api/profile_api.dart';
import 'package:user_app/routes.dart';
import 'api/index.dart';
import 'api/registration_api.dart';
import 'blocs/bloc_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  await EasyLocalization.ensureInitialized();

  SystemUiOverlayStyle mySystemTheme = SystemUiOverlayStyle.light.copyWith(systemNavigationBarColor: Color(0xFFF4F9FA), systemNavigationBarIconBrightness: Brightness.dark);
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
    String baseUrl = "http://172.19.44.17:3001";
    Api.instance().setBaseUrl(baseUrl);

    return MaterialApp(
      // home: const HomePage(),
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFFF4F9FA),
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(
            surfaceTintColor: Colors.transparent,
            backgroundColor: Color(0xFFF4F9FA), // Set your desired color here
            foregroundColor: Colors.white, // Color for icons and text in the app bar
            // You can also set other properties like elevation, iconTheme, etc.
          ),
          scaffoldBackgroundColor: const Color(0xFFF4F9FA)
      ),
      // Routes are defined in another function
      routes: routes,
      onGenerateRoute: onGenerateRoute,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: Locale("en", "US"),
    );
  }
}


