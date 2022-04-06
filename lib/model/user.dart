import 'dart:convert';

class User {
  String regionCode;
  String schoolCode;
  String grade;
  String className;

  User(
      {required this.regionCode,
      required this.schoolCode,
      required this.grade,
      required this.className});

  String toJson() {
    return jsonEncode({
      "regionCode": regionCode,
      "schoolCode": schoolCode,
      "grade": grade,
      "classNum": className
    });
  }

  static User parse(String json) {
    Map<String, dynamic> decoded = jsonDecode(json);
    return User(
        regionCode: decoded["regionCode"],
        schoolCode: decoded["schoolCode"],
        grade: decoded["grade"],
        className: decoded["classNum"]);
  }
}
