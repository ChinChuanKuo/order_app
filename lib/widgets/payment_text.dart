import 'package:flutter/material.dart';
import 'package:order_app/config/config.dart';

class PaymentText extends StatelessWidget {
  final bool paymented;
  final Widget child;

  const PaymentText({
    Key? key,
    required this.paymented,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => paymented
      ? child
      : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            child,
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.5, vertical: 6.0),
              decoration: BoxDecoration(
                color: Color.fromRGBO(56, 233, 158, 0.2),
                borderRadius: BorderRadius.circular(22.5),
              ),
              child: Row(
                children: [
                  Icon(Icons.payment_outlined, color: Palette.successColor),
                  SizedBox(width: 6.0),
                  Text(
                    "已付款",
                    style: Fontstyle.subtitle(Palette.successColor),
                  ),
                ],
              ),
            ),
          ],
        );
}
