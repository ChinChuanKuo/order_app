import 'package:order_app/json/json.dart';

class Profile {
  SignJson sign;
  DeviceJson device;

  Profile({
    required this.sign,
    required this.device,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      sign: SignJson.fromJson(json["sign"]),
      device: DeviceJson.fromJson(json["device"]),
    );
  }
}
