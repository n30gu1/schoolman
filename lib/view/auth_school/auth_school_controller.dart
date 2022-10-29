import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolman/apitools/global_controller.dart';

class AuthorizeSchoolController extends GetxController with StateMixin {
  final schoolCodeEditingController = TextEditingController();
  final adminSchoolCodeEditingController = TextEditingController();

  @override
  void onInit() {
    change(null, status: RxStatus.success());
    super.onInit();
  }

  void authorizeSchool() async {
    change(null, status: RxStatus.loading());
    try {
      final globalC = Get.find<GlobalController>();
      final regionCode = globalC.school!.regionCode;
      final schoolCode = globalC.school!.schoolCode;
      final authCode = sha256
          .convert(utf8.encode(schoolCodeEditingController.text))
          .toString();
      final schoolHash = await FirebaseFirestore.instance
          .collection(regionCode)
          .doc(schoolCode)
          .get()
          .then((value) => value.data()?["authCode"]);

      if (schoolHash == authCode) {
        globalC.userProfile!.authorized = true;
        await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          "profiles": {globalC.userProfile!.id: globalC.userProfile!.toMap()}
        });
        change(null, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.error("Invalid code"));
      }
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  void updateAuthCode() async {
    final globalC = Get.find<GlobalController>();
    if (await globalC.validateAdmin()) {
      change(null, status: RxStatus.loading());
      try {
        final regionCode = globalC.school!.regionCode;
        final schoolCode = globalC.school!.schoolCode;
        final authCode = sha256
            .convert(utf8.encode(adminSchoolCodeEditingController.text))
            .toString();
        await FirebaseFirestore.instance
            .collection(regionCode)
            .doc(schoolCode)
            .update({"authCode": authCode});
        change(null, status: RxStatus.success());
      } catch (e) {
        change(null, status: RxStatus.error(e.toString()));
      }
    }
  }
}
