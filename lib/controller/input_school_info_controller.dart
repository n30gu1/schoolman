import 'dart:developer';

import 'package:get/get.dart';
import 'package:schoolman/apitools/api_service.dart';

class InputSchoolInfoController extends GetxController {
  RxBool isLoading = true.obs;
  RxList schoolList = [].obs;
  List schoolListOriginal = [];

  @override
  void onInit() {
    fetchSchools();
    super.onInit();
  }

  void fetchSchools() async {
    isLoading.value = true;
    try {
      schoolListOriginal = await APIService.instance.fetchSchool();
      schoolList.value = schoolListOriginal;
      isLoading.value = false;
    } catch (e) {
      log(e.toString());
    }
  }

  void search(String query) {
    schoolList.clear();
    if (query.isEmpty) {
      schoolList.value = schoolListOriginal;
    } else {
      print(schoolListOriginal);
      for (var element in schoolListOriginal) {
        print(element["SCHUL_NM"]);
        if (element["SCHUL_NM"].toString().contains(query)) {
          schoolList.add(element);
        }
      }
    }

    print(schoolList);
  }
}
