import 'package:order_app/config/config.dart';
import 'package:order_app/data/data.dart';
import 'package:order_app/models/models.dart';
import 'package:order_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class DesktopModuleBar extends StatefulWidget {
  final bool showBack;
  final void Function()? onPressedBack;
  final String title;
  final UserInfo? userInfo;
  final void Function()? onPressedNotice;
  final Widget child;

  const DesktopModuleBar({
    Key? key,
    this.showBack = false,
    required this.onPressedBack,
    required this.title,
    required this.userInfo,
    required this.onPressedNotice,
    required this.child,
    //@required this.onFocusChange,
  }) : super(key: key);

  @override
  _DesktopModuleBarState createState() => _DesktopModuleBarState();
}

class _DesktopModuleBarState extends State<DesktopModuleBar> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double iconLen = desktopicons.length * 120.0,
        maxWidth = screenSize.width * 0.45 >= iconLen
            ? iconLen
            : screenSize.width * 0.45;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      decoration: new BoxDecoration(
          gradient: new LinearGradient(colors: Palette.tileColors)),
      height: 65.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: this.widget.showBack
                  ? EdgeInsets.only(left: 8.0)
                  : EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                children: [
                  this.widget.showBack
                      ? CircularButton(
                          icon: Icons.arrow_back_ios_outlined,
                          iconColor: Theme.of(context).primaryColor,
                          onPressed: this.widget.onPressedBack,
                        )
                      : SizedBox.shrink(),
                  Text(
                    this.widget.title,
                    style: Fontstyle.title,
                  ),
                ],
              ),
            ),
          ),
          Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            height: double.infinity,
            child: widget.child,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlipClock(),
                SizedBox(width: 15.0),
                CircularButton(
                  icon: Icons.notifications_outlined,
                  iconColor: Theme.of(context).primaryColor,
                  onPressed: widget.onPressedNotice,
                ),
                SizedBox(width: 15.0),
                // ignore: missing_required_param
                UserCard(userinfo: widget.userInfo, showName: true),
                SizedBox(width: 7.5),
              ],
            ),
          )
        ],
      ),
    );
  }
}
