import 'dart:async';
import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:order_app/apis/apis.dart';
import 'package:order_app/config/config.dart';
import 'package:order_app/data/data.dart';
import 'package:order_app/source/source.dart';
import 'package:order_app/models/models.dart';
import 'package:order_app/views/views.dart';
import 'package:order_app/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({
    Key? key,
  }) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  UserInfo? currentUser;
  Money? money;
  Profile? currentProfile;

  @override
  void initState() {
    currentUser = null;
    money = null;
    currentProfile = null;
    initialState();
    // TODO: implement initState
    super.initState();
  }

  void initialState() {
    new Timer(new Duration(milliseconds: 500), fetchUserInfo);
    new Timer(new Duration(milliseconds: 1500), fetchMoney);
    new Timer(new Duration(milliseconds: 2500), fetchProfile);
  }

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
  }

  Money parseMoney(String responseBody) =>
      Money.fromJson(json.decode(responseBody));

  Future fetchMoney() async {
    final response = await http.get(
        Uri.http(APi.money[0]["url"], APi.money[0]["route"], {
          "clientinfo": json.encode(await ClientSource.initialState()),
          "deviceinfo": json.encode(await DeviceSource.initialState()),
        }),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200)
      setState(() => money = parseMoney(response.body));
  }

  Profile parseProfile(String responseBody) =>
      Profile.fromJson(json.decode(responseBody));

  Future fetchProfile() async {
    final response = await http.get(
        Uri.http(APi.profile[0]["url"], APi.profile[0]["route"], {
          "clientinfo": json.encode(await ClientSource.initialState()),
          "deviceinfo": json.encode(await DeviceSource.initialState()),
        }),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200)
      setState(() => currentProfile = parseProfile(response.body));
  }

  @override
  Widget build(BuildContext context) {
    return Module(
      selectedIndex: 4,
      title: AppLocalizations.of(context)!.profileTile,
      body: currentProfile == null
          ? Responsive(
              mobile: MobileProfileShimmer(),
              desktop: DesktopProfileShimmer(),
            )
          : Responsive(
              mobile: MobileProfileView(
                money: money,
                userInfo: currentUser,
              ),
              desktop: DesktopProfileView(
                money: money,
                profile: currentProfile,
                userInfo: currentUser,
              ),
            ),
    );
  }
}

class MobileProfileView extends StatelessWidget {
  final Money? money;
  final UserInfo? userInfo;

  const MobileProfileView({
    Key? key,
    required this.money,
    required this.userInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OpenContainer(
            closedElevation: 0.0,
            closedColor: Colors.transparent,
            closedBuilder:
                (BuildContext context, void Function() closeBuilder) =>
                    ProfileCard(
              onTap: closeBuilder,
              userInfo: userInfo!,
              money: money!,
            ),
            openElevation: 0.0,
            openColor: Colors.transparent,
            openBuilder: (BuildContext context, void Function() openBuilder) =>
                PersonalView(onPressed: openBuilder),
          ),
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
                    leading: Icon(desktopicons[1][1], size: Parameter.iconSize),
                    title: Text(
                      AppLocalizations.of(context)!.moneyTile,
                      style: Fontstyle.device(Colors.black),
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
                    leading: Icon(desktopicons[2][1], size: Parameter.iconSize),
                    title: Text(
                      AppLocalizations.of(context)!.settingsTile,
                      style: Fontstyle.device(Colors.black),
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
                    leading: Icon(desktopicons[3][1], size: Parameter.iconSize),
                    title: Text(
                      AppLocalizations.of(context)!.calendarTile,
                      style: Fontstyle.device(Colors.black),
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
                        color: Palette.disabledColor, size: Parameter.iconSize),
                    title: Text(
                      AppLocalizations.of(context)!.signoutTile,
                      style: Fontstyle.device(Colors.black),
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
    );
  }
}

class MobileProfileShimmer extends StatelessWidget {
  const MobileProfileShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 20.0),
      child: Column(
        children: [
          SizedBox(height: screenSize.height * 0.01),
          shimmerUser(screenSize),
          SizedBox(height: screenSize.height * 0.015),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) =>
                  shimmerProfile(),
            ),
          ),
        ],
      ),
    );
  }
}

class DesktopProfileView extends StatelessWidget {
  final Money? money;
  final Profile? profile;
  final UserInfo? userInfo;

  const DesktopProfileView({
    Key? key,
    required this.money,
    required this.profile,
    required this.userInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    final Size screenSize = MediaQuery.of(context).size;
    final double maxWidth =
        isDesktop ? screenSize.width - 480.0 : screenSize.width - 380.0;
    return Row(
      children: [
        if (isDesktop)
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 12.0, top: 12.0, bottom: 12.0),
                child: null,
              ),
            ),
          ),
        Container(
          margin: isDesktop
              ? EdgeInsets.only(top: 12.0)
              : EdgeInsets.only(top: 12.0, left: 48.0),
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 6.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  title: Text(AppLocalizations.of(context)!.personalTile,
                      style: Fontstyle.header(Colors.black87)),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0)),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              title: Text(
                                "${AppLocalizations.of(context)!.emailText}：${profile!.sign.userid}",
                                style: Fontstyle.device(Colors.black),
                              ),
                              onTap: () {},
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0)),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              title: Text(
                                "${AppLocalizations.of(context)!.nameText}：${profile!.sign.username}",
                                style: Fontstyle.device(Colors.black),
                              ),
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0)),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              title: Text(
                                "${AppLocalizations.of(context)!.departmentText}：${profile!.sign.department}",
                                style: Fontstyle.device(Colors.black),
                              ),
                              onTap: () {},
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0)),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              title: Text(
                                "${AppLocalizations.of(context)!.workPlaceText}：${profile!.sign.workpress}",
                                style: Fontstyle.device(Colors.black),
                              ),
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenSize.height * 0.015),
                      ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0)),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16.0),
                        title: Text(AppLocalizations.of(context)!.deviceText,
                            style: Fontstyle.header(Colors.black87)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0)),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              title: Text(
                                "${AppLocalizations.of(context)!.memoryText}：${profile!.device.memory}",
                                style: Fontstyle.device(Colors.black),
                              ),
                              onTap: () {},
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0)),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              title: Text(
                                "${AppLocalizations.of(context)!.deviceText}：${profile!.device.device}",
                                style: Fontstyle.device(Colors.black),
                              ),
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0)),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              title: Text(
                                "${AppLocalizations.of(context)!.manufacturerText}：${profile!.device.manufacturer}",
                                style: Fontstyle.device(Colors.black),
                              ),
                              onTap: () {},
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0)),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              title: Text(
                                "${AppLocalizations.of(context)!.releaseText}：${profile!.device.release}",
                                style: Fontstyle.device(Colors.black),
                              ),
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0)),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              title: Text(
                                "${AppLocalizations.of(context)!.nameText}：${profile!.device.name}",
                                style: Fontstyle.device(Colors.black),
                              ),
                              onTap: () {},
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0)),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              title: Text(
                                "${AppLocalizations.of(context)!.uuidText}：${profile!.device.uuid}",
                                style: Fontstyle.device(Colors.black),
                              ),
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 12.0, top: 12.0, bottom: 12.0),
              child: ProfileList(
                money: money,
                userInfo: userInfo,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DesktopProfileShimmer extends StatelessWidget {
  const DesktopProfileShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    final Size screenSize = MediaQuery.of(context).size;
    final double maxWidth =
        isDesktop ? screenSize.width - 480.0 : screenSize.width - 380.0;
    return Row(
      children: [
        if (isDesktop)
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 12.0, top: 12.0, bottom: 12.0),
                child: null,
              ),
            ),
          ),
        Container(
          margin: isDesktop
              ? EdgeInsets.only(top: 12.0)
              : EdgeInsets.only(top: 12.0, left: 48.0),
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 6.0, vertical: 20.0),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) =>
                  shimmerPersonal(),
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 12.0, top: 12.0, bottom: 12.0),
              child: ProfileLoading(),
            ),
          ),
        ),
      ],
    );
  }
}
