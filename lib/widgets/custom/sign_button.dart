import 'package:flutter/material.dart';
import 'package:order_app/config/config.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class CustomSignButton extends StatelessWidget {
  final String text;
  final Color color;
  final RoundedLoadingButtonController controller;
  final void Function() onPressed;

  const CustomSignButton({
    Key? key,
    required this.text,
    this.color = Colors.white,
    required this.controller,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundedLoadingButton(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 64.0,
      borderRadius: 24.0,
      color: Palette.orderColor,
      errorColor: Palette.failedColor,
      successColor: Palette.successColor,
      controller: controller,
      child: Text(text, style: Fontstyle.subinfo(color)),
      onPressed: onPressed,
    );
  }
}
