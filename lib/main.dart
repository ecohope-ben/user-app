import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/routes.dart';
import 'api/registration_api_service.dart';
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
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<RegistrationApiService>(
          create: (context) => RegistrationApiService(),
        ),
      ],
      child: MaterialApp(
        // home: const HomePage(),
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
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
      ),
    );
  }
}


