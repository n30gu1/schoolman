import 'package:get/get.dart';
import 'package:schoolman/apitools/api_service.dart';
import 'package:schoolman/current_state.dart';
import 'package:schoolman/model/meal.dart';

class MealPageController extends GetxController {
  RxList<Meal> meals = <Meal>[].obs;
  Rx<MealType> mealType = MealType.lunch.obs;
  Rx<DateTime> date = DateTime.now().obs;
  Rx<CurrentState> _state = CurrentState().obs;

  get state => _state.value;

  @override
  onInit() {
    fetchMeals();
    super.onInit();
  }

  fetchMeals() async {
    _state.value = LoadingState();

    try {
      meals.addAll(await APIService.instance.fetchMealByDuration(mealType.value, date.value));
      _state.value = DoneState();
    } catch (e) {
      _state.value = ErrorState(e.toString());
    }
  }
}