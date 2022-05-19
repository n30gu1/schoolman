import 'package:firebase_auth/firebase_auth.dart' as Firebase;
import 'package:get/get.dart';
import 'package:schoolman/current_state.dart';
import 'package:schoolman/model/school.dart';
import 'package:schoolman/model/user.dart';
import 'package:schoolman/view/input_school_info/input_school_info.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:developer';
import 'package:schoolman/apitools/api_service.dart';
import 'package:schoolman/view/tabview.dart';

// TODO: GET RID OF LOCAL AUTH SYSTEM
class GlobalController extends GetxController {
  static GlobalController instance = Get.find();
  final storage = const FlutterSecureStorage();
  final _auth = Firebase.FirebaseAuth.instance;

  Rx<CurrentState> _state = CurrentState().obs;
  get state => _state.value;

  Rx<User?> _user = Rx(null);
  Rx<School?> _school = Rx(null);

  User? get user => _user.value;
  School? get school => _school.value;


  @override
  onInit() async {
    if (_auth.currentUser != null) {
    }
    final userJson = await storage.read(key: "user");
    if (userJson != null) {
      _user = Rx<User?>(User.parse(userJson));
      await fetchSchoolInfo();
    } else {
      _user = Rx<User?>(null);
    }
    _setInitialScreen();
    _auth.userChanges().listen((event) {
      print("listen");
      _setInitialScreen();
    });

    super.onInit();
  }

  _setInitialScreen() {
    if (user != null && school != null && _auth.currentUser != null) {
      log("All infos are filled");
      Get.offAll(() => TabView());
    } else {
      log("Infos insufficient");
      Get.offAll(() => InputSchoolInfo());
    }
  }

  submitNewUser(
      String regionCode, String schoolCode, String grade, String classNum) async {
    User newUser = User(
        regionCode: regionCode,
        schoolCode: schoolCode,
        grade: grade,
        className: classNum);
    storage.write(key: "user", value: newUser.toJson());
    _user = Rx<User?>(newUser);
    await fetchSchoolInfo();
    await _auth.signInAnonymously();
    _setInitialScreen();
  }

  signOut() {
    storage.delete(key: "user");
    _auth.signOut();
    _user.value = null;
    _setInitialScreen();
  }

  fetchSchoolInfo() async {
    _state.value = LoadingState();

    String schoolCode = GlobalController.instance.user!.schoolCode;
    String regionCode = GlobalController.instance.user!.regionCode;

    try {
      _school.value = await APIService.instance.fetchSchoolInfo(regionCode, schoolCode);
      _state.value = DoneState();
    } catch (error) {
      Get.snackbar("An Error Occurred", error.toString());
      _state.value = ErrorState(error.toString());
    }
  }
}
