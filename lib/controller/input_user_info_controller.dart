import 'package:get/get.dart';
import 'package:schoolman/apitools/api_service.dart';
import 'dart:developer';

class InputUserInfoController extends GetxController {
  late String schoolCode;
  late String regionCode;
  late Map gradeMap;

  RxBool isLoading = true.obs;

  RxString gradeSelected = "".obs;
  RxString classSelected = "".obs;

  InputUserInfoController(this.regionCode, this.schoolCode);

  @override
  void onInit() {
    fetchClassInfo();
    super.onInit();
  }

  void fetchClassInfo() async {
    isLoading.value = true;
    try {
      gradeMap = await createMap(
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
}
