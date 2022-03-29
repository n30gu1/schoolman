import 'dart:convert';

class User {
  int schoolCode;
  int grade;
  int classNum;

  User({required this.schoolCode, required this.grade, required this.classNum});

  String toJson() {
    return jsonEncode(
        {"schoolCode": schoolCode, "grade": grade, "classNum": classNum});
  }

  static User parse(String json) {
    Map<String, dynamic> decoded = jsonDecode(json);
    return User(
        schoolCode: int.parse(decoded["schoolCode"]),
        grade: int.parse(decoded["grade"]),
        classNum: int.parse(decoded["classNum"]));
  }
}
