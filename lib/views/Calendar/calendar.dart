import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:order_app/apis/apis.dart';
import 'package:order_app/config/config.dart';
import 'package:order_app/json/json.dart';
import 'package:order_app/models/models.dart';
import 'package:order_app/source/source.dart';
import 'package:order_app/views/views.dart';
import 'package:order_app/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class CalendarView extends StatefulWidget {
  final void Function()? onPressed;

  const CalendarView({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  UserInfo? currentUser;
  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController phoneController;
  late RoundedLoadingButtonController controller;

  @override
  void initState() {
    currentUser = null;
    nameController = new TextEditingController();
    addressController = new TextEditingController();
    phoneController = new TextEditingController();
    controller = new RoundedLoadingButtonController();
    initialState();
    // TODO: implement initState
    super.initState();
  }

  void initialState() {
    new Timer(new Duration(milliseconds: 500), fetchUserInfo);
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    // TODO: implement dispose
    super.dispose();
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

  void onPressedSend() async {
    final String name = nameController.text,
        address = addressController.text,
        phone = phoneController.text;
    if (name.isNotEmpty && address.isNotEmpty && phone.isNotEmpty) {
      final response = await http.post(
          Uri.http(APi.suggest[0]["url"], APi.suggest[0]["route"]),
          body: {
            "clientinfo": json.encode(await ClientSource.initialState()),
            "deviceinfo": json.encode(await DeviceSource.initialState()),
            "shopinfo": json.encode(ShopJson.initialState(
                new ShopJson(name: name, phone: phone, address: address))),
          },
          headers: {
            "Accept": "application/json"
          });
      final statusCode = response.statusCode == 200;
      if (statusCode) {
        nameController.text = "";
        addressController.text = "";
        phoneController.text = "";
        controller.success();
      } else
        controller.error();
      new Timer(new Duration(seconds: 5), () => controller.reset());
      CustomSnackBar.showWidget(
        context,
        new Duration(seconds: 5),
        Responsive.isMobile(context)
            ? SnackBarBehavior.fixed
            : SnackBarBehavior.floating,
        CustomSnackBar.snackColor(statusCode),
        Row(children: [
          Icon(Icons.check, color: Theme.of(context).primaryColor),
          SizedBox(width: 8.0),
          Text(CustomSnackBar.snackText(statusCode, context))
        ]),
      );
    } else
      controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    return Module(
      selectedIndex: isMobile ? -1 : 3,
      title: AppLocalizations.of(context)!.calendarTile,
      body: currentUser == null
          ? CalendarShimmer()
          : imageGround(
              Responsive(
                mobile: MobileCalendarView(
                  nameController: nameController,
                  addressController: addressController,
                  phoneController: phoneController,
                  controller: controller,
                  onPressed: onPressedSend,
                ),
                desktop: DesktopCalendarView(
                  nameController: nameController,
                  addressController: addressController,
                  phoneController: phoneController,
                  controller: controller,
                  onPressed: onPressedSend,
                  userInfo: currentUser,
                ),
              ),
            ),
      onPressed: isMobile ? this.widget.onPressed : null,
    );
  }

  Widget imageGround(Widget child) => Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/calendar.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: child,
      );
}

class MobileCalendarView extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController addressController;
  final TextEditingController phoneController;
  final RoundedLoadingButtonController controller;
  final void Function()? onPressed;

  const MobileCalendarView({
    Key? key,
    required this.nameController,
    required this.addressController,
    required this.phoneController,
    required this.controller,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "優質餐廳推薦",
              style: GoogleFonts.roboto(
                textStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 25.0,
                ),
              ),
            ),
          ),
          SizedBox(height: screenSize.height * 0.025),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "「真的好想吃這間!」推薦優質美食店家，和飛捷同事們一起共享美味!",
              style: Fontstyle.subinfo(Theme.of(context).primaryColor),
            ),
          ),
          SizedBox(height: screenSize.height * 0.015),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(14.0)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 48.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Text('推薦餐廳名稱*',
                            style: Fontstyle.device(Palette.orderColor)),
                        SizedBox(height: 12.0),
                        inputBar(nameController, ''),
                        SizedBox(height: screenSize.height * 0.025),
                        Text('餐廳詳細資訊(選填)',
                            style: Fontstyle.device(Palette.orderColor)),
                        SizedBox(height: 12.0),
                        inputBar(addressController, '地址'),
                        SizedBox(height: screenSize.height * 0.015),
                        inputBar(phoneController, '電話'),
                        SizedBox(height: screenSize.height * 0.025),
                        Text('推薦理由',
                            style: Fontstyle.device(Palette.orderColor)),
                        SizedBox(height: 12.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            checkboxText(false, (bool? focus) {}, Text("食物美味")),
                            checkboxText(false, (bool? focus) {}, Text("超高CP")),
                            checkboxText(false, (bool? focus) {}, Text("健康養生")),
                          ],
                        ),
                        checkboxText(
                            false,
                            (bool? focus) {},
                            Expanded(
                                child: TextField(
                                    controller: new TextEditingController(),
                                    decoration:
                                        InputDecoration(hintText: "其他")))),
                        SizedBox(height: screenSize.height * 0.05),
                      ],
                    ),
                  ),
                  RoundedButton(
                    icon: Icons.send_outlined,
                    text: AppLocalizations.of(context)!.submitText,
                    controller: controller,
                    onPressed: onPressed,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CalendarShimmer extends StatelessWidget {
  const CalendarShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 20.0),
        child: WidgetLoading().centerCircular);
  }
}

class DesktopCalendarView extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController addressController;
  final TextEditingController phoneController;
  final RoundedLoadingButtonController controller;
  final void Function()? onPressed;
  final UserInfo? userInfo;

  const DesktopCalendarView({
    Key? key,
    required this.nameController,
    required this.addressController,
    required this.phoneController,
    required this.controller,
    required this.onPressed,
    required this.userInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
      constraints: BoxConstraints(maxWidth: 1036.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "優質餐廳推薦",
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 25.0,
                  ),
                ),
              ),
              SizedBox(height: screenSize.height * 0.015),
              Text(
                "「真的好想吃這間!」推薦優質美食店家，",
                style: Fontstyle.subinfo(Theme.of(context).primaryColor),
              ),
              Text(
                "和飛捷同事們一起共享美味!",
                style: Fontstyle.subinfo(Theme.of(context).primaryColor),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 12.0, bottom: 12.0),
            constraints: BoxConstraints(maxWidth: 456.0, maxHeight: 588.0),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(14.0)),
            padding:
                const EdgeInsets.symmetric(horizontal: 40.0, vertical: 48.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Text('推薦餐廳名稱*',
                          style: Fontstyle.device(Palette.orderColor)),
                      SizedBox(height: 12.0),
                      inputBar(nameController, ''),
                      SizedBox(height: screenSize.height * 0.025),
                      Text('餐廳詳細資訊(選填)',
                          style: Fontstyle.device(Palette.orderColor)),
                      SizedBox(height: 12.0),
                      inputBar(addressController, '地址'),
                      SizedBox(height: screenSize.height * 0.015),
                      inputBar(phoneController, '電話'),
                      SizedBox(height: screenSize.height * 0.025),
                      Text('推薦理由', style: Fontstyle.device(Palette.orderColor)),
                      SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          checkboxText(false, (bool? focus) {}, Text("食物美味")),
                          checkboxText(false, (bool? focus) {}, Text("超高CP")),
                          checkboxText(false, (bool? focus) {}, Text("健康養生")),
                        ],
                      ),
                      checkboxText(
                          false,
                          (bool? focus) {},
                          Expanded(
                              child: TextField(
                                  controller: new TextEditingController(),
                                  decoration:
                                      InputDecoration(hintText: "其他")))),
                    ],
                  ),
                ),
                RoundedButton(
                  icon: Icons.send_outlined,
                  text: AppLocalizations.of(context)!.submitText,
                  controller: controller,
                  onPressed: onPressed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget inputBar(TextEditingController controller, String hintText) => TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: new OutlineInputBorder(
            borderRadius: BorderRadius.all(const Radius.circular(50.0)),
            borderSide: BorderSide(color: Palette.disabledColor, width: 2.0)),
      ),
    );

Widget checkboxText(
        bool? focus, void Function(bool? focus)? onChanged, Widget child) =>
    Row(
      children: [
        Checkbox(value: focus, onChanged: onChanged),
        child,
      ],
    );
