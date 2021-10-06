import 'package:flutter/material.dart';
import 'package:order_app/config/config.dart';
import 'package:order_app/widgets/widgets.dart';

class CustomSignBar extends StatelessWidget {
  final String text;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextEditingController controller;
  final void Function(String value)? onChanged;

  const CustomSignBar({
    Key? key,
    required this.text,
    this.obscureText = false,
    this.suffixIcon,
    required this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive.isMobile(context)
        ? MobileSignBar(
            text: text,
            obscureText: obscureText,
            suffixIcon: suffixIcon,
            controller: controller,
            onChanged: onChanged,
          )
        : DesktopSignBar(
            text: text,
            obscureText: obscureText,
            suffixIcon: suffixIcon,
            controller: controller,
            onChanged: onChanged,
          );
  }
}

class MobileSignBar extends StatelessWidget {
  final String text;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextEditingController controller;
  final void Function(String value)? onChanged;

  const MobileSignBar({
    Key? key,
    required this.text,
    required this.obscureText,
    this.suffixIcon,
    required this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
      constraints: BoxConstraints(maxWidth: screenSize.width * 0.8),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(31.0)),
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
          hintText: text,
          suffixIcon: suffixIcon,
          border: InputBorder.none,
        ),
        cursorColor: Palette.signColor,
        onChanged: onChanged,
      ),
    );
  }
}

class DesktopSignBar extends StatelessWidget {
  final String text;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextEditingController controller;
  final void Function(String value)? onChanged;

  const DesktopSignBar({
    Key? key,
    required this.text,
    required this.obscureText,
    this.suffixIcon,
    required this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(this.text, style: Fontstyle.info(Colors.black87)),
        SizedBox(height: 3.0),
        Container(
          constraints: BoxConstraints(maxWidth: screenSize.width * 0.8),
          margin: const EdgeInsets.symmetric(vertical: 3.0),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(31.0)),
          child: TextField(
            obscureText: obscureText,
            controller: controller,
            decoration: InputDecoration(
              suffixIcon: suffixIcon,
              border: InputBorder.none,
            ),
            cursorColor: Palette.signColor,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
