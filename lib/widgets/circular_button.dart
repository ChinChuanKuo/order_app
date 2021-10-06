import 'package:order_app/config/config.dart';
import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final Color? boxColor;
  final IconData icon;
  final Color? iconColor;
  final bool? disabled;
  final void Function()? onPressed;

  const CircularButton({
    Key? key,
    this.boxColor = Colors.transparent,
    required this.icon,
    this.iconColor = Palette.disabledColor,
    this.disabled = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        padding: const EdgeInsets.all(8.0),
        icon: Icon(this.icon),
        iconSize: Parameter.iconSize,
        hoverColor: Colors.transparent,
        color: this.iconColor,
        onPressed: disabled! ? null : this.onPressed,
      ),
    );
  }
}
