import 'package:shared_preferences/shared_preferences.dart';

class DarkedSource {
  static Future settingState(bool darked) async {
    final instance = await SharedPreferences.getInstance();
    instance.setBool("darked", darked);
  }

  static Future<bool> initialState() async {
    final instance = await SharedPreferences.getInstance();
    return instance.getBool("darked") ?? false;
  }
}
