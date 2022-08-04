import 'package:schoolman/apitools/api_service.dart';

class User {
  String regionCode;
  List<dynamic> additionalSchools;
  List<Map<String, String>> additionalSchoolNames;
  String schoolCode;
  String grade;
  String studentNumber;
  String className;
  List<dynamic> todoDone;
  bool isAdmin;

  User(
      {required this.regionCode,
      required this.additionalSchools,
      required this.additionalSchoolNames,
      required this.schoolCode,
      required this.grade,
      required this.studentNumber,
      required this.className,
      required this.todoDone,
      required this.isAdmin});

  Map<String, dynamic> toMap() {
    return {
      "regionCode": regionCode,
      "schoolCode": schoolCode,
      "additionalSchools": additionalSchools,
      "grade": grade,
      "studentNumber": studentNumber,
      "className": className,
      "isAdmin": isAdmin
    };
  }

  static Future<User> parse(Map map) async {
    List<Map<String, String>> additionalSchoolNames = [];
    for (var item in map["additionalSchools"]) {
      additionalSchoolNames.add({
        item["schoolCode"]: await APIService.instance
            .fetchSchoolName(item["regionCode"], item["schoolCode"])
      });
    }

    return User(
        regionCode: map["regionCode"],
        schoolCode: map["schoolCode"],
        additionalSchools: map["additionalSchools"],
        additionalSchoolNames: [],
        grade: map["grade"],
        studentNumber: map["studentNumber"],
        className: map["className"],
        todoDone: map["todoDone"],
        isAdmin: map["isAdmin"]);
  }
}
