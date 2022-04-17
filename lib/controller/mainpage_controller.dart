import 'package:get/get.dart';
import 'package:schoolman/apitools/api_service.dart';
import 'package:schoolman/controller/auth_controller.dart';
import '../model/school.dart';

class MainPageController extends GetxController {
  RxBool isLoading = true.obs;
  Rx<School>? schoolInfo;

  @override
  void onInit() {
    // TODO: implement onInit
    fetchSchoolInfo();
    super.onInit();
  }

  void fetchSchoolInfo() async {
    isLoading.value = true;

    String schoolCode = AuthController.instance.user.schoolCode;
    String regionCode = AuthController.instance.user.regionCode;

    schoolInfo = Rx(await APIService.instance.fetchSchoolInfo(regionCode, schoolCode));

    isLoading.value = false;
  }
}