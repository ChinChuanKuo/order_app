import 'package:order_app/json/json.dart';

class Menu {
  MenuJson menu;
  RequireidJson requireid;
  bool ordered;
  ActionJson action; //inserted, modified, deleted

  Menu({
    required this.menu,
    required this.requireid,
    required this.ordered,
    required this.action,
  });

  static Map<String, dynamic> initialState(Menu menu) => {
        "menu": MenuJson.initialState(menu.menu),
        "requireid": RequireidJson.initialState(menu.requireid),
        "ordered": menu.ordered,
        "action": ActionJson.initialState(menu.action),
      };

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      menu: MenuJson.fromJson(json["menu"]),
      requireid: RequireidJson.fromJson(json["requireid"]),
      ordered: json["ordered"] == true,
      action: ActionJson.fromJson(json["action"]),
    );
  }
}
