import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:schoolman/apitools/api_service.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/current_state.dart';
import 'package:schoolman/model/meal.dart';
import 'package:schoolman/model/notice.dart';
import 'package:schoolman/model/schedule.dart';
import 'package:schoolman/model/school.dart';
import 'package:schoolman/model/timetable.dart';

class MainPageController extends GetxController {
  Rx<TimeTable?> _timeTable = Rx(null);
  Rx<Meal?> _meal = Rx(null);
  Rx<Schedule?> _schedule = Rx(null);
  Rx<Notice?> _notice = Rx(null);
  Rx<CurrentState> _state = CurrentState().obs;

  TimeTable? get timeTable => _timeTable.value;

  Meal? get meal => _meal.value;

  Schedule? get schedule => _schedule.value;

  Notice? get notice => _notice.value;

  CurrentState? get state => _state.value;

  @override
  void onInit() {
    fetchItems();
    super.onInit();
  }

  void fetchItems() async {
    _state.value = LoadingState();
    try {
      _timeTable.value = await APIService.instance.fetchTimeTable();
      int now = DateTime.now().hour;
      MealType? _mealType;
      if (GlobalController.instance.school!.schoolType == SchoolType.high) {
        if (now < 8) {
          _mealType = MealType.breakfast;
        } else if (now >= 8 && now < 13) {
          _mealType = MealType.lunch;
        } else if (now >= 13 && now < 19) {
          _mealType = MealType.dinner;
        } else {
          _mealType = MealType.nextDayBreakfast;
        }
      } else {
        if (now < 8) {
          _mealType = MealType.lunch;
        } else if (now >= 8 && now < 13) {
          _mealType = MealType.lunch;
        } else if (now >= 13 && now < 19) {
          _mealType = MealType.nextDayLunch;
        } else {
          _mealType = MealType.nextDayLunch;
        }
      }

      _meal.value = await APIService.instance
          .fetchMeal(_mealType)
          .then((value) => value[0]);

      _schedule.value = (await APIService.instance.fetchSchedule(1))[0];

      School currentSchool = GlobalController.instance.school!;
      QuerySnapshot noticesCollection = await FirebaseFirestore.instance
          .collection("${currentSchool.regionCode}")
          .doc("${currentSchool.schoolCode}")
          .collection("notices")
          .orderBy("timeCreated", descending: true)
          .get();

      _notice.value =
          Notice.fromMap(await noticesCollection.docs.first.data() as Map);

      _state.value = DoneState();
    } catch (error) {
      _state.value = ErrorState(error.toString());
    }
  }
}
