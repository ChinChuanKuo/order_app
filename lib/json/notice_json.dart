class NoticeJson {
  String imageUrl;
  String message;
  String timeAgo;

  NoticeJson({
    required this.imageUrl,
    required this.message,
    required this.timeAgo,
  });

  factory NoticeJson.fromJson(Map<String, dynamic> json) {
    return NoticeJson(
      imageUrl: json["imageUrl"] as String,
      message: json["message"] as String,
      timeAgo: json["timeAgo"] as String,
      //deviceinfo: Device.fromJson(json["deviceinfo"]),
    );
  }
}
