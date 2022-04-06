import 'package:get/get.dart';
import 'package:schoolman/apitools/api_service.dart';
import 'dart:developer';

class InputUserInfoController extends GetxController {
  late String schoolCode;
  late String regionCode;
  RxBool isLoading = true.obs;

  InputUserInfoController(this.regionCode, this.schoolCode);

  @override
  void onInit() {
    fetchClassInfo();
    super.onInit();
  }

  void fetchClassInfo() async {
    isLoading.value = true;
    try {
      createMap(
          await APIService.instance.fetchClassInfo(regionCode, schoolCode));
      isLoading.value = false;
    } catch (e) {
      log(e.toString());
    }
  }

  Future<Map<String, dynamic>> createMap(List classInfo) async {
    Set grade = {};
    Map classMap = {};

    for (var element in classInfo) {
      grade.add(element["GRADE"]);
    }

    for (var gradeElement in grade) {
      classMap.addAll({gradeElement.toString(): Set()});
      classInfo.forEach((element) {
        if (element["GRADE"].toString().contains(gradeElement)) {
          classMap[gradeElement.toString()].add(element["CLASS_NM"]);
        }
      });
    }

    return {"grades": grade, "classes": classMap};
  }
}
