import 'package:flutter/material.dart';
import 'package:order_app/config/config.dart';
import 'package:order_app/widgets/widgets.dart';

class DesktopTabBar extends StatelessWidget {
  final int index;
  final List<List> icons;
  final Function(int index) onTap;

  const DesktopTabBar({
    Key? key,
    required this.index,
    required this.icons,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return Row(
      children: icons
          .asMap()
          .map(
            (i, e) {
              final bool selectedIndex = index == i;
              return MapEntry(
                i,
                Expanded(
                  child: Container(
                    height: isDesktop ? 65.0 : 55.0,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: selectedIndex
                              ? Palette.selectColor
                              : Colors.transparent,
                          width: 3.0,
                        ),
                      ),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12.0),
                      onTap: () => onTap(i),
                      child: Icon(
                        selectedIndex ? e[0] : e[1],
                        color: selectedIndex
                            ? Palette.selectColor
                            : Theme.of(context).primaryColor,
                        size: 28.0,
                      ),
                    ),
                  ),
                ),
              );
            },
          )
          .values
          .toList(),
    );
  }
}
