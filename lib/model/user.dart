class User {
  String regionCode;
  String schoolCode;
  String grade;
  String studentNumber;
  String className;
  List<String> todoDone;
  bool isAdmin;

  User(
      {required this.regionCode,
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
      "grade": grade,
      "studentNumber": studentNumber,
      "classNum": className,
      "isAdmin": isAdmin
    };
  }

  static User parse(Map map) {
    return User(
        regionCode: map["regionCode"],
        schoolCode: map["schoolCode"],
        grade: map["grade"],
        studentNumber: map["studentNumber"],
        className: map["classNum"],
        todoDone: map["todoDone"],
        isAdmin: map["isAdmin"]);
  }
}
