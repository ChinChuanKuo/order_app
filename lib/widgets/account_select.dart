import 'package:flutter/material.dart';
import 'package:order_app/config/config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountSelect extends StatelessWidget {
  final bool signin;
  final void Function()? onTap;

  const AccountSelect({
    Key? key,
    this.signin = true,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          signin
              ? AppLocalizations.of(context)!.dontAccountText
              : AppLocalizations.of(context)!.readyAccountText,
          style: TextStyle(color: Palette.signColor),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            signin
                ? AppLocalizations.of(context)!.signupText
                : AppLocalizations.of(context)!.signinText,
            style: TextStyle(
              color: Color(0xFF6F35A5),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
