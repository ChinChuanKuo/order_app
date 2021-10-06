class StoreJson {
  String store;
  String category;
  String balance;

  StoreJson({
    required this.store,
    required this.category,
    required this.balance,
  });

  factory StoreJson.fromJson(Map<String, dynamic> json) {
    return StoreJson(
      store: json["store"] as String,
      category: json["category"] as String,
      balance: json["balance"] as String,
    );
  }
}
