import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:order_app/apis/apis.dart';
import 'package:order_app/config/config.dart';
import 'package:order_app/source/source.dart';
import 'package:order_app/models/models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:order_app/views/views.dart';
import 'package:order_app/widgets/widgets.dart';

class PersonalView extends StatefulWidget {
  final void Function()? onPressed;

  const PersonalView({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  @override
  _PersonalViewState createState() => _PersonalViewState();
}

class _PersonalViewState extends State<PersonalView> {
  UserInfo? currentUser;
  Money? money;
  Profile? currentProfile;

  @override
  void initState() {
    currentProfile = null;
    money = null;
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
    final bool isMobile = Responsive.isMobile(context);
    final String title = currentUser == null
        ? ""
        : isMobile
            ? currentUser!.name
            : AppLocalizations.of(context)!.personalTile;
    return Module(
      selectedIndex: -1,
      title: title,
      body: currentProfile == null
          ? Responsive(
              mobile: MobilePersonalShimmer(),
              desktop: DesktopPersonalShimmer(),
            )
          : Responsive(
              mobile: MobilePersonalView(
                profile: currentProfile,
              ),
              desktop: DesktopPersonalView(
                money: money,
                profile: currentProfile,
                userInfo: currentUser,
              ),
            ),
      onPressed: this.widget.onPressed,
    );
  }
}

class MobilePersonalView extends StatelessWidget {
  final Profile? profile;

  const MobilePersonalView({
    required this.profile,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 20.0),
      child: ListView(
        children: [
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            title: Text(
              AppLocalizations.of(context)!.personalTile,
              style: Fontstyle.header(Colors.black87),
            ),
          ),
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            title: Text(
              "${AppLocalizations.of(context)!.emailText}：${profile!.sign.userid}",
              style: Fontstyle.device(Colors.black87),
            ),
            onTap: () {},
          ),
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            title: Text(
              "${AppLocalizations.of(context)!.departmentText}：${profile!.sign.department}",
              style: Fontstyle.device(Colors.black87),
            ),
            onTap: () {},
          ),
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            title: Text(
              "${AppLocalizations.of(context)!.workPlaceText}：${profile!.sign.workpress}",
              style: Fontstyle.device(Colors.black87),
            ),
            onTap: () {},
          ),
          SizedBox(height: 6.0),
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            title: Text(AppLocalizations.of(context)!.deviceText,
                style: Fontstyle.header(Colors.black87)),
          ),
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            title: Text(
              "${AppLocalizations.of(context)!.memoryText}：${profile!.device.memory}",
              style: Fontstyle.device(Colors.black87),
            ),
            onTap: () {},
          ),
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            title: Text(
              "${AppLocalizations.of(context)!.deviceText}：${profile!.device.device}",
              style: Fontstyle.device(Colors.black87),
            ),
            onTap: () {},
          ),
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            title: Text(
              "${AppLocalizations.of(context)!.manufacturerText}：${profile!.device.manufacturer}",
              style: Fontstyle.device(Colors.black87),
            ),
            onTap: () {},
          ),
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            title: Text(
              "${AppLocalizations.of(context)!.releaseText}：${profile!.device.release}",
              style: Fontstyle.device(Colors.black87),
            ),
            onTap: () {},
          ),
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            title: Text(
              "${AppLocalizations.of(context)!.nameText}：${profile!.device.name}",
              style: Fontstyle.device(Colors.black87),
            ),
            onTap: () {},
          ),
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            title: Text(
              "${AppLocalizations.of(context)!.uuidText}：${profile!.device.uuid}",
              style: Fontstyle.device(Colors.black87),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class MobilePersonalShimmer extends StatelessWidget {
  const MobilePersonalShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 20.0),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) => shimmerPersonal(),
      ),
    );
  }
}

class DesktopPersonalView extends StatelessWidget {
  final Money? money;
  final Profile? profile;
  final UserInfo? userInfo;

  const DesktopPersonalView({
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
            child: ListView(
              children: [
                ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  title: Text(AppLocalizations.of(context)!.personalTile,
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
                          "${AppLocalizations.of(context)!.emailText}：${profile!.sign.userid}",
                          style: Fontstyle.device(Colors.black87),
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
                          style: Fontstyle.device(Colors.black87),
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
                          style: Fontstyle.device(Colors.black87),
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
                          style: Fontstyle.device(Colors.black87),
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                          style: Fontstyle.device(Colors.black87),
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
                          style: Fontstyle.device(Colors.black87),
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
                          style: Fontstyle.device(Colors.black87),
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
                          style: Fontstyle.device(Colors.black87),
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
                          style: Fontstyle.device(Colors.black87),
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
                          style: Fontstyle.device(Colors.black87),
                        ),
                        onTap: () {},
                      ),
                    ),
                  ],
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

class DesktopPersonalShimmer extends StatelessWidget {
  const DesktopPersonalShimmer({
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

Widget shimmerPersonal() => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: ListTile(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
        title: WidgetShimmer.rectangular(),
      ),
    );
