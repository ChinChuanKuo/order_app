class RequireidJson {
  String orderid;

  RequireidJson({
    required this.orderid,
  });

  static Map<String, dynamic> initialState(RequireidJson requireid) =>
      {'orderid': requireid.orderid};

  factory RequireidJson.fromJson(Map<String, dynamic> json) {
    return RequireidJson(
      orderid: json["orderid"] as String,
    );
  }
}
