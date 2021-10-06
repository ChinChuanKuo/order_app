import 'package:flutter/material.dart';
import 'package:order_app/config/config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:order_app/widgets/widgets.dart';

class OrderLoading extends StatelessWidget {
  const OrderLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
      constraints: BoxConstraints(maxWidth: 280.0),
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              "My ${AppLocalizations.of(context)!.orderText}",
              style: Fontstyle.header(Palette.orderColor),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) =>
                  orderloading(screenSize),
            ),
          ),
          orderTotal(screenSize),
          SizedBox(height: Parameter.bottomHeight),
        ],
      ),
    );
  }

  Widget orderTotal(Size screenSize) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          WidgetShimmer.rectangular(width: 50.0, height: 25.0),
          WidgetShimmer.rectangular(width: 50.0, height: 25.0),
        ],
      );

  Widget orderloading(Size screenSize) => Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24.0)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WidgetShimmer.rectangular(width: 60.0),
                WidgetShimmer.circular(width: 52.0, height: 52.0),
              ],
            ),
            SizedBox(height: screenSize.height * 0.010),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    WidgetShimmer.circular(width: 32.0, height: 32.0),
                    SizedBox(width: screenSize.width * 0.015),
                    WidgetShimmer.rectangular(width: 25.0, height: 25.0),
                    SizedBox(width: screenSize.width * 0.015),
                    WidgetShimmer.circular(width: 32.0, height: 32.0),
                  ],
                ),
                Row(
                  children: [
                    WidgetShimmer.rectangular(width: 32.0, height: 25.0),
                    SizedBox(width: 8.0)
                  ],
                ),
              ],
            ),
          ],
        ),
      );
}
