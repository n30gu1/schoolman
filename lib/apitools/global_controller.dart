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
  final _auth = Firebase.FirebaseAuth.instance;

  Rx<User?> _user = Rx(null);
  Rx<School?> _school = Rx(null);

  User? get user => _user.value;
  School? get school => _school.value;

  @override
  onInit() {
    _setInitialScreen();
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
      final userMap = await storage.doc(_auth.currentUser!.uid).get();
      if (userMap.exists) {
        _user = Rx<User?>(await User.parse(userMap.data()!));
        await fetchSchoolInfo();
      } else {
        _user = Rx<User?>(null);
      }
    }

    if (user != null && school != null && _auth.currentUser != null) {
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
      String grade,
      String classNum,
      String studentNumber,
      String name,
      bool isMainProfile) async {
    User newUser = User(
        regionCode: regionCode,
        schoolCode: schoolCode,
        schoolName:
            await APIService.instance.fetchSchoolName(regionCode, schoolCode),
        grade: grade,
        className: classNum,
        studentNumber: studentNumber,
        todoDone: [],
        isAdmin: false,
        isMainProfile: isMainProfile);

    if (isMainProfile) {
      storage.doc(_auth.currentUser!.uid).set(newUser.toMap());
      _auth.currentUser!.updateDisplayName(name);
    }
    _user = Rx<User?>(newUser);
    await fetchSchoolInfo();
  }

  signOut() {
    _auth.signOut();
    _user.value = null;
    _setInitialScreen();
  }

  fetchSchoolInfo() async {
    FlutterSecureStorage storage = FlutterSecureStorage();

    String schoolCode = user!.schoolCode;
    String regionCode = user!.regionCode;

    try {
      _school.value =
          await APIService.instance.fetchSchoolInfo(regionCode, schoolCode);
    } catch (error) {
      Get.snackbar("An Error Occurred", error.toString());
    }
  }
}
