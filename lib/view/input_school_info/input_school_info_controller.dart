import 'dart:async';

import 'package:get/get.dart';
import 'package:schoolman/apitools/api_service.dart';
import 'package:schoolman/current_state.dart';
import 'package:schoolman/model/school.dart';

class InputSchoolInfoController extends GetxController {
  Rx<CurrentState> _state = CurrentState().obs;
  Timer? _timer;

  get state => _state.value;

  RxList schoolList = [].obs;

  @override
  void onInit() {
    super.onInit();
  }

  void search(String query) {
    _timer?.cancel();
    if (query.isEmpty) {
      schoolList.clear();
    } else {
      schoolList.clear();
      _timer = Timer(Duration(milliseconds: 500), () async {
        schoolList.addAll(await APIService.instance.fetchSchoolList(query));
      });
    }
  }
}
