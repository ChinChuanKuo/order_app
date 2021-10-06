import 'package:flutter/material.dart';
import 'package:order_app/config/config.dart';
import 'package:order_app/widgets/widgets.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class SheetTile extends StatelessWidget {
  final void Function() onCancel;
  final String title;
  final bool showed;
  final String? text;
  final RoundedLoadingButtonController? controller;
  final void Function()? onPressed;

  const SheetTile({
    Key? key,
    required this.onCancel,
    required this.title,
    this.showed = false,
    this.text,
    this.controller,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => showed
      ? MobileSheetTile(
          onCancel: onCancel,
          title: title,
          text: text!,
          controller: controller!,
          onPressed: onPressed,
        )
      : DesktopSheetTile(
          onCancel: onCancel,
          title: title,
        );
}

class MobileSheetTile extends StatelessWidget {
  final void Function()? onCancel;
  final String title;
  final String text;
  final RoundedLoadingButtonController controller;
  final void Function()? onPressed;

  const MobileSheetTile({
    Key? key,
    required this.onCancel,
    required this.title,
    required this.text,
    required this.controller,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);
    return Padding(
      padding: EdgeInsets.only(
          right: 15.0,
          left: 15.0,
          top: isTablet ? 10.0 : 6.0,
          bottom: isTablet ? 3.0 : 0.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularButton(
              boxColor: Colors.grey[200],
              icon: Icons.close_outlined,
              onPressed: onCancel,
            ),
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: Fontstyle.header(Colors.black87),
                ),
              ),
            ),
            RoundedLoadingButton(
              elevation: 0.0,
              width: 100.0,
              borderRadius: 24.0,
              color: Palette.orderColor,
              errorColor: Palette.failedColor,
              successColor: Palette.successColor,
              controller: controller,
              child: Text(text),
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}

class DesktopSheetTile extends StatelessWidget {
  final String title;
  final void Function()? onCancel;

  const DesktopSheetTile({
    Key? key,
    required this.title,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: 14.0, left: 15.0, top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  title,
                  style: Fontstyle.header(Colors.black87),
                ),
              ),
            ),
            CircularButton(
              boxColor: Colors.grey[200],
              icon: Icons.close_outlined,
              //iconSize: 21.0,
              onPressed: onCancel,
            ),
          ],
        ),
      );
}
