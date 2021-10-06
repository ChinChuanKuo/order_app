import 'package:flutter/material.dart';
import 'package:order_app/config/config.dart';
import 'package:order_app/config/palette.dart';
import 'package:order_app/models/models.dart';
import 'package:order_app/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MenuSelector extends StatelessWidget {
  final Menu menu;
  final bool disabled;
  final void Function()? onPressed;

  const MenuSelector({
    Key? key,
    required this.menu,
    required this.disabled,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Responsive.isMobile(context)
      ? MobileMenuSelector(menu: menu, disabled: disabled, onPressed: onPressed)
      : DesktopMenuSelector(
          menu: menu, disabled: disabled, onPressed: onPressed);
}

class MobileMenuSelector extends StatelessWidget {
  final Menu menu;
  final bool disabled;
  final void Function()? onPressed;

  const MobileMenuSelector({
    Key? key,
    required this.menu,
    required this.disabled,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
          title: Text(
            menu.menu.name,
            style: Fontstyle.subtitle(Colors.black87),
          ),
          subtitle: Text(
            "\$${menu.menu.price}",
            style: Fontstyle.subtitle(Colors.black87),
          ),
          trailing: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                "${menu.menu.quantity} 份",
                style: Fontstyle.subtitle(Colors.black87),
              ),
              SizedBox(width: screenSize.width * 0.05),
              ColorsButton(
                text: menu.ordered
                    ? AppLocalizations.of(context)!.editText
                    : AppLocalizations.of(context)!.addText,
                disabled: disabled,
                onPressed: onPressed,
              ),
            ],
          ),
        ),
        Divider(color: Palette.dividerColor),
      ],
    );
  }
}

class DesktopMenuSelector extends StatelessWidget {
  final Menu menu;
  final bool disabled;
  final void Function()? onPressed;

  const DesktopMenuSelector({
    Key? key,
    required this.menu,
    required this.disabled,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
          contentPadding: const EdgeInsets.symmetric(vertical: 6.0),
          title: Text(
            menu.menu.name,
            style: Fontstyle.subtitle(Colors.black87),
          ),
          trailing: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                "\$${menu.menu.price}",
                style: Fontstyle.subtitle(Colors.black87),
              ),
              SizedBox(width: screenSize.width * 0.05),
              ColorsButton(
                text: AppLocalizations.of(context)!.addText,
                disabled: disabled,
                onPressed: onPressed,
              ),
            ],
          ),
        ),
        Divider(color: Palette.dividerColor),
      ],
    );
  }
}
