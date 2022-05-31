import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolman/apitools/api_service.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/current_state.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:schoolman/nonce_generator.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignInController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final studentNumberController = TextEditingController();
  final _auth = FirebaseAuth.FirebaseAuth.instance;
  late String schoolCode;
  late String regionCode;
  late Map gradeMap;

  Rx<CurrentState> _state = CurrentState().obs;

  get state => _state.value;

  RxString gradeSelected = "".obs;
  RxString classSelected = "".obs;

  SignInController(this.regionCode, this.schoolCode);

  @override
  void onInit() {
    fetchClassInfo();
    super.onInit();
  }

  void fetchClassInfo() async {
    _state.value = LoadingState();
    try {
      gradeMap = await createMap(
          await APIService.instance.fetchClassInfo(regionCode, schoolCode));
      _state.value = DoneState();
    } catch (e) {
      log(e.toString());
      _state.value = ErrorState(e.toString());
    }
  }

  Future<Map<String, dynamic>> createMap(List classInfo) async {
    Set grade = {};
    Map classMap = {};

    for (var element in classInfo) {
      grade.add(element["GRADE"]);
    }

    for (var gradeElement in grade) {
      classMap.addAll({gradeElement.toString(): []});
      classInfo.forEach((element) {
        if (element["GRADE"].toString().contains(gradeElement)) {
          classMap[gradeElement.toString()].add(element["CLASS_NM"]);
        }
      });
      classMap[gradeElement.toString()].sort((a, b) {
        var aInt = int.tryParse(a);
        var bInt = int.tryParse(b);

        if (aInt != null && bInt != null) {
          return aInt.compareTo(bInt);
        } else {
          return a.toString().compareTo(b.toString());
        }
      });
    }

    gradeSelected.value = grade.first.toString();
    classSelected.value = classMap[gradeSelected.value].first;
    return {"grades": grade, "classes": classMap};
  }

  void signUp() async {
    await _auth.createUserWithEmailAndPassword(
        email: emailController.text, password: passwordController.text);
    GlobalController.instance.submitNewUser(
        regionCode,
        schoolCode,
        gradeSelected.value,
        classSelected.value,
        studentNumberController.text,
        nameController.text);
  }

  void signIn() async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      Get.back();
    } catch (e) {}
  }

  Future<FirebaseAuth.UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = FirebaseAuth.GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    FirebaseAuth.UserCredential signedInUserCredential = await FirebaseAuth
        .FirebaseAuth.instance
        .signInWithCredential(credential);

    await GlobalController.instance.submitNewUser(
        regionCode,
        schoolCode,
        gradeSelected.value,
        classSelected.value,
        studentNumberController.text,
        signedInUserCredential.user?.displayName ?? "null");

    Get.back();

    return signedInUserCredential;
  }

  Future<FirebaseAuth.UserCredential> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    print(await SignInWithApple.isAvailable());
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = FirebaseAuth.OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    FirebaseAuth.UserCredential signedInUserCredential = await FirebaseAuth
        .FirebaseAuth.instance
        .signInWithCredential(oauthCredential);

    await GlobalController.instance.submitNewUser(
        regionCode,
        schoolCode,
        gradeSelected.value,
        classSelected.value,
        studentNumberController.text,
        signedInUserCredential.user?.displayName ?? "null");

    Get.back();

    return signedInUserCredential;
  }
}
