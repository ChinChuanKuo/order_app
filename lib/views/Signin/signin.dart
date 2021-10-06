import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:order_app/apis/apis.dart';
import 'package:order_app/config/config.dart';
import 'package:order_app/source/source.dart';
import 'package:order_app/routers/routers.dart';
import 'package:order_app/widgets/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class SigninView extends StatefulWidget {
  const SigninView({
    Key? key,
  }) : super(key: key);

  @override
  _SigninViewState createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  late bool obscureText;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late RoundedLoadingButtonController controller;

  @override
  void initState() {
    obscureText = true;
    emailController = new TextEditingController();
    passwordController = new TextEditingController();
    controller = new RoundedLoadingButtonController();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void onPressedWord() => setState(() => obscureText = !obscureText);

  void onPressedSign() async {
    final String email = emailController.text,
        password = passwordController.text;
    if (email.isNotEmpty && password.isNotEmpty) {
      final response = await http
          .post(Uri.http(APi.signin[0]["url"], APi.signin[0]["route"]), body: {
        "signinfo": json.encode(SignSource.initialState(email, password)),
        "deviceinfo": json.encode(await DeviceSource.initialState()),
      }, headers: {
        "Accept": "application/json"
      });
      final statusCode = response.statusCode == 200;
      if (statusCode) {
        controller.success();
        ClientSource.settingState(json.decode(response.body));
        new Timer(
            new Duration(seconds: 3),
            () => Navigator.of(context).pushNamedAndRemoveUntil(
                Routes.homeRoute, (Route<dynamic> route) => false));
      } else {
        controller.error();
        new Timer(new Duration(seconds: 5), () => controller.reset());
        CustomSnackBar.showWidget(
          context,
          new Duration(seconds: 5),
          Responsive.isMobile(context)
              ? SnackBarBehavior.fixed
              : SnackBarBehavior.floating,
          CustomSnackBar.snackColor(statusCode),
          Row(children: [
            Icon(Icons.check, color: Theme.of(context).primaryColor),
            SizedBox(width: 8.0),
            Text(CustomSnackBar.snackText(statusCode, context))
          ]),
        );
      }
    } else
      controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return Scaffold(
      body: imageGround(
        isDesktop,
        SingleChildScrollView(
          child: Responsive(
            mobile: MobileSigninView(
              obscureText: obscureText,
              emailController: emailController,
              passwordController: passwordController,
              controller: controller,
              onPressedWord: onPressedWord,
              onPressed: onPressedSign,
            ),
            desktop: DesktopSigninView(
              obscureText: obscureText,
              emailController: emailController,
              passwordController: passwordController,
              controller: controller,
              onPressedWord: onPressedWord,
              onPressed: onPressedSign,
            ),
          ),
        ),
      ),
    );
  }

  Widget imageGround(bool isDesktop, Widget child) => Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(isDesktop
                ? "images/sign_desktop.png"
                : "images/sign_mobile.png"),
            fit: BoxFit.cover,
          ),
        ),
        alignment: isDesktop ? Alignment.center : Alignment.centerLeft,
        child: child,
      );
}

class MobileSigninView extends StatelessWidget {
  final bool obscureText;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final RoundedLoadingButtonController controller;
  final void Function() onPressedWord;
  final void Function() onPressed;

  const MobileSigninView({
    Key? key,
    required this.obscureText,
    required this.emailController,
    required this.passwordController,
    required this.controller,
    required this.onPressedWord,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 48.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.flytechTile,
            style: GoogleFonts.dmSans(
              textStyle: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
              ),
            ),
          ),
          SizedBox(height: screenSize.height * 0.005),
          Text(
            "Food",
            style: GoogleFonts.dmSans(
              textStyle: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 35.0,
              ),
            ),
          ),
          Text(
            "Ordering",
            style: GoogleFonts.dmSans(
              textStyle: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 35.0,
              ),
            ),
          ),
          Text(
            "System",
            style: GoogleFonts.dmSans(
              textStyle: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 35.0,
              ),
            ),
          ),
          SizedBox(height: screenSize.height * 0.035),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: Text(
              DateFormat('yyyy / MM / dd EEEE').format(DateTime.now()),
              style: GoogleFonts.dmSans(
                textStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          SizedBox(height: screenSize.height * 0.005),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: FlipClock(maxWidth: 16.5),
          ),
          SizedBox(height: screenSize.height * 0.02),
          CustomSignBar(
            text: AppLocalizations.of(context)!.emailText,
            controller: emailController,
          ),
          CustomSignBar(
            text: AppLocalizations.of(context)!.passwordText,
            obscureText: obscureText,
            suffixIcon: IconButton(
              icon: Icon(
                obscureText
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Palette.signColor,
              ),
              onPressed: onPressedWord,
            ),
            controller: passwordController,
          ),
          SizedBox(height: screenSize.height * 0.005),
          Row(
            children: [
              Expanded(child: SizedBox.shrink()),
              Text(
                AppLocalizations.of(context)!.dontAccountText,
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(color: Palette.signColor),
                ),
              ),
              Text(
                AppLocalizations.of(context)!.signupText,
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    color: Palette.orderColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 18.0),
            ],
          ),
          SizedBox(height: screenSize.height * 0.025),
          CustomSignButton(
            text: AppLocalizations.of(context)!
                .signinTile
                .toString()
                .toUpperCase(),
            controller: controller,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}

class DesktopSigninView extends StatelessWidget {
  final bool obscureText;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final RoundedLoadingButtonController controller;
  final void Function() onPressedWord;
  final void Function() onPressed;

  const DesktopSigninView({
    Key? key,
    required this.obscureText,
    required this.emailController,
    required this.passwordController,
    required this.controller,
    required this.onPressedWord,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
      constraints: BoxConstraints(maxWidth: 1036.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.flytechTile,
                style: GoogleFonts.dmSans(
                  textStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                  ),
                ),
              ),
              SizedBox(height: 6.0),
              Text(
                "Food",
                style: GoogleFonts.dmSans(
                  textStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 35.0,
                  ),
                ),
              ),
              Text(
                "Ordering",
                style: GoogleFonts.dmSans(
                  textStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 35.0,
                  ),
                ),
              ),
              Text(
                "System",
                style: GoogleFonts.dmSans(
                  textStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 35.0,
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Text(
                  DateFormat('yyyy/MM/dd EEEE').format(DateTime.now()),
                  style: GoogleFonts.dmSans(
                    textStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 14.5,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: FlipClock(maxWidth: 16.5),
              ),
            ],
          ),
          Container(
            constraints: BoxConstraints(maxWidth: 526.0, maxHeight: 617.0),
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.8),
                borderRadius: BorderRadius.circular(14.0)),
            padding:
                const EdgeInsets.symmetric(horizontal: 40.0, vertical: 48.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.welcomeText} !',
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 25.0,
                          ),
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.075),
                      CustomSignBar(
                          text: AppLocalizations.of(context)!.emailText,
                          controller: emailController),
                      SizedBox(height: screenSize.height * 0.025),
                      CustomSignBar(
                        text: AppLocalizations.of(context)!.passwordText,
                        obscureText: obscureText,
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureText
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Palette.signColor,
                          ),
                          onPressed: onPressedWord,
                        ),
                        controller: passwordController,
                      ),
                      SizedBox(height: screenSize.height * 0.025),
                      Row(
                        children: [
                          Expanded(child: SizedBox.shrink()),
                          Text(
                            AppLocalizations.of(context)!.dontAccountText,
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(color: Palette.signColor),
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context)!.signupText,
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                color: Palette.orderColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                CustomSignButton(
                  text: AppLocalizations.of(context)!
                      .signinTile
                      .toString()
                      .toUpperCase(),
                  controller: controller,
                  onPressed: onPressed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
