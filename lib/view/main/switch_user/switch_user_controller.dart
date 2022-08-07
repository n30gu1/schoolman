import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:schoolman/model/user.dart' as LocalUser;

class SwitchUserController extends GetxController with StateMixin {
  @override
  void onInit() {
    fetchSchools();
    super.onInit();
  }

  void fetchSchools() async {
    change(null, status: RxStatus.loading());
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
      "className": firestore["className"],
      "isMainProfile": true
    };

    List additional = firestore["additionalSchools"];

    List<dynamic> mapList = [];
    mapList.add(primary);
    mapList.addAll(additional);

    List<LocalUser.User> result = mapList.map((e) {
      if (e["isMainProfile"] == null) {
        e["isMainProfile"] = false;
      }
      return LocalUser.User.parse(e);
    }).toList();

    change(result, status: RxStatus.success());
  }
}
