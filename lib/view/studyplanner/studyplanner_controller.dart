import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/model/school.dart';
import 'package:schoolman/model/studyplan.dart';

class StudyPlannerController extends GetxController with StateMixin {
  @override
  void onInit() {
    GlobalController gc = Get.find<GlobalController>();
    if (gc.userProfile!.id == gc.user!.mainProfile) {
      change(null, status: RxStatus.error("ERROR_NOT_MAIN_PROFILE"));
    } else {
      change(null, status: RxStatus.loading());
      fetchStudyPlanners();
    }

    super.onInit();
  }

  void fetchStudyPlanners() async {
    School school = Get.find<GlobalController>().school!;
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection(school.regionCode)
          .doc(school.schoolCode)
          .collection("planners")
          .get();

      List<StudyPlan> result =
          await snapshot.docs.map((e) => StudyPlan.fromMap(e.data())).toList();

      if (result.isEmpty) {
        change(null, status: RxStatus.empty());
      } else {
        change(result, status: RxStatus.success());
      }
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }
}
