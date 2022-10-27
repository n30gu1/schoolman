import 'dart:async';
import 'package:get/get.dart';
import 'package:schoolman/apitools/api_service.dart';

class InputSchoolInfoController extends GetxController with StateMixin {
  Timer? _timer;

  @override
  void onInit() {
    change(null, status: RxStatus.empty());
    super.onInit();
  }

  void search(String query) {
    _timer?.cancel();
    change(null, status: RxStatus.loading());
    if (query.isEmpty) {
      change([], status: RxStatus.success());
    } else {
      _timer = Timer(Duration(milliseconds: 500), () async {
        try {
          List result = await APIService.instance.fetchSchoolList(query);
          change(result, status: RxStatus.success());
        } catch (e) {
          change(null, status: RxStatus.error(e.toString()));
        }
      });
    }
  }
}
