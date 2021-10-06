import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:order_app/apis/apis.dart';
import 'package:order_app/config/config.dart';
import 'package:order_app/json/json.dart';
import 'package:order_app/models/models.dart';
import 'package:order_app/source/source.dart';
import 'package:order_app/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ReduceDialog extends StatefulWidget {
  final Menu menu;
  final int index;
  final bool deleted;
  final void Function(int index)? onRemove;
  final void Function(bool closed)? onClosed;
  final void Function(Menu menu)? onReduce;

  const ReduceDialog({
    Key? key,
    required this.menu,
    required this.index,
    required this.deleted,
    required this.onRemove,
    required this.onClosed,
    required this.onReduce,
  }) : super(key: key);

  @override
  _ReduceDialogState createState() => _ReduceDialogState();
}

class _ReduceDialogState extends State<ReduceDialog> {
  late RoundedLoadingButtonController controller;

  @override
  void initState() {
    controller = new RoundedLoadingButtonController();
    // TODO: implement initState
    super.initState();
  }

  void onPressedCancel() => Navigator.pop(context);

  void onPressedSure() async {
    this.widget.onReduce!(this.widget.menu);
    if (this.widget.deleted) {
      final response = await http
          .post(Uri.http(APi.menu[4]["url"], APi.menu[4]["route"]), body: {
        "clientinfo": json.encode(await ClientSource.initialState()),
        "deviceinfo": json.encode(await DeviceSource.initialState()),
        "requiredinfo":
            json.encode(RequireidJson.initialState(this.widget.menu.requireid)),
      }, headers: {
        "Accept": "application/json"
      });
      final bool statusCode = response.statusCode == 200;
      if (statusCode) {
        final String status = json.decode(response.body)["status"];
        final bool successed = status == "istrue";
        if (successed) {
          this.widget.onRemove!(this.widget.index);
          controller.success();
          new Timer(
              new Duration(milliseconds: 5000), () => Navigator.pop(context));
        } else {
          final bool closed = status == "closed";
          this.widget.onClosed!(closed);
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
    } else {
      this.widget.onRemove!(this.widget.index);
      controller.success();
      new Timer(new Duration(milliseconds: 5000), () => Navigator.pop(context));
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
            AppLocalizations.of(context)!.reduceMenuText,
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
