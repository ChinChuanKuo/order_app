class MenuJson {
  String name;
  String price;
  String quantity;

  MenuJson({
    required this.name,
    required this.price,
    required this.quantity,
  });

  static Map<String, dynamic> initialState(MenuJson json) =>
      {"name": json.name, "price": json.price, "quantity": json.quantity};

  factory MenuJson.fromJson(Map<String, dynamic> json) {
    return MenuJson(
      name: json["name"] as String,
      price: json["price"] as String,
      quantity: json["quantity"] as String,
    );
  }
}
