class User {
  String regionCode;
  String schoolCode;
  String schoolName;
  String grade;
  String? studentNumber;
  String className;
  List<dynamic> todoDone;
  bool isAdmin;
  bool? isMainProfile;
  bool authorized;

  User(
      {required this.regionCode,
      required this.schoolCode,
      required this.schoolName,
      required this.grade,
      this.studentNumber,
      required this.className,
      required this.todoDone,
      required this.isAdmin,
      this.isMainProfile,
      required this.authorized});

  Map<String, dynamic> toMap() {
    return {
      "regionCode": regionCode,
      "schoolCode": schoolCode,
      "schoolName": schoolName,
      "grade": grade,
      "studentNumber": studentNumber,
      "className": className,
      "isAdmin": isAdmin,
      "authorized": authorized
    };
  }

  static User parse(Map map) {
    return User(
        regionCode: map["regionCode"],
        schoolCode: map["schoolCode"],
        schoolName: map["schoolName"],
        grade: map["grade"],
        studentNumber: map["studentNumber"],
        className: map["className"],
        todoDone: map["todoDone"] ?? [],
        isAdmin: map["isAdmin"] ?? false,
        isMainProfile: map["isMainProfile"],
        authorized: map["authorized"] ?? false);
  }
}
