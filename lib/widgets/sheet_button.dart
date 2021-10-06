import 'package:flutter/material.dart';
import 'package:order_app/widgets/widgets.dart';

class SheetButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function()? onPressed;

  const SheetButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Responsive.isMobile(context)
      ? MobileButton(
          icon: icon,
          text: text,
          onPressed: onPressed,
        )
      : DesktopButton(
          icon: icon,
          text: text,
          onPressed: onPressed,
        );
}

class MobileButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function()? onPressed;

  const MobileButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ignore: deprecated_member_use
          FlatButton.icon(
            height: 60.0,
            minWidth: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            icon: Icon(icon),
            label: Text(text),
            onPressed: onPressed,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        ],
      );
}

class DesktopButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function()? onPressed;

  const DesktopButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  // ignore: deprecated_member_use
  Widget build(BuildContext context) => FlatButton.icon(
        height: 60.0,
        minWidth: MediaQuery.of(context).size.width,
        icon: Icon(icon),
        label: Text(text),
        onPressed: onPressed,
      );
}
