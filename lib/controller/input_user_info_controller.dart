import 'package:get/get.dart';
import 'package:schoolman/apitools/api_service.dart';
import 'dart:developer';

class InputUserInfoController extends GetxController {
  late String schoolCode;
  late String regionCode;
  RxBool isLoading = true.obs;
  RxList classInfo = [].obs;

  InputUserInfoController(this.regionCode, this.schoolCode);

  @override
  void onInit() {
    fetchClassInfo();
    super.onInit();
  }

  void fetchClassInfo() async {
    isLoading.value = true;
    try {
      classInfo.addAll(
          await APIService.instance.fetchClassInfo(regionCode, schoolCode));
      isLoading.value = false;
    } catch (e) {
      log(e.toString());
    }
  }
}
