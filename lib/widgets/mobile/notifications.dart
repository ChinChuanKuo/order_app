import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:order_app/apis/apis.dart';
import 'package:order_app/config/config.dart';
import 'package:order_app/source/source.dart';
import 'package:order_app/models/models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:order_app/widgets/widgets.dart';

class Notifications extends StatefulWidget {
  const Notifications({
    Key? key,
  }) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<Notice>? notices;
  late bool showdata;
  late ScrollController controller;

  @override
  void initState() {
    notices = null;
    showdata = true;
    controller = new ScrollController()..addListener(scrollListener);
    initialState();
    // TODO: implement initState
    super.initState();
  }

  void initialState() => new Timer(new Duration(seconds: 1), fetchNotice);

  Future scrollListener() async {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange &&
        showdata) {
      final response = await http.get(
          Uri.http(
            APi.user[2]["url"],
            APi.user[2]["route"],
            {
              "clientinfo": json.encode(await ClientSource.initialState()),
              "deviceinfo": json.encode(await DeviceSource.initialState()),
              "lengthinfo":
                  json.encode(LengthSource.initialState(notices!.length)),
            },
          ),
          headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        final noticeBody = parseNotice(response.body);
        setState(() => showdata = noticeBody.length == 10);
        if (noticeBody.length > 0)
          notices!.insertAll(notices!.length, noticeBody);
      }
    }
  }

  List<Notice> parseNotice(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Notice>((data) => Notice.fromJson(data)).toList();
  }

  Future fetchNotice() async {
    final response = await http.get(
        Uri.http(APi.user[1]["url"], APi.user[1]["route"], {
          "clientinfo": json.encode(await ClientSource.initialState()),
          "deviceinfo": json.encode(await DeviceSource.initialState()),
        }),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200)
      setState(() => notices = parseNotice(response.body));
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 65.0),
        child: customAppBar(
          AppLocalizations.of(context)!.notificationsText,
          () => Navigator.pop(context),
        ),
      ),
      body: notices == null
          ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) =>
                        ShimmerNotice(),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: controller,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    itemCount: notices!.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Notice notice = notices![index];
                      return NoticeSelector(notice: notice);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget customAppBar(
    String title,
    void Function()? onPressedArrowBack,
  ) =>
      AppBar(
        toolbarHeight: 65.0,
        centerTitle: false,
        elevation: 0.0,
        flexibleSpace: Container(
            decoration: new BoxDecoration(
                gradient: new LinearGradient(colors: Palette.tileColors))),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        leading: CircularButton(
          icon: Icons.arrow_back_ios_outlined,
          iconColor: Theme.of(context).primaryColor,
          onPressed: onPressedArrowBack,
        ),
        title: Text(title, style: Fontstyle.title),
      );
}

class ShimmerNotice extends StatelessWidget {
  const ShimmerNotice({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: WidgetShimmer.circular(width: 56.0, height: 56.0),
        title: WidgetShimmer.rectangular(),
        trailing: WidgetShimmer.circular(width: 42.0, height: 42.0),
      );
}
