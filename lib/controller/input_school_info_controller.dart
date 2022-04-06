import 'dart:convert';

import 'package:get/get.dart';
import 'package:schoolman/apitools/api_service.dart';

class InputSchoolInfoController extends GetxController {
  RxBool isLoading = true.obs;
  RxList schoolList = [].obs;
  late List _schoolListOriginal;

  @override
  void onInit() {
    fetchSchools();
    super.onInit();
  }

  void fetchSchools() async {
    isLoading.value = true;
    _schoolListOriginal =
        List.unmodifiable(await APIService.instance.fetchSchool());
    schoolList.value = List.from(_schoolListOriginal);
    isLoading.value = false;
  }

  void search(String query) {
    schoolList.clear();
    print(_schoolListOriginal);
    if (query.isEmpty) {
      schoolList.value = _schoolListOriginal;
    } else {
      for (var element in _schoolListOriginal) {
        if (element["SCHUL_NM"].toString().contains(query)) {
          schoolList.add(element);
        }
      }
    }
  }
}
