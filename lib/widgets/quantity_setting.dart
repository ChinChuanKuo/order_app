import 'package:flutter/material.dart';
import 'package:order_app/config/config.dart';

class QuantitySetting extends StatelessWidget {
  final bool closed;
  final String quantity;
  final void Function()? onTapReduce;
  final void Function()? onTapPlus;

  const QuantitySetting({
    Key? key,
    required this.closed,
    required this.quantity,
    required this.onTapReduce,
    required this.onTapPlus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool showReduce = int.parse(this.quantity) > 0;
    return Row(
      children: [
        iconButton(closed, Icons.remove, showReduce ? onTapReduce : null),
        SizedBox(width: screenSize.width * 0.015),
        Text(this.quantity, style: Fontstyle.info(Colors.black87)),
        SizedBox(width: screenSize.width * 0.015),
        iconButton(closed, Icons.add, onTapPlus),
      ],
    );
  }

  Widget iconButton(bool closed, IconData icon, void Function()? onTap) =>
      GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            color: closed ? Colors.transparent : Palette.inputColor,
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Icon(icon,
              size: 18.0, color: closed ? Palette.disabledColor : Colors.white),
        ),
        onTap: closed ? null : onTap,
      );
}
