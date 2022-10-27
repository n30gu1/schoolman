class User {
  Map<String, UserProfile> profiles;
  String mainProfile;
  List<dynamic> todoDone;

  User({required this.profiles, required this.mainProfile, required this.todoDone});

  static User fromMap(Map<String, dynamic> map) {
    Map<String, UserProfile> profiles = {};
    map["profiles"].forEach((key, value) {
      profiles[key] = UserProfile.fromMap(value);
    });
    return User(
      profiles: profiles,
      mainProfile: map["mainProfile"],
      todoDone: map["todoDone"],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> profiles = {};
    this.profiles.forEach((key, value) {
      profiles[key] = value.toMap();
    });
    return {
      "profiles": profiles,
      "mainProfile": mainProfile,
      "todoDone": todoDone,
    };
  }
}

class UserProfile {
  String regionCode;
  String schoolCode;
  int grade;
  String className;
  int studentNumber;

  bool authorized;

  String id;

  UserProfile(
      {required this.regionCode,
      required this.schoolCode,
      required this.grade,
      required this.className,
      required this.studentNumber,
      required this.authorized,
      required this.id});

  static UserProfile fromMap(Map map) {
    return UserProfile(
        regionCode: map["regionCode"],
        schoolCode: map["schoolCode"],
        grade: map["grade"],
        className: map["className"],
        studentNumber: map["studentNumber"],
        authorized: map["authorized"],
        id: map["id"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "regionCode": regionCode,
      "schoolCode": schoolCode,
      "grade": grade,
      "className": className,
      "studentNumber": studentNumber,
      "authorized": authorized,
      "id": id
    };
  }
}