import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/model/user.dart' as LocalUser;

class SwitchUserController extends GetxController with StateMixin {
  RxMap profiles = Get.find<GlobalController>().user!.profiles.obs;
  Rx<LocalUser.UserProfile> userProfile = Get.find<GlobalController>().userProfile!.obs;
  @override
  void onInit() {
    super.onInit();
  }

  void removeProfile(LocalUser.UserProfile profile) {
    GlobalController gc = Get.find<GlobalController>();
    profiles.remove(profile.id);
    gc.user!.profiles.remove(profile.id);
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(gc.user!.toMap());
    if (profile.id == gc.userProfile!.id) {
      userProfile.value = profiles[gc.user!.mainProfile];
      gc.switchUser(gc.user!.mainProfile);
    }
  }
}
