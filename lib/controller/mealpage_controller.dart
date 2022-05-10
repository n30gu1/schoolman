import 'dart:async';
import 'package:get/get.dart';
import 'package:schoolman/apitools/api_service.dart';
import 'package:schoolman/current_state.dart';
import 'package:schoolman/model/meal.dart';

class MealPageController extends GetxController {
  RxList<Meal> meals = <Meal>[].obs;
  Rx<MealType> _mealType = MealType.lunch.obs;
  Rx<DateTime> _date = DateTime.now().obs;
  Rx<CurrentState> _state = CurrentState().obs;

  CurrentState get state => _state.value;
  DateTime get date => _date.value;
  MealType get mealType => _mealType.value;

  Timer? _timer;

  @override
  onInit() {
    fetchMeals();
    super.onInit();
  }

  void fetchMeals() async {
    _timer?.cancel();
    meals.clear();
    _state.value = LoadingState();

    try {
      _timer = Timer(Duration(milliseconds: 500), () {
        APIService.instance.fetchMealByDuration(mealType, date).then((value) {
          meals.addAll(value);
          _state.value = DoneState();
        });
      });
    } catch (e) {
      _state.value = ErrorState(e.toString());
    }
  }

  setDate(DateTime date) async {
    _date.value = date;
    fetchMeals();
  }
}