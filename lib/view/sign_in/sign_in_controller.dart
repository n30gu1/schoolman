import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:schoolman/nonce_generator.dart';
import 'package:schoolman/view/input_school_info/input_school_info.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter/foundation.dart';

class SignInController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final _auth = FirebaseAuth.FirebaseAuth.instance;

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
    } catch (e) {}
  }

  void signInAnonymously() async {
    await _auth.signInAnonymously();
    Get.offAll(() => InputSchoolInfo());
  }

  Future<FirebaseAuth.UserCredential> signInWithGoogle() async {
    if (kIsWeb) {
      // Create a new provider
      FirebaseAuth.GoogleAuthProvider googleProvider =
          FirebaseAuth.GoogleAuthProvider();

      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly')
        ..addScope('https://www.googleapis.com/auth/userinfo.email')
        ..addScope('https://www.googleapis.com/auth/userinfo.profile');
      googleProvider.setCustomParameters({});

      // Once signed in, return the UserCredential
      return await FirebaseAuth.FirebaseAuth.instance
          .signInWithPopup(googleProvider);
    } else {
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
      return signedInUserCredential;
    }
  }

  Future<FirebaseAuth.UserCredential> signInWithApple() async {
    if (kIsWeb) {
      // Create and configure an OAuthProvider for Sign In with Apple.
      final provider = FirebaseAuth.OAuthProvider("apple.com")
        ..addScope('email')
        ..addScope('name');

      // Sign in the user with Firebase.
      return await FirebaseAuth.FirebaseAuth.instance.signInWithPopup(provider);
    } else {
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
      final oauthCredential =
          FirebaseAuth.OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      FirebaseAuth.UserCredential signedInUserCredential = await FirebaseAuth
          .FirebaseAuth.instance
          .signInWithCredential(oauthCredential);

      signedInUserCredential.user!.updateDisplayName(
          (appleCredential.familyName ?? "") +
              (appleCredential.givenName ?? ""));

      return signedInUserCredential;
    }
  }
}
