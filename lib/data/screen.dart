import 'package:flutter/material.dart';
import 'package:order_app/routers/routers.dart';

final List<List> desktopicons = const [
  [Icons.home, Icons.home_outlined],
  [Icons.account_balance_wallet, Icons.account_balance_wallet_outlined],
  [Icons.settings, Icons.settings_outlined],
  [Icons.calendar_today, Icons.calendar_today_outlined],
  [Icons.menu, Icons.menu_outlined],
];

final List<String> views = [
  Routes.homeRoute,
  Routes.moneyRoute,
  Routes.settingsRoute,
  Routes.calendarRoute,
  Routes.profileRoute,
];

final List<List> mobileicons = const [
  [Icons.home, Icons.home_outlined],
  [Icons.menu, Icons.menu_outlined],
];
