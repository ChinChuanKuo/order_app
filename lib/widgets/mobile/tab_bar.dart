import 'package:order_app/config/config.dart';
import 'package:order_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class MobileTabBar extends StatelessWidget {
  final int index;
  final List<List> icons;
  final Function(int index) onPressed;

  const MobileTabBar({
    Key? key,
    required this.index,
    required this.icons,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool firstIndex = index == 0, secondIndex = index == 4;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CircularButton(
          icon: firstIndex ? icons[0][0] : icons[0][1],
          //iconSize: 28.0,
          iconColor: firstIndex ? Palette.orderColor : Palette.disabledColor,
          onPressed: () => onPressed(0),
        ),
        SizedBox(),
        CircularButton(
          icon: secondIndex ? icons[1][0] : icons[1][1],
          //iconSize: 28.0,
          iconColor: secondIndex ? Palette.orderColor : Palette.disabledColor,
          onPressed: () => onPressed(4),
        ),
      ],
    );
  }
}
