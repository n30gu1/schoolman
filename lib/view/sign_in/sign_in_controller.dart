import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:schoolman/nonce_generator.dart';
import 'package:schoolman/view/input_school_info/input_school_info.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignInController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final _auth = FirebaseAuth.FirebaseAuth.instance;

  SignInController();

  @override
  void onInit() {
    super.onInit();
  }

  void signUp() async {
    await _auth.createUserWithEmailAndPassword(
        email: emailController.text, password: passwordController.text);

    if (_auth.currentUser != null) {
      _auth.currentUser!.updateDisplayName(nameController.text);
      Get.offAll(() => InputSchoolInfo());
    }
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

    var snapshot = await GlobalController.instance.storage
        .doc(signedInUserCredential.user?.uid)
        .get();
    if (!snapshot.exists) {
      Get.offAll(() => InputSchoolInfo());
    } else {
      Get.back();
    }
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

    signedInUserCredential.user!.updateDisplayName(
        (appleCredential.familyName ?? "") + (appleCredential.givenName ?? ""));

    var snapshot = await GlobalController.instance.storage
        .doc(signedInUserCredential.user?.uid)
        .get();
    if (!snapshot.exists) {
      Get.offAll(() => InputSchoolInfo());
    } else {
      Get.back();
    }

    return signedInUserCredential;
  }
}
