class SignJson {
  String userid;
  String username;
  String birthday;
  String department;
  String workpress;

  SignJson({
    required this.userid,
    required this.username,
    required this.birthday,
    required this.department,
    required this.workpress,
  });

  factory SignJson.fromJson(Map<String, dynamic> json) {
    return SignJson(
      userid: json["userid"] as String,
      username: json["username"] as String,
      birthday: json["birthday"] as String,
      department: json["department"] as String,
      workpress: json["workpress"] as String,
    );
  }
}
