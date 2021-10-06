class ActionJson {
  bool inserted;
  bool modified;
  bool deleted;

  ActionJson({
    required this.inserted,
    required this.modified,
    required this.deleted,
  });

  static Map<String, dynamic> initialState(ActionJson actionJson) => {
        "inserted": actionJson.inserted,
        "modified": actionJson.modified,
        "deleted": actionJson.deleted,
      };

  factory ActionJson.fromJson(Map<String, dynamic> json) {
    return ActionJson(
      inserted: json["inserted"] == true,
      modified: json["modified"] == true,
      deleted: json["deleted"] == true,
    );
  }
}
