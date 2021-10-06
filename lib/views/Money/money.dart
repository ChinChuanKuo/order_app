import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:order_app/apis/apis.dart';
import 'package:order_app/source/source.dart';
import 'package:order_app/models/models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:order_app/views/views.dart';
import 'package:order_app/widgets/widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MoneyView extends StatefulWidget {
  final void Function()? onPressed;

  const MoneyView({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  @override
  _MoneyViewState createState() => _MoneyViewState();
}

class _MoneyViewState extends State<MoneyView> {
  UserInfo? currentUser;
  Money? money;
  late List<Store> stores;
  MoneySource? dataSource;
  List<Statist>? statists;
  List<Statist>? analysis;
  late CalendarController controller;

  @override
  void initState() {
    currentUser = null;
    money = null;
    stores = <Store>[];
    statists = null;
    analysis = null;
    controller = new CalendarController();
    initialState();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initialState() {
    new Timer(new Duration(milliseconds: 500), fetchUserInfo);
    fetchStores();
    new Timer(new Duration(milliseconds: 1500), fetchMoney);
    new Timer(new Duration(milliseconds: 2500), fetchStatist);
    new Timer(new Duration(milliseconds: 3500), fetchAnalysis);
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

  Future fetchStores() async => dataSource = new MoneySource(stores: <Store>[]);

  List<Statist> parseStatist(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Statist>((data) => Statist.fromJson(data)).toList();
  }

  Future fetchStatist() async {
    final response = await http.get(
        Uri.http(APi.money[2]["url"], APi.money[2]["route"], {
          "clientinfo": json.encode(await ClientSource.initialState()),
          "deviceinfo": json.encode(await DeviceSource.initialState()),
        }),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200)
      setState(() => statists = parseStatist(response.body));
  }

  Future fetchAnalysis() async {
    final response = await http.get(
        Uri.http(APi.money[3]["url"], APi.money[3]["route"], {
          "clientinfo": json.encode(await ClientSource.initialState()),
          "deviceinfo": json.encode(await DeviceSource.initialState()),
        }),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200)
      setState(() => analysis = parseStatist(response.body));
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    return Module(
      selectedIndex: isMobile ? -1 : 1,
      title: AppLocalizations.of(context)!.moneyTile,
      body: money == null
          ? Responsive(
              mobile: MobileMoneyShimmer(),
              desktop: DesktopMoneyShimmer(),
            )
          : Responsive(
              mobile: MobileMoneyView(
                statists: statists,
                controller: controller,
                dataSource: dataSource,
              ),
              desktop: DesktopMoneyView(
                money: money,
                statists: statists,
                analysis: analysis,
                controller: controller,
                dataSource: dataSource,
                userInfo: currentUser,
              ),
            ),
      onPressed: isMobile ? this.widget.onPressed : null,
    );
  }
}

class MobileMoneyView extends StatelessWidget {
  final List<Statist>? statists;
  final CalendarController controller;
  final CalendarDataSource? dataSource;

  const MobileMoneyView({
    Key? key,
    required this.statists,
    required this.controller,
    required this.dataSource,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            constraints: BoxConstraints(maxHeight: 200.0),
            child: RectangleCard(
              child: statists == null
                  ? WidgetLoading().centerCircular
                  : StatistBarChart(statists: statists),
            ),
          ),
          SizedBox(height: screenSize.height * 0.01),
          Expanded(
            child:
                MoneyCalendar(controller: controller, dataSource: dataSource),
          ),
        ],
      ),
    );
  }
}

class MobileMoneyShimmer extends StatelessWidget {
  const MobileMoneyShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 20.0),
      child: Column(
        children: [
          Container(
              constraints: BoxConstraints(maxHeight: 200.0),
              child: WidgetLoading().centerCircular),
          SizedBox(height: screenSize.height * 0.01),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              scrollDirection: Axis.vertical,
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) =>
                  shimmerMoney(screenSize),
            ),
          ),
        ],
      ),
    );
  }
}

class DesktopMoneyView extends StatelessWidget {
  final Money? money;
  final List<Statist>? statists;
  final List<Statist>? analysis;
  final CalendarController controller;
  final CalendarDataSource? dataSource;
  final UserInfo? userInfo;

  const DesktopMoneyView({
    Key? key,
    required this.money,
    required this.statists,
    required this.analysis,
    required this.controller,
    required this.dataSource,
    required this.userInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context),
        isDesktop = Responsive.isDesktop(context);
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(maxHeight: 200.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: RectangleCard(
                          child: statists == null
                              ? WidgetLoading().centerCircular
                              : StatistBarChart(statists: statists),
                        ),
                      ),
                      SizedBox(width: screenSize.width * 0.01),
                      Expanded(
                        child: RectangleCard(
                          child: analysis == null
                              ? WidgetLoading().centerCircular
                              : StatistBarChart(statists: analysis),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenSize.height * 0.01),
                Expanded(
                  child: MoneyCalendar(
                      controller: controller, dataSource: dataSource),
                ),
              ],
            ),
          ),
        ),
        if (!isMobile)
          Flexible(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding:
                    const EdgeInsets.only(right: 12.0, top: 12.0, bottom: 12.0),
                child: ProfileList(
                  money: money,
                  selectedIndex: 0,
                  userInfo: userInfo,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class DesktopMoneyShimmer extends StatelessWidget {
  const DesktopMoneyShimmer({
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(maxHeight: 200.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(child: WidgetLoading().centerCircular),
                      Expanded(child: WidgetLoading().centerCircular),
                    ],
                  ),
                ),
                SizedBox(height: screenSize.height * 0.01),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 10.0),
                    scrollDirection: Axis.vertical,
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) =>
                        shimmerMoney(screenSize),
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
              child: ProfileLoading(),
            ),
          ),
        ),
      ],
    );
  }
}

Widget shimmerMoney(Size screenSize) => Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            WidgetShimmer.rectangular(width: 60.0),
            Row(
              children: [
                WidgetShimmer.rectangular(width: 60.0),
                SizedBox(width: screenSize.width * 0.025),
                WidgetShimmer.rectangular(width: 60.0),
                SizedBox(width: screenSize.width * 0.025),
                WidgetShimmer.circular(width: 52.0, height: 52.0)
              ],
            ),
          ],
        ),
        Divider(),
      ],
    );
