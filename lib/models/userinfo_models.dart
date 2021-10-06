import 'package:order_app/json/json.dart';

class UserInfo {
  ClientJson client;
  String name;
  String imageUrl;

  UserInfo({
    required this.client,
    required this.name,
    required this.imageUrl,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      client: ClientJson.fromJson(json["client"]),
      name: json["name"] as String,
      imageUrl: json["imageUrl"] as String,
    );
  }
}
