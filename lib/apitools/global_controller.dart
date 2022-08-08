import 'dart:convert';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Firebase;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:schoolman/model/school.dart';
import 'package:schoolman/model/user.dart';
import 'dart:developer';
import 'package:schoolman/apitools/api_service.dart';
import 'package:schoolman/view/sign_in/sign_in_page.dart';
import 'package:schoolman/view/tabview.dart';

class GlobalController extends GetxController with StateMixin {
  static GlobalController instance = Get.find();
  final storage = FirebaseFirestore.instance.collection("users");
  final _localStorage = FlutterSecureStorage();
  final _auth = Firebase.FirebaseAuth.instance;

  Rx<User?> user = Rx(null);
  Rx<School?> _school = Rx(null);

  School? get school => _school.value;

  @override
  onInit() {
    _auth.userChanges().listen((event) {
      print("listen");
      _setInitialScreen();
    });

    if (defaultTargetPlatform == TargetPlatform.macOS) _configureWindow();

    super.onInit();
  }

  _configureWindow() {
    doWhenWindowReady(() {
      final win = appWindow;
      const initialSize = Size(600, 450);
      win.minSize = initialSize;
      win.size = initialSize;
      win.alignment = Alignment.center;
      win.title = "Custom window with Flutter";
      win.show();
    });
  }

  _setInitialScreen() async {
    change(null, status: RxStatus.loading());
    if (_auth.currentUser != null) {
      final currentUser = await _localStorage.read(key: "currentSchool") != null
          ? jsonDecode((await _localStorage.read(key: "currentSchool"))!)
          : null;
      final userMap = (await storage.doc(_auth.currentUser!.uid).get()).data();

      if (userMap != null &&
          currentUser != null &&
          userMap["schoolCode"] == currentUser["schoolCode"] &&
          userMap["grade"] == currentUser["grade"] &&
          userMap["className"] == currentUser["className"]) {
        userMap["isMainProfile"] = true;
        user = Rx<User?>(await User.parse(userMap));
        await fetchSchoolInfo();
      } else if (currentUser != null) {
        currentUser["isMainProfile"] = false;
        user = Rx<User?>(await User.parse(currentUser));
        await fetchSchoolInfo();
      } else if (currentUser == null && userMap != null) {
        _localStorage.write(key: "currentSchool", value: jsonEncode(userMap));
        user = Rx<User?>(await User.parse(userMap));
      } else {
        user = Rx<User?>(null);
      }
    }

    if (user.value != null && school != null && _auth.currentUser != null) {
      log("All infos are filled");
      change(TabView(), status: RxStatus.success());
    } else {
      log("Infos insufficient");
      change(SignInPage(), status: RxStatus.success());
    }
  }

  submitNewUser(
      String regionCode,
      String schoolCode,
      String schoolName,
      String grade,
      String classNum,
      String studentNumber,
      String name,
      bool isMainProfile) async {
    User newUser = User(
        regionCode: regionCode,
        schoolCode: schoolCode,
        schoolName: schoolName,
        grade: grade,
        className: classNum,
        studentNumber: studentNumber,
        todoDone: [],
        isAdmin: false,
        isMainProfile: isMainProfile);

    if (isMainProfile) {
      storage.doc(_auth.currentUser!.uid).set(newUser.toMap());
      _auth.currentUser!.updateDisplayName(name);
    } else {
      final data = (await storage.doc(_auth.currentUser!.uid).get()).data();
      if (data!["additionalSchools"] == null) {
        data["additionalSchools"] = [newUser.toMap()];
      } else {
        (data["additionalSchools"] as List).add(newUser.toMap());
      }
      storage.doc(_auth.currentUser!.uid).update(data);
    }

    switchUser(newUser);
  }

  switchUser(User user) {
    final json = jsonEncode(user.toMap());
    _localStorage.write(key: "currentSchool", value: json);

    this.user.value = user;

    Get.deleteAll();
    _setInitialScreen();
  }

  signOut() {
    _auth.signOut();
    user.value = null;
    _setInitialScreen();
  }

  fetchSchoolInfo() async {
    String schoolCode = user.value!.schoolCode;
    String regionCode = user.value!.regionCode;

    try {
      _school.value =
          await APIService.instance.fetchSchoolInfo(regionCode, schoolCode);
    } catch (error) {
      Get.snackbar("An Error Occurred", error.toString());
    }
  }
}
