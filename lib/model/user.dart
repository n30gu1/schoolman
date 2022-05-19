import 'dart:convert';

class User {
  String regionCode;
  String schoolCode;
  String grade;
  String className;
  bool isAdmin;

  User(
      {required this.regionCode,
      required this.schoolCode,
      required this.grade,
      required this.className,
      required this.isAdmin});

  Map<String, dynamic> toMap() {
    return {
      "regionCode": regionCode,
      "schoolCode": schoolCode,
      "grade": grade,
      "classNum": className,
      "isAdmin": isAdmin
    };
  }

  static User parse(Map map) {
    return User(
        regionCode: map["regionCode"],
        schoolCode: map["schoolCode"],
        grade: map["grade"],
        className: map["classNum"],
        isAdmin: map["isAdmin"]);
  }
}
