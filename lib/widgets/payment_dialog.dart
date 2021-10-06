import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:order_app/apis/apis.dart';
import 'package:order_app/config/config.dart';
import 'package:order_app/models/models.dart';
import 'package:order_app/source/source.dart';
import 'package:order_app/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class PaymentDialog extends StatefulWidget {
  final Iterable<Menu> menuinfo;
  final void Function(bool closed)? onSetup;

  const PaymentDialog({
    Key? key,
    required this.menuinfo,
    required this.onSetup,
  }) : super(key: key);

  @override
  _PaymentDialogState createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  late RoundedLoadingButtonController controller;

  @override
  void initState() {
    controller = new RoundedLoadingButtonController();
    // TODO: implement initState
    super.initState();
  }

  void onPressedCancel() => Navigator.pop(context);

  void onPressedSure() async {
    final response = await http
        .post(Uri.http(APi.menu[3]["url"], APi.menu[3]["route"]), body: {
      "clientinfo": json.encode(await ClientSource.initialState()),
      "deviceinfo": json.encode(await DeviceSource.initialState()),
      "menuinfo": json.encode(MenuSource.initialState(this.widget.menuinfo)),
    }, headers: {
      "Accept": "application/json"
    });
    final bool statusCode = response.statusCode == 200;
    if (statusCode) {
      final String status = json.decode(response.body)["status"];
      final bool successed = status == "istrue";
      if (successed) {
        controller.success();
        new Timer(
            new Duration(milliseconds: 5000), () => Navigator.pop(context));
      } else {
        final bool closed = status == "closed";
        this.widget.onSetup!(closed);
        Navigator.pop(context);
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
            Text(closed
                ? AppLocalizations.of(context)!.closeMessageText
                : AppLocalizations.of(context)!.enoughMessageText)
          ]),
        );
      }
    } else {
      Navigator.pop(context);
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SheetTile(
          onCancel: onPressedCancel,
          title: '',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36.0),
          child: Text(
            AppLocalizations.of(context)!.addMenuText,
            style: Fontstyle.subtitle(Colors.black87),
          ),
        ),
        Expanded(child: SizedBox.shrink()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 24.0),
          child: RoundedButton(
            controller: controller,
            icon: Icons.check_outlined,
            text: AppLocalizations.of(context)!.sureText,
            onPressed: onPressedSure,
          ),
        ),
      ],
    );
  }
}
