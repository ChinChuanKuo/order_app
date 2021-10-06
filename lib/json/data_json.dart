class DataJson {
  String data;

  DataJson({
    required this.data,
  });

  static Map<String, dynamic> initialState(DataJson data) =>
      {'data': data.data};

  factory DataJson.fromJson(Map<String, dynamic> json) =>
      DataJson(data: json["data"] as String);
}
