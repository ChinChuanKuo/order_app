class DeviceJson {
  String memory;
  String device;
  String manufacturer;
  String release;
  String name;
  String uuid;

  DeviceJson({
    required this.memory,
    required this.device,
    required this.manufacturer,
    required this.release,
    required this.name,
    required this.uuid,
  });

  factory DeviceJson.fromJson(Map<String, dynamic> json) {
    return DeviceJson(
      memory: json["memory"] as String,
      device: json["device"] as String,
      manufacturer: json["manufacturer"] as String,
      release: json["release"] as String,
      name: json["name"] as String,
      uuid: json["uuid"] as String,
    );
  }
}
