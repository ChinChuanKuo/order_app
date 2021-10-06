import 'package:order_app/json/json.dart';
import 'package:order_app/models/models.dart';

class Shop {
  ShopJson shop;
  List<Menu> items;
  bool opened;
  bool closed;

  Shop({
    required this.shop,
    required this.items,
    required this.opened,
    required this.closed,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      shop: ShopJson.fromJson(json["shop"]),
      items: json["items"].map<Menu>((data) => Menu.fromJson(data)).toList(),
      opened: json["opened"] == true,
      closed: json["closed"] == true,
    );
  }
}
