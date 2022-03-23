import 'package:get/get.dart';
import 'package:schoolman/model/user.dart';
import 'package:schoolman/main.dart';
import 'package:schoolman/input_user_info.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:developer';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  final storage = const FlutterSecureStorage();

  User get user => _user.value!;

  @override
  onInit() async {
    final userJson = await storage.read(key: "user");
    if (userJson != null) {
      _user = Rx<User?>(User.parse(userJson));
    } else {
      _user = Rx<User?>(null);
    }
    _setInitialScreen(_user.value);

    super.onInit();
  }

  _setInitialScreen(User? user) {
    if (user != null) {
      log("All infos are filled");
      Get.offAll(() => const Launcher());
    } else {
      log("Infos insufficient");
      Get.offAll(() => const InputUserInfo());
    }
  }
}
