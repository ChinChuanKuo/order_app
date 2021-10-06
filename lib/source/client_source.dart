import 'package:shared_preferences/shared_preferences.dart';

class ClientSource {
  static Future settingState(Map<String, dynamic> json) async {
    final instance = await SharedPreferences.getInstance();
    instance.setString("clientid", json["clientid"]);
    instance.setString("accesstoken", json["accesstoken"]);
  }

  static Future removeState() async {
    final instance = await SharedPreferences.getInstance();
    instance.remove("clientid");
    instance.remove("accesstoken");
  }

  static Future<Map<String, dynamic>> initialState() async {
    final instance = await SharedPreferences.getInstance();
    return {
      'clientid': instance.getString("clientid") ?? "",
      'accesstoken': instance.getString("accesstoken") ?? ""
    };
  }
}
