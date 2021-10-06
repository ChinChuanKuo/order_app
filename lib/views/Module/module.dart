import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:order_app/apis/apis.dart';
import 'package:order_app/config/config.dart';
import 'package:order_app/data/data.dart';
import 'package:order_app/source/source.dart';
import 'package:order_app/models/models.dart';
import 'package:order_app/routers/routers.dart';
import 'package:order_app/widgets/widgets.dart';

class Module extends StatefulWidget {
  final int selectedIndex;
  final String title;
  final Widget body;
  final Widget? floatingActionButton;
  final void Function()? onPressed;

  const Module({
    Key? key,
    this.selectedIndex = -1,
    this.title = Palette.title,
    required this.body,
    this.floatingActionButton,
    this.onPressed,
  }) : super(key: key);

  @override
  _ModuleState createState() => _ModuleState();
}

class _ModuleState extends State<Module> {
  late UserInfo? currentUser;

  @override
  void initState() {
    currentUser = null;
    initialState();
    // TODO: implement initState
    super.initState();
  }

  void initialState() => fetchUserInfo();

  UserInfo parseInfo(String responseBody) =>
      UserInfo.fromJson(json.decode(responseBody));

  Future fetchUserInfo() async {
    final response = await http.get(
        Uri.http(APi.user[0]["url"], APi.user[0]["route"], {
          "clientinfo": json.encode(await ClientSource.initialState()),
          "deviceinfo": json.encode(await DeviceSource.initialState()),
        }),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200)
      setState(() => currentUser = parseInfo(response.body));
    else {
      await ClientSource.removeState();
      Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.signinRoute, (Route<dynamic> route) => false);
    }
  }

  void onMoveTabBar(int index) => Navigator.of(context)
      .pushNamedAndRemoveUntil(views[index], (Route<dynamic> route) => false);

  void onPressedMobileNotice() => Navigator.push(
      context, MaterialPageRoute(builder: (context) => Notifications()));

  void onPressedDesktopNotice() => print("notification");

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final bool isDesktop = Responsive.isDesktop(context);
    final Size screenSize = MediaQuery.of(context).size;
    final bool showIndex = this.widget.selectedIndex == -1;
    return DefaultTabController(
      length: desktopicons.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(screenSize.width, 65.0),
          child: isMobile
              ? MobileModuleBar(
                  showBack: showIndex,
                  onPressedBack: this.widget.onPressed,
                  title: this.widget.title,
                  userInfo: currentUser,
                  //onTapProfile: onTapMobileProfile,
                  onPressedNotice: onPressedMobileNotice,
                )
              : !isDesktop
                  ? TabletModuleBar(
                      showBack: showIndex,
                      onPressedBack: this.widget.onPressed,
                      title: this.widget.title,
                      userInfo: currentUser,
                      //onTapProfile: onTapMobileProfile,
                      onPressedNotice: onPressedMobileNotice,
                      child: DesktopTabBar(
                        index: this.widget.selectedIndex,
                        onTap: onMoveTabBar,
                        icons: desktopicons,
                      ),
                    )
                  : DesktopModuleBar(
                      showBack: showIndex,
                      onPressedBack: this.widget.onPressed,
                      title: this.widget.title,
                      userInfo: currentUser,
                      onPressedNotice: onPressedDesktopNotice,
                      child: DesktopTabBar(
                        index: this.widget.selectedIndex,
                        onTap: onMoveTabBar,
                        icons: desktopicons,
                      ),
                      //onFocusChange: _onFocusChange,
                    ),
        ),
        body: this.widget.body,
        floatingActionButton: this.widget.floatingActionButton,
        floatingActionButtonLocation: isMobile && !showIndex
            ? FloatingActionButtonLocation.centerDocked
            : FloatingActionButtonLocation.endFloat,
        bottomNavigationBar: isMobile && !showIndex
            ? Container(
                height: Parameter.bottomHeight,
                padding: Parameter.bottomPadding,
                child: MobileTabBar(
                  index: this.widget.selectedIndex,
                  icons: mobileicons,
                  onPressed: onMoveTabBar,
                ),
              )
            : SizedBox.shrink(),
      ),
    );
  }
}
