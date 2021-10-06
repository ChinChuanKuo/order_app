import 'package:order_app/config/config.dart';
import 'package:order_app/models/models.dart';
import 'package:order_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class TabletModuleBar extends StatelessWidget {
  final bool showBack;
  final void Function()? onPressedBack;
  final String title;
  //final void Function()? onTapProfile;
  final UserInfo? userInfo;
  final void Function()? onPressedNotice;
  final Widget child;

  const TabletModuleBar({
    Key? key,
    this.showBack = false,
    required this.onPressedBack,
    required this.title,
    //@required this.onTapProfile,
    required this.userInfo,
    required this.onPressedNotice,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return AppBar(
      toolbarHeight: 65.0,
      centerTitle: true,
      elevation: 0.0,
      flexibleSpace: Container(
          decoration: new BoxDecoration(
              gradient: new LinearGradient(colors: Palette.tileColors))),
      backgroundColor: Colors.transparent,
      leadingWidth: 230.0,
      leading: Row(
        children: [
          SizedBox(width: showBack ? 12.0 : 18.0),
          showBack
              ? CircularButton(
                  icon: Icons.arrow_back_ios_outlined,
                  iconColor: Theme.of(context).primaryColor,
                  onPressed: onPressedBack,
                )
              : SizedBox.shrink(),
          Text(
            title,
            style: Fontstyle.title,
          )
        ],
      ),
      title: Container(
        constraints: BoxConstraints(maxWidth: screenSize.width * 0.45),
        child: child,
      ),
      actions: [
        FlipClock(),
        SizedBox(width: 12.0),
        CircularButton(
          icon: Icons.notifications_outlined,
          iconColor: Theme.of(context).primaryColor,
          onPressed: onPressedNotice,
        ),
        SizedBox(width: 18.0),
      ],
    );
  }
}
