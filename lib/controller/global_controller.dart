import 'package:get/get.dart';
import 'package:schoolman/current_state.dart';
import 'package:schoolman/model/school.dart';
import 'package:schoolman/model/user.dart';
import 'package:schoolman/view/mainpage.dart';
import 'package:schoolman/view/input_school_info.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:developer';
import 'package:schoolman/apitools/api_service.dart';

class GlobalController extends GetxController {
  static GlobalController instance = Get.find();
  final storage = const FlutterSecureStorage();

  Rx<CurrentState> _state = CurrentState().obs;
  get state => _state.value;

  Rx<User?> _user = Rx(null);
  Rx<School?> _school = Rx(null);

  User? get user => _user.value;
  School? get school => _school.value;


  @override
  onInit() async {
    final userJson = await storage.read(key: "user");
    if (userJson != null) {
      _user = Rx<User?>(User.parse(userJson));
      await fetchSchoolInfo();
    } else {
      _user = Rx<User?>(null);
    }
    _setInitialScreen();

    super.onInit();
  }

  _setInitialScreen() {
    if (user != null && school != null) {
      log("All infos are filled");
      Get.offAll(() => MainPage());
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
    _setInitialScreen();
  }

  signOut() {
    storage.delete(key: "user");
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
      _state.value = ErrorState(error.toString());
    }
  }
}