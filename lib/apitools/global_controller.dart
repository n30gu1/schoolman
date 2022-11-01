import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Firebase;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:schoolman/model/school.dart';
import 'package:schoolman/model/user.dart';
import 'dart:developer';
import 'package:schoolman/apitools/api_service.dart';
import 'package:schoolman/view/input_school_info/input_school_info.dart';
import 'package:schoolman/view/sign_in/sign_in_page.dart';
import 'package:schoolman/view/tabview.dart';
import 'package:uuid/uuid.dart';

class GlobalController extends GetxController {
  final _localStorage = FlutterSecureStorage();
  final _auth = Firebase.FirebaseAuth.instance;

  User? user = null;
  UserProfile? userProfile = null;
  School? school = null;

  @override
  onInit() {
    _auth.userChanges().listen((event) {
      _setInitialScreen();
    });

    super.onInit();
  }

  _setInitialScreen() async {
    if (_auth.currentUser != null) {
      final currentProfile = await _localStorage.read(key: "currentProfile");

      final Map<String, dynamic>? userMap = await () async {
        if (_auth.currentUser != null) {
          if (_auth.currentUser!.isAnonymous) {
            String? json = await _localStorage.read(key: "user");
            return json != null ? jsonDecode(json) : null;
          } else {
            return (await FirebaseFirestore.instance
                    .collection("users")
                    .doc(_auth.currentUser!.uid)
                    .get())
                .data();
          }
        } else {
          return null;
        }
      }();

      if (userMap != null && currentProfile != null) {
        if (userMap["profiles"][currentProfile] == null)
          _localStorage.write(
              key: "currentProfile", value: userMap["mainProfile"]);

        user = User.fromMap(userMap);
        userProfile = user!.profiles[currentProfile];
        await fetchSchoolInfo();
      } else if (currentProfile == null && userMap != null) {
        _localStorage.write(
            key: "currentProfile", value: userMap["mainProfile"]);

        user = User.fromMap(userMap);
        userProfile = user!.profiles[user!.mainProfile];
        await fetchSchoolInfo();
      } else {
        user = null;
        userProfile = null;
      }
    }

    if (user != null &&
        userProfile != null &&
        school != null &&
        _auth.currentUser != null) {
      log("All infos are filled");
      // change(TabView(), status: RxStatus.success());
      Get.offAll(() => TabView(),
          popGesture: false, transition: Transition.fadeIn);
    } else if (_auth.currentUser != null) {
      Get.offAll(() => InputSchoolInfo(),
          popGesture: false, transition: Transition.fadeIn);
    } else {
      log("Infos insufficient");
      // change(SignInPage(), status: RxStatus.success());
      Get.offAll(() => SignInPage(),
          popGesture: false, transition: Transition.fadeIn);
    }
  }

  submitNewUser(String regionCode, String schoolCode, String schoolName,
      int grade, String className, int studentNumber, String name) async {
    String uuid = () {
      Uuid uuid = Uuid();
      return uuid.v4();
    }();
    UserProfile profile = UserProfile(
        regionCode: regionCode,
        schoolCode: schoolCode,
        grade: grade,
        className: className,
        studentNumber: studentNumber,
        authorized: false,
        id: uuid);
    User newUser =
        User(profiles: {uuid: profile}, mainProfile: uuid, todoDone: []);

    if (_auth.currentUser!.isAnonymous) {
      final doc = await _localStorage.read(key: "user");
      if (doc != null) {
        final docMap = jsonDecode(doc);
        docMap["profiles"][uuid] = profile.toMap();
        _localStorage.write(key: "user", value: jsonEncode(docMap));
      } else {
        _localStorage.write(key: "user", value: jsonEncode(newUser.toMap()));
      }
    } else {
      final doc = FirebaseFirestore.instance
          .collection("users")
          .doc(_auth.currentUser!.uid);
      final data = await doc.get();
      if (data.exists) {
        final data = (await doc.get()).data()!;
        data["profiles"][uuid] = profile.toMap();
        doc.update(data);
      } else {
        doc.set(newUser.toMap());
        _auth.currentUser!.updateDisplayName(name);
      }
    }

    switchUser(uuid);
  }

  switchUser(String profileID) {
    _localStorage.write(key: "currentProfile", value: profileID);

    Get.deleteAll();
    _setInitialScreen();
  }

  signOut() {
    _auth.signOut();
    user = null;
    userProfile = null;
    school = null;
    _localStorage.delete(key: "currentProfile");
  }

  fetchSchoolInfo() async {
    String schoolCode = userProfile!.schoolCode;
    String regionCode = userProfile!.regionCode;

    try {
      school =
          await APIService.instance.fetchSchoolInfo(regionCode, schoolCode);
    } catch (error) {
      throw error;
      // TODO: Show error message on view
      // Get.snackbar(S.of(context).somethingWentWrong, error.toString());
    }
  }

  Future<bool> validateAdmin() async {
    String schoolCode = userProfile!.schoolCode;
    String regionCode = userProfile!.regionCode;
    final schoolData = (await FirebaseFirestore.instance
            .collection(regionCode)
            .doc(schoolCode)
            .get())
        .data();
    print(schoolData);
    if (schoolData != null) {
      if (schoolData["admins"].contains(_auth.currentUser!.uid)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
