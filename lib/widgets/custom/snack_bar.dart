import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:order_app/config/palette.dart';
import 'package:order_app/widgets/widgets.dart';

class CustomSnackBar {
  static Color snackColor(showSnack) =>
      showSnack ? Palette.successColor : Palette.failedColor;

  static String snackText(showSnack, context) => showSnack
      ? AppLocalizations.of(context)!.successMessageText
      : AppLocalizations.of(context)!.wrongMessageText;

  static showMessage(BuildContext context, Duration duration,
          SnackBarBehavior behavior, Color backgroundColor, String message) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: duration,
        behavior: behavior,
        backgroundColor: backgroundColor,
        width: Responsive.isMobile(context)
            ? null
            : MediaQuery.of(context).size.width * 0.80,
        content: Text(message),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      ));

  static showWidget(BuildContext context, Duration duration,
          SnackBarBehavior behavior, Color backgroundColor, Widget child) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: duration,
        behavior: behavior,
        backgroundColor: backgroundColor,
        width: Responsive.isMobile(context)
            ? null
            : MediaQuery.of(context).size.width * 0.80,
        content: Container(child: child),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      ));
}
