import 'package:order_app/models/models.dart';

class MenuSource {
  static List<Map<String, dynamic>> initialState(Iterable<Menu> menus) {
    List<Map<String, dynamic>> items = [];
    for (var menu in menus) items.add(Menu.initialState(menu));
    return items;
  }
}
