import 'package:order_app/json/json.dart';

class Notice {
  NoticeJson notice;
  RequireidJson requireid;

  Notice({
    required this.notice,
    required this.requireid,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      notice: NoticeJson.fromJson(json["notice"]),
      requireid: RequireidJson.fromJson(json["requireid"]),
    );
  }
}
