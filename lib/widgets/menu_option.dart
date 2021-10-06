import 'package:flutter/material.dart';
import 'package:order_app/config/config.dart';
import 'package:order_app/models/models.dart';
import 'package:order_app/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MenuOption extends StatefulWidget {
  final Menu menu;
  final void Function(Menu menu)? onCreate;
  final void Function(Menu menu)? onModify;
  final void Function(Menu menu)? onReduce;

  const MenuOption({
    Key? key,
    required this.menu,
    required this.onCreate,
    required this.onModify,
    required this.onReduce,
  }) : super(key: key);

  @override
  _MenuOptionState createState() => _MenuOptionState();
}

class _MenuOptionState extends State<MenuOption> {
  late Menu menu;

  @override
  void initState() {
    menu = this.widget.menu;
    // TODO: implement initState
    super.initState();
  }

  void onPressedCancel() => Navigator.pop(context);

  void onPressedReduce(Menu menu) =>
      setState(() => this.widget.menu.menu.quantity =
          (int.parse(menu.menu.quantity) - 1).toString());

  void onPressedPlus(Menu menu) =>
      setState(() => this.widget.menu.menu.quantity =
          (int.parse(menu.menu.quantity) + 1).toString());

  void onPressedSure() {
    int.parse(menu.menu.quantity) > 0
        ? menu.ordered
            ? this.widget.onModify!(menu)
            : this.widget.onCreate!(menu)
        : this.widget.onReduce!(menu);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool showReduce = int.parse(menu.menu.quantity) > 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SheetTile(
          onCancel: onPressedCancel,
          title:
              '${AppLocalizations.of(context)!.choosedText} ${AppLocalizations.of(context)!.orderText}',
        ),
        Expanded(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: ListTile(
                  title: Text(
                    "${AppLocalizations.of(context)!.nameText}：${menu.menu.name}",
                    style: Fontstyle.subtitle(Colors.black87),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: ListTile(
                  title: Text(
                    "${AppLocalizations.of(context)!.priceText}：${menu.menu.price}",
                    style: Fontstyle.subtitle(Colors.black87),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularButton(
              icon: Icons.remove_outlined,
              onPressed: showReduce ? () => onPressedReduce(menu) : null,
            ),
            SizedBox(width: screenSize.width * 0.025),
            Text(
              menu.menu.quantity,
              style: Fontstyle.info(Colors.black87),
            ),
            SizedBox(width: screenSize.width * 0.025),
            CircularButton(
              icon: Icons.add_outlined,
              onPressed: () => onPressedPlus(menu),
            ),
          ],
        ),
        SizedBox(height: screenSize.height * 0.005),
        SheetButton(
          icon: Icons.check_outlined,
          text: AppLocalizations.of(context)!.sureText,
          onPressed: onPressedSure,
        ),
      ],
    );
  }
}
