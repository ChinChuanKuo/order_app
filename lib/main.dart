import 'package:flutter/material.dart';
import 'package:order_app/config/config.dart';
import 'package:order_app/l10n/app_localization.dart';
import 'package:order_app/routers/routers.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: Palette.title,
        localizationsDelegates: AppLocalization.localizationsDelegates,
        supportedLocales: AppLocalization.supportedLocales,
        theme: ThemeData(
          primaryColor: Colors.white,
          accentColor: Color(0xFFFEF9EB),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.homeRoute,
        onGenerateRoute: RouterGenerator.onGenerateRoute,
      );
}
