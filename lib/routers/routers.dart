import 'package:flutter/material.dart';
import 'package:order_app/views/views.dart';

class Routers {
  late SigninView signinRoute;
  late HomeView homeRoute;
  late MoneyView moneyRoute;
  late SettingsView settingsRoute;
  late ProfileView profileRoute;
  late PersonalView personalRoute;
  late CalendarView calendarRoute;
}

abstract class Routes {
  static const signinRoute = "/signin";
  static const homeRoute = "/";
  static const moneyRoute = "/money";
  static const settingsRoute = "/settings";
  static const profileRoute = "/profile";
  static const personalRoute = "/personal";
  static const calendarRoute = "/calendar";
}

class RouterGenerator {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.signinRoute:
        return MaterialPageRoute(
          builder: (_) => SigninView(),
        );
      case Routes.homeRoute:
        return MaterialPageRoute(
          builder: (_) => HomeView(),
        );
      case Routes.moneyRoute:
        return MaterialPageRoute(
          builder: (_) => MoneyView(),
        );
      case Routes.settingsRoute:
        return MaterialPageRoute(
          builder: (_) => SettingsView(),
        );
      case Routes.profileRoute:
        return MaterialPageRoute(
          builder: (_) => ProfileView(),
        );
      case Routes.personalRoute:
        return MaterialPageRoute(
          builder: (_) => PersonalView(),
        );
      case Routes.calendarRoute:
        return MaterialPageRoute(
          builder: (_) => CalendarView(),
        );
    }
    return MaterialPageRoute(
      builder: (_) => WrongView(name: settings.name),
    );
  }
}
