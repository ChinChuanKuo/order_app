class StatistJson {
  String key;
  int datas;

  StatistJson({
    required this.key,
    required this.datas,
  });

  factory StatistJson.fromJson(Map<String, dynamic> json) {
    return StatistJson(
      key: json["key"] as String,
      datas: json["datas"] as int,
    );
  }
}
