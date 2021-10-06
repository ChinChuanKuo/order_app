import 'package:flutter/material.dart';
import 'package:order_app/config/config.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class RoundedButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final RoundedLoadingButtonController controller;
  final void Function()? onPressed;

  const RoundedButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.controller,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => RoundedLoadingButton(
        elevation: 0.0,
        width: MediaQuery.of(context).size.width,
        borderRadius: 24.0,
        controller: controller,
        color: Palette.orderColor,
        errorColor: Palette.failedColor,
        successColor: Palette.successColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: Parameter.iconSize),
            SizedBox(width: 6.0),
            Text(text, style: Fontstyle.device(Colors.white))
          ],
        ),
        onPressed: onPressed,
      );
}
