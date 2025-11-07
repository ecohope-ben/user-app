import 'package:flutter/material.dart';
import 'package:user_app/main.dart';
import 'package:user_app/pages/guest/register/index.dart';


typedef RouteWidgetBuilder = Widget Function(
    BuildContext context, RouteArguments arguments);

Map<String, WidgetBuilder> routes = {
  "/": (context) => RegisterIndex(),

};

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

abstract class RouteArguments {}