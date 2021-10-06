class ShopJson {
  String name;
  String phone;
  String address;

  ShopJson({
    required this.name,
    required this.phone,
    required this.address,
  });

  static Map<String, dynamic> initialState(ShopJson shopJson) => {
        "name": shopJson.name,
        "phone": shopJson.phone,
        "address": shopJson.address,
      };

  factory ShopJson.fromJson(Map<String, dynamic> json) {
    return ShopJson(
      name: json["name"] as String,
      phone: json["phone"] as String,
      address: json["address"] as String,
    );
  }
}
