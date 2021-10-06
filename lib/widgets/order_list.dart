import 'package:flutter/material.dart';
import 'package:order_app/config/config.dart';
import 'package:order_app/models/models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:order_app/widgets/widgets.dart';

class OrderList extends StatelessWidget {
  final bool paymented;
  final bool closed;
  final List<Menu>? orders;
  final void Function(Menu order)? onPressed;
  final void Function(Menu order)? onTapReduce;
  final void Function(Menu order)? onTapCreate;

  const OrderList({
    Key? key,
    required this.paymented,
    required this.closed,
    required this.orders,
    required this.onPressed,
    required this.onTapReduce,
    required this.onTapCreate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool ordered = orders!.length == 0;
    return Container(
      width: 280.0,
      constraints: BoxConstraints(maxWidth: 280.0),
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: PaymentText(
              paymented: paymented || ordered,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: paymented ? 7.5 : 0.0),
                child: Text(
                  "My ${AppLocalizations.of(context)!.orderText}",
                  style: Fontstyle.header(Palette.orderColor),
                ),
              ),
            ),
          ),
          SizedBox(height: ordered ? screenSize.height * 0.03 : 0.0),
          Expanded(
            child: ordered
                ? Text(
                    AppLocalizations.of(context)!.dontMessageText,
                    style: Fontstyle.info(Colors.black87),
                  )
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: orders!.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Menu order = orders![index];
                      return WidgetAnimator(
                        vertical: true,
                        child: OrderSelector(
                          closed: closed,
                          order: order,
                          onPressed: () => onPressed!(order),
                          onTapReduce: () => onTapReduce!(order),
                          onTapPlus: () => onTapCreate!(order),
                        ),
                      );
                    },
                  ),
          ),
          OrderTotal(orders: orders),
          SizedBox(height: Parameter.bottomHeight),
        ],
      ),
    );
  }
}

class OrderTotal extends StatelessWidget {
  final List<Menu>? orders;

  const OrderTotal({
    Key? key,
    required this.orders,
  }) : super(key: key);

  int totalPrice(List<Menu>? orders) {
    int result = 0;
    for (var order in orders!) {
      result += int.parse(order.menu.price) * int.parse(order.menu.quantity);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.totalText,
                style: Fontstyle.subtitle(Palette.orderColor),
              ),
            ),
            Text(
              '${totalPrice(orders)}',
              style: Fontstyle.subtitle(Palette.orderColor),
            ),
          ],
        ),
      );
}
