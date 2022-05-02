import 'package:get/get.dart';
import 'package:schoolman/apitools/api_service.dart';
import 'package:schoolman/current_state.dart';

// TODO: Fix Searching Algorithm

class InputSchoolInfoController extends GetxController {
  Rx<CurrentState> _state = CurrentState().obs;
  get state => _state.value;

  RxList schoolList = [].obs;
  late List _schoolListOriginal;

  @override
  void onInit() {
    fetchSchools();
    super.onInit();
  }

  void fetchSchools() async {
    _state.value = LoadingState();
    try {
      _schoolListOriginal =
          List.unmodifiable(await APIService.instance.fetchSchoolList());
      schoolList.addAll(_schoolListOriginal);
      _state.value = DoneState();
    } catch (error) {
      _state.value = ErrorState(error.toString());
    }
  }

  void search(String query) {
    List queryList = [];

    if (query.isEmpty) {
      schoolList.clear();
      schoolList.addAll(_schoolListOriginal);
    } else {
      for (var element in _schoolListOriginal) {
        if (element["SCHUL_NM"].toString().contains(query)) {
          queryList.add(element);
        }
        schoolList.clear();
        schoolList.addAll(queryList);
      }
    }
  }
}
