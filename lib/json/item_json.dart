class ItemJson {
  String key;
  String data;

  ItemJson({
    required this.key,
    required this.data,
  });

  factory ItemJson.fromJson(Map<String, dynamic> json) {
    return ItemJson(
      key: json["key"] as String,
      data: json["data"] as String,
    );
  }
}
