import 'package:flutter/material.dart';
import 'package:order_app/config/config.dart';
import 'package:order_app/models/models.dart';
import 'package:order_app/widgets/widgets.dart';

class OrderSelector extends StatelessWidget {
  final bool closed;
  final Menu order;
  final void Function()? onPressed;
  final void Function()? onTapReduce;
  final void Function()? onTapPlus;

  const OrderSelector({
    Key? key,
    required this.closed,
    required this.order,
    required this.onPressed,
    required this.onTapReduce,
    required this.onTapPlus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        color: Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  order.menu.name,
                  style: Fontstyle.subtitle(Colors.black87),
                ),
              ),
              closed
                  ? SizedBox(height: 48.0)
                  : CircularButton(
                      icon: Icons.clear_outlined,
                      onPressed: onPressed,
                    ),
            ],
          ),
          SizedBox(height: screenSize.height * 0.01),
          Row(
            children: [
              Expanded(
                child: QuantitySetting(
                  closed: closed,
                  quantity: order.menu.quantity,
                  onTapReduce: onTapReduce,
                  onTapPlus: onTapPlus,
                ),
              ),
              Text(
                "\$${order.menu.price}",
                style: Fontstyle.subtitle(Colors.black87),
              ),
              SizedBox(width: screenSize.width * 0.01),
            ],
          ),
        ],
      ),
    );
  }
}
