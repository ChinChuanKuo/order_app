import 'package:order_app/json/json.dart';

class Store {
  RequireidJson requireid;
  MenuJson menu;
  StoreJson money;
  DataJson stdate;
  DataJson endate;
  bool success;
  bool failed;

  Store({
    required this.requireid,
    required this.menu,
    required this.money,
    required this.stdate,
    required this.endate,
    required this.success,
    required this.failed,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      requireid: RequireidJson.fromJson(json["requireid"]),
      menu: MenuJson.fromJson(json["menu"]),
      money: StoreJson.fromJson(json["money"]),
      stdate: DataJson.fromJson(json["stdate"]),
      endate: DataJson.fromJson(json["endate"]),
      success: json["success"] == true,
      failed: json["failed"] == true,
    );
  }
}
