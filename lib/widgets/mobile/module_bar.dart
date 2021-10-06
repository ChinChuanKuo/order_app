import 'package:order_app/config/config.dart';
import 'package:order_app/models/models.dart';
import 'package:order_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class MobileModuleBar extends StatelessWidget {
  final bool showBack;
  final void Function()? onPressedBack;
  final String title;
  //final void Function()? onTapProfile;
  final UserInfo? userInfo;
  final void Function()? onPressedNotice;

  const MobileModuleBar({
    Key? key,
    this.showBack = false,
    required this.onPressedBack,
    required this.title,
    //@required this.onTapProfile,
    required this.userInfo,
    required this.onPressedNotice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 65.0,
      centerTitle: false,
      elevation: 0.0,
      flexibleSpace: Container(
          decoration: new BoxDecoration(
              gradient: new LinearGradient(colors: Palette.tileColors))),
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      titleSpacing: showBack ? 0.0 : 18.0,
      leading: showBack
          ? CircularButton(
              icon: Icons.arrow_back_ios_outlined,
              iconColor: Theme.of(context).primaryColor,
              onPressed: onPressedBack,
            )
          : null,
      title: Text(
        title,
        style: Fontstyle.title,
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
