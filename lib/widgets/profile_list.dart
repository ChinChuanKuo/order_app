import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:order_app/config/config.dart';
import 'package:order_app/data/data.dart';
import 'package:order_app/models/models.dart';
import 'package:order_app/source/source.dart';
import 'package:order_app/views/views.dart';
import 'package:order_app/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileList extends StatefulWidget {
  final Money? money;
  final int selectedIndex;
  final UserInfo? userInfo;

  const ProfileList({
    Key? key,
    required this.money,
    this.selectedIndex = -1,
    required this.userInfo,
  }) : super(key: key);

  @override
  _ProfileListState createState() => _ProfileListState();
}

class _ProfileListState extends State<ProfileList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onTapProfile() => print("profile");

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool fristIndex = widget.selectedIndex == 0,
        secondIndex = widget.selectedIndex == 1,
        thirdIndex = widget.selectedIndex == 2;
    return Container(
      constraints: BoxConstraints(maxWidth: 280.0),
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.userInfo != null && widget.money != null
                ? ProfileCard(
                    money: widget.money!,
                    onTap: onTapProfile,
                    userInfo: widget.userInfo!,
                  )
                : shimmerUser(screenSize),
            Expanded(
              child: ListView(
                children: [
                  OpenContainer(
                    closedElevation: 0.0,
                    closedColor: Colors.transparent,
                    closedBuilder:
                        (BuildContext context, void Function() closeBuilder) =>
                            ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 4.0),
                      leading: Icon(
                          fristIndex ? desktopicons[1][0] : desktopicons[1][1],
                          color: fristIndex
                              ? Palette.orderColor
                              : Palette.disabledColor,
                          size: Parameter.iconSize),
                      title: Text(
                        AppLocalizations.of(context)!.moneyTile,
                        style: Fontstyle.device(fristIndex
                            ? Palette.orderColor
                            : Palette.disabledColor),
                      ),
                      onTap: closeBuilder,
                    ),
                    openElevation: 0.0,
                    openColor: Colors.transparent,
                    openBuilder:
                        (BuildContext context, void Function() openBuilder) =>
                            MoneyView(onPressed: openBuilder),
                  ),
                  OpenContainer(
                    closedElevation: 0.0,
                    closedColor: Colors.transparent,
                    closedBuilder:
                        (BuildContext context, void Function() closeBuilder) =>
                            ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 4.0),
                      leading: Icon(
                          secondIndex ? desktopicons[2][0] : desktopicons[2][1],
                          color: secondIndex
                              ? Palette.orderColor
                              : Palette.disabledColor,
                          size: Parameter.iconSize),
                      title: Text(
                        AppLocalizations.of(context)!.settingsTile,
                        style: Fontstyle.device(secondIndex
                            ? Palette.orderColor
                            : Palette.disabledColor),
                      ),
                      onTap: closeBuilder,
                    ),
                    openElevation: 0.0,
                    openColor: Colors.transparent,
                    openBuilder:
                        (BuildContext context, void Function() openBuilder) =>
                            SettingsView(onPressed: openBuilder),
                  ),
                  OpenContainer(
                    closedElevation: 0.0,
                    closedColor: Colors.transparent,
                    closedBuilder:
                        (BuildContext context, void Function() closeBuilder) =>
                            ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 4.0),
                      leading: Icon(
                          thirdIndex ? desktopicons[3][0] : desktopicons[3][1],
                          color: thirdIndex
                              ? Palette.orderColor
                              : Palette.disabledColor,
                          size: Parameter.iconSize),
                      title: Text(
                        AppLocalizations.of(context)!.calendarTile,
                        style: Fontstyle.device(thirdIndex
                            ? Palette.orderColor
                            : Palette.disabledColor),
                      ),
                      onTap: closeBuilder,
                    ),
                    openElevation: 0.0,
                    openColor: Colors.transparent,
                    openBuilder:
                        (BuildContext context, void Function() openBuilder) =>
                            CalendarView(onPressed: openBuilder),
                  ),
                  OpenContainer(
                    closedElevation: 0.0,
                    closedColor: Colors.transparent,
                    closedBuilder:
                        (BuildContext context, void Function() closeBuilder) =>
                            ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 4.0),
                      leading: Icon(Icons.logout_outlined,
                          color: Palette.disabledColor,
                          size: Parameter.iconSize),
                      title: Text(
                        AppLocalizations.of(context)!.signoutTile,
                        style: Fontstyle.device(Palette.disabledColor),
                      ),
                      onTap: () {
                        ClientSource.removeState();
                        closeBuilder();
                      },
                    ),
                    openElevation: 0.0,
                    openColor: Colors.transparent,
                    openBuilder:
                        (BuildContext context, void Function() openBuilder) =>
                            SigninView(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
