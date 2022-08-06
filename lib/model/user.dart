import 'package:schoolman/apitools/api_service.dart';

class User {
  String regionCode;
  String schoolCode;
  String schoolName;
  String grade;
  String studentNumber;
  String className;
  List<dynamic> todoDone;
  bool isAdmin;
  bool isMainProfile;

  User(
      {required this.regionCode,
      required this.schoolCode,
      required this.schoolName,
      required this.grade,
      required this.studentNumber,
      required this.className,
      required this.todoDone,
      required this.isAdmin,
      required this.isMainProfile});

  Map<String, dynamic> toMap() {
    return {
      "regionCode": regionCode,
      "schoolCode": schoolCode,
      "grade": grade,
      "studentNumber": studentNumber,
      "className": className,
      "isAdmin": isAdmin,
      "isMainProfile": isMainProfile
    };
  }

  static Future<User> parse(Map map) async {
    return User(
        regionCode: map["regionCode"],
        schoolCode: map["schoolCode"],
        schoolName: await APIService.instance
            .fetchSchoolName(map["regionCode"], map["schoolCode"]),
        grade: map["grade"],
        studentNumber: map["studentNumber"],
        className: map["className"],
        todoDone: map["todoDone"] ?? [],
        isAdmin: map["isAdmin"],
        isMainProfile: map["isMainProfile"]);
  }
}
