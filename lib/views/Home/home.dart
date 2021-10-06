import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:order_app/apis/apis.dart';
import 'package:order_app/config/config.dart';
import 'package:order_app/source/source.dart';
import 'package:order_app/json/json.dart';
import 'package:order_app/models/models.dart';
import 'package:order_app/views/views.dart';
import 'package:order_app/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  UserInfo? currentUser;
  Shop? shop;
  late List<Menu> orders;

  @override
  void initState() {
    currentUser = null;
    shop = null;
    orders = <Menu>[];
    initialState();
    // TODO: implement initState
    super.initState();
  }

  void initialState() {
    new Timer(new Duration(milliseconds: 500), fetchUserInfo);
    new Timer(new Duration(milliseconds: 1500), fetchClient);
    new Timer(new Duration(milliseconds: 2500), fetchShop);
    new Timer(new Duration(milliseconds: 3500), fetchOrders);
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

  DataJson parseData(String responseBody) =>
      DataJson.fromJson(json.decode(responseBody));

  Future fetchClient() async {
    final response = await http.get(
        Uri.http(APi.menu[0]["url"], APi.menu[0]["route"], {
          "clientinfo": json.encode(await ClientSource.initialState()),
          "deviceinfo": json.encode(await DeviceSource.initialState()),
        }),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200)
      CustomSnackBar.showWidget(
        context,
        new Duration(seconds: 10),
        Responsive.isMobile(context)
            ? SnackBarBehavior.fixed
            : SnackBarBehavior.floating,
        Color.fromRGBO(255, 224, 207, 1),
        Row(children: [
          Icon(Icons.check, color: Color.fromRGBO(255, 122, 47, 1)),
          SizedBox(width: 8.0),
          Text(
            '本周加值儲金請找 ${parseData(response.body).data}',
            style: Fontstyle.subtitle(Color.fromRGBO(255, 122, 47, 1)),
          )
        ]),
      );
  }

  Shop parseShop(String responseBody) =>
      Shop.fromJson(json.decode(responseBody));

  Future fetchShop() async {
    final response = await http.get(
        Uri.http(APi.menu[1]["url"], APi.menu[1]["route"], {
          "clientinfo": json.encode(await ClientSource.initialState()),
          "deviceinfo": json.encode(await DeviceSource.initialState()),
        }),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      final shopBody = parseShop(response.body);
      setState(() => shop = shopBody);
      if (shopBody.closed)
        CustomSnackBar.showWidget(
          context,
          new Duration(seconds: 5),
          Responsive.isMobile(context)
              ? SnackBarBehavior.fixed
              : SnackBarBehavior.floating,
          CustomSnackBar.snackColor(false),
          Row(children: [
            Icon(Icons.check, color: Theme.of(context).primaryColor),
            SizedBox(width: 8.0),
            Text(AppLocalizations.of(context)!.closeMessageText)
          ]),
        );
    }
  }

  List<Menu> parseOrders(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Menu>((data) => Menu.fromJson(data)).toList();
  }

  Future fetchOrders() async {
    final response = await http.get(
        Uri.http(APi.menu[2]["url"], APi.menu[2]["route"], {
          "clientinfo": json.encode(await ClientSource.initialState()),
          "deviceinfo": json.encode(await DeviceSource.initialState()),
        }),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200)
      setState(() => orders = parseOrders(response.body));
  }

  int findShopIndex(Menu menu) => shop!.items.indexWhere(
      (element) => element.requireid.orderid == menu.requireid.orderid);

  int findOrderIndex(Menu menu) => orders.indexWhere(
      (element) => element.requireid.orderid == menu.requireid.orderid);

  void onCreateMenu(Menu menu) {
    final index = findShopIndex(menu);
    setState(() {
      shop!.items[index] = menu;
      shop!.items[index].ordered = true;
    });
    orders.add(newOrder(menu));
  }

  void onModifyMenu(Menu menu) {
    final index = findShopIndex(menu), oindex = findOrderIndex(menu);
    setState(() {
      shop!.items[index] = menu;
      shop!.items[index].ordered = true;
      orders[oindex] = menu;
      orders[oindex].action.modified = true;
    });
  }

  void onReduceMenu(Menu menu) {
    final int oindex = findOrderIndex(menu);
    onReduceOrder(oindex, menu);
  }

  void onPressedMobile(Menu menu) => showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
        ),
        builder: (BuildContext context) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 9.0),
          child: MenuOption(
            menu: menu,
            onCreate: onCreateMenu,
            onModify: onModifyMenu,
            onReduce: onReduceMenu,
          ),
        ),
      );

  Menu newOrder(Menu menu) => new Menu(
        menu: menu.menu,
        requireid: menu.requireid,
        ordered: true,
        action: new ActionJson(
          inserted: !menu.action.inserted,
          modified: menu.action.modified,
          deleted: menu.action.deleted,
        ),
      );

  void onPressedPlus(Menu menu) {
    final index = findShopIndex(menu);
    setState(() {
      shop!.items[index].menu.quantity = "1";
      shop!.items[index].ordered = true;
    });
    orders.add(newOrder(menu));
  }

  void onClosedShop(bool closed) => setState(() => shop!.closed = closed);

  Future onReduceOut(int oindex, Menu menu) async {
    if (orders[oindex].action.deleted) {
      final response = await http
          .post(Uri.http(APi.menu[4]["url"], APi.menu[4]["route"]), body: {
        "clientinfo": json.encode(await ClientSource.initialState()),
        "deviceinfo": json.encode(await DeviceSource.initialState()),
        "requiredinfo": json.encode(RequireidJson.initialState(menu.requireid)),
      }, headers: {
        "Accept": "application/json"
      });
      final bool statusCode = response.statusCode == 200;
      if (statusCode) {
        final String status = json.decode(response.body)["status"];
        final bool successed = status == "istrue";
        if (successed)
          onRemoveOrder(oindex);
        else {
          final bool closed = status == "closed";
          onClosedShop(closed);
          CustomSnackBar.showWidget(
            context,
            new Duration(seconds: 5),
            Responsive.isMobile(context)
                ? SnackBarBehavior.fixed
                : SnackBarBehavior.floating,
            CustomSnackBar.snackColor(successed),
            Row(children: [
              Icon(Icons.check, color: Theme.of(context).primaryColor),
              SizedBox(width: 8.0),
              Text(AppLocalizations.of(context)!.closeMessageText)
            ]),
          );
        }
      } else
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
      onRemoveOrder(oindex);
  }

  void onReduceShop(Menu menu) {
    final int index = findShopIndex(menu);
    setState(() {
      shop!.items[index].menu.quantity = "0";
      shop!.items[index].ordered = false;
    });
  }

  void onRemoveOrder(int oindex) => orders.removeAt(oindex);

  void onPressedReduce(Menu menu) {
    final int oindex = findOrderIndex(menu);
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        elevation: 14.0,
        child: Container(
          width: 352.89,
          height: 216.0,
          child: ReduceDialog(
            menu: menu,
            index: oindex,
            deleted: orders[oindex].action.deleted,
            onRemove: onRemoveOrder,
            onClosed: onClosedShop,
            onReduce: onReduceShop,
          ),
        ),
      ),
    );
  }

  void onTapReduce(Menu menu) {
    final int index = findOrderIndex(menu),
        quantity = int.parse(menu.menu.quantity) - 1;
    setState(() {
      orders[index].menu.quantity = quantity.toString();
      orders[index].action.modified = true;
    });
    if (quantity == 0) onReduceOrder(index, menu);
  }

  void onReduceOrder(int oindex, Menu menu) {
    final int index = findShopIndex(menu);
    setState(() {
      shop!.items[index].menu.quantity = "0";
      shop!.items[index].ordered = false;
    });
    onReduceOut(oindex, menu);
  }

  void onTapCreate(Menu menu) {
    final int index = findOrderIndex(menu),
        quantity = int.parse(menu.menu.quantity) + 1;
    setState(() {
      orders[index].menu.quantity = quantity.toString();
      orders[index].action.modified = true;
    });
  }

  void onSetupMenus(bool closed) {
    final menus = <Menu>[];
    for (var item in orders)
      if (!(item.action.inserted || item.action.modified))
        menus.add(
          new Menu(
            menu: item.menu,
            requireid: item.requireid,
            ordered: true,
            action: new ActionJson(
              inserted: false,
              modified: false,
              deleted: true,
            ),
          ),
        );
      else
        setState(() => shop!.items[findShopIndex(item)].ordered = false);
    setState(() {
      shop!.closed = closed;
      orders = menus;
    });
  }

  void onPressedOut() => showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          elevation: 14.0,
          child: Container(
            width: 352.89,
            height: 216.0,
            child: PaymentDialog(
              menuinfo: orders.where((order) =>
                  order.action.inserted == true ||
                  order.action.modified == true),
              onSetup: onSetupMenus,
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final bool showData = shop == null,
        paymented = orders
                .where(
                    (order) => order.action.inserted || order.action.modified)
                .length >
            0;
    return Module(
      selectedIndex: 0,
      title: "Order System",
      body: showData
          ? Responsive(
              mobile: MobileHomeShimmer(),
              desktop: DesktopHomeShimmer(),
            )
          : Responsive(
              mobile: MobileHomeView(
                shop: shop,
                paymented: paymented,
                orders: orders,
                onPressed: onPressedMobile,
              ),
              desktop: DesktopHomeView(
                shop: shop,
                onPressedPlus: onPressedPlus,
                paymented: paymented,
                orders: orders,
                onPressedReduce: onPressedReduce,
                onTapReduce: onTapReduce,
                onTapCreate: onTapCreate,
              ),
            ),
      floatingActionButton: paymented
          ? FloatingActionButton.extended(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.payment_outlined),
              label: Text(
                AppLocalizations.of(context)!.paymentText,
                style: Fontstyle.device(Colors.black),
              ),
              onPressed: onPressedOut,
            )
          : null,
    );
  }
}

class MobileHomeView extends StatelessWidget {
  final Shop? shop;
  final bool? paymented;
  final List<Menu>? orders;
  final void Function(Menu menu) onPressed;

  const MobileHomeView({
    Key? key,
    required this.shop,
    required this.paymented,
    required this.orders,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool ordered = orders!.length == 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
            child: PaymentText(
              paymented: paymented! || ordered,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: paymented! ? 3.0 : 0.0),
                child: Text(
                  shop!.shop.name,
                  style: Fontstyle.header(Colors.black87),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              scrollDirection: Axis.vertical,
              itemCount: shop!.items.length,
              itemBuilder: (BuildContext context, int index) {
                final Menu menu = shop!.items[index];
                return WidgetAnimator(
                  vertical: true,
                  child: MenuSelector(
                    menu: menu,
                    disabled: shop!.closed || !shop!.opened,
                    onPressed: () => onPressed(menu),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MobileHomeShimmer extends StatelessWidget {
  const MobileHomeShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
            child: WidgetShimmer.rectangular(width: 100.0),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              scrollDirection: Axis.vertical,
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) =>
                  shimmerMenu(screenSize),
            ),
          ),
        ],
      ),
    );
  }
}

class DesktopHomeView extends StatelessWidget {
  final Shop? shop;
  final void Function(Menu menu) onPressedPlus;
  final bool? paymented;
  final List<Menu>? orders;
  final void Function(Menu order) onPressedReduce;
  final void Function(Menu order) onTapReduce;
  final void Function(Menu order) onTapCreate;

  const DesktopHomeView({
    Key? key,
    required this.shop,
    required this.onPressedPlus,
    required this.paymented,
    required this.orders,
    required this.onPressedReduce,
    required this.onTapReduce,
    required this.onTapCreate,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6.0, vertical: 20.0),
                child: Text(
                  shop!.shop.name,
                  style: Fontstyle.header(Colors.black87),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 10.0),
                  scrollDirection: Axis.vertical,
                  itemCount: shop!.items.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Menu menu = shop!.items[index];
                    return WidgetAnimator(
                      vertical: true,
                      child: MenuSelector(
                        menu: menu,
                        disabled: menu.ordered || shop!.closed || !shop!.opened,
                        onPressed: () => onPressedPlus(menu),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
        Flexible(
          flex: 2,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 12.0, top: 12.0, bottom: 12.0),
              child: OrderList(
                paymented: paymented!,
                closed: shop!.closed || !shop!.opened,
                orders: orders,
                onPressed: onPressedReduce,
                onTapReduce: onTapReduce,
                onTapCreate: onTapCreate,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DesktopHomeShimmer extends StatelessWidget {
  const DesktopHomeShimmer({
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6.0, vertical: 20.0),
                child: WidgetShimmer.rectangular(width: 100.0),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 10.0),
                  scrollDirection: Axis.vertical,
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) =>
                      shimmerMenu(screenSize),
                ),
              )
            ],
          ),
        ),
        Flexible(
          flex: 2,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 12.0, top: 12.0, bottom: 12.0),
              child: OrderLoading(),
            ),
          ),
        ),
      ],
    );
  }
}

Widget shimmerMenu(Size screenSize) => Column(
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
