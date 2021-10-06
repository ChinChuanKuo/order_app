import 'package:order_app/json/json.dart';

class Money {
  DataJson item;

  Money({
    required this.item,
  });

  factory Money.fromJson(Map<String, dynamic> json) {
    return Money(
      item: DataJson.fromJson(json["item"]),
    );
  }
}
