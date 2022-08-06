import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class SwitchUserController extends GetxController with StateMixin {
  FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  void onInit() {
    fetchSchools();
    super.onInit();
  }

  void fetchSchools() async {
    var firestore = await () async {
      var snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      return await snapshot.data()!;
    }();

    Map<String, dynamic> primary = {
      "regionCode": firestore["regionCode"],
      "schoolCode": firestore["schoolCode"],
      "schoolName": firestore["schoolName"],
      "grade": firestore["grade"],
      "className": firestore["className"]
    };

    var additional = firestore["additionalSchools"];

    List<dynamic> result = [];
    result.add(primary);
    result.addAll(additional);

    print(result);

    change(result, status: RxStatus.success());
  }

  void switchUser(Map item) {}
}
