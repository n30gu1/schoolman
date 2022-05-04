import 'package:get/get.dart';
import 'package:schoolman/apitools/api_service.dart';
import 'package:schoolman/current_state.dart';
import 'package:schoolman/model/meal.dart';
import 'package:schoolman/model/timetable.dart';

class MainPageController extends GetxController {
  Rx<TimeTable?> timeTable = Rx(null);
  Rx<Meal?> meal = Rx(null);
  Rx<CurrentState> _state = CurrentState().obs;

  get state => _state.value;

  @override
  void onInit() {
    fetchItems();
    super.onInit();
  }

  void fetchItems() async {
    _state.value = LoadingState();
    try {
      timeTable.value = await APIService.instance.fetchTimeTable();
      int now = DateTime.now().hour;
      MealType? mealType;
      if (now < 8) {
        mealType = MealType.breakfast;
      } else if (now >= 8 && now < 13) {
        mealType = MealType.lunch;
      } else if (now >= 13 && now < 19) {
        mealType = MealType.dinner;
      } else {
        mealType = MealType.nextDayBreakfast;
      }

      meal.value = await APIService.instance
          .fetchMeal(mealType)
          .then((value) => value[0]);

      APIService.instance.fetchSchedule();

      _state.value = DoneState();
    } catch (error) {
      _state.value = ErrorState(error.toString());
    }
  }
}
