import 'package:order_app/json/json.dart';

class Statist {
  StatistJson statist;
  List colors;

  Statist({
    required this.statist,
    required this.colors,
  });

  factory Statist.fromJson(Map<String, dynamic> json) {
    return Statist(
      statist: StatistJson.fromJson(json["statist"]),
      colors: json["colors"] as List,
    );
  }
}
