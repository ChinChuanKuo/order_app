import 'package:flutter/material.dart';
import 'package:order_app/widgets/widgets.dart';

class SignCard extends StatelessWidget {
  final Widget child;

  const SignCard({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width,
      height: screenSize.height,
      child: Responsive.isMobile(context)
          ? MobileSignCard(child: child)
          : DesktopSignCard(child: child),
    );
  }
}

class MobileSignCard extends StatelessWidget {
  final Widget child;

  const MobileSignCard({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: Align(
            alignment: Alignment.topLeft,
            child: Image.asset(
              "assets/images/main_top.png",
              fit: BoxFit.fill,
              width: screenSize.width * 0.325,
            ),
          ),
        ),
        child,
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              "assets/images/signin_bottom.png",
              fit: BoxFit.fill,
              width: screenSize.width * 0.375,
            ),
          ),
        ),
      ],
    );
  }
}

class DesktopSignCard extends StatelessWidget {
  final Widget child;

  const DesktopSignCard({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: Align(
            alignment: Alignment.topLeft,
            child: Image.asset(
              "assets/images/main_top.png",
              fit: BoxFit.fill,
              height: screenSize.height * 0.325,
            ),
          ),
        ),
        child,
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              "assets/images/signin_bottom.png",
              fit: BoxFit.fill,
              height: screenSize.height * 0.375,
            ),
          ),
        ),
      ],
    );
  }
}
