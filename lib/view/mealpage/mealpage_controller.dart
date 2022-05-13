import 'dart:async';
import 'package:get/get.dart';
import 'package:schoolman/apitools/api_service.dart';
import 'package:schoolman/current_state.dart';
import 'package:schoolman/model/meal.dart';

class MealPageController extends GetxController {
  Rx<MealType> _mealType = MealType.lunch.obs;
  Rx<DateTime> _date = DateTime.now().obs;
  Rx<CurrentState> _state = CurrentState().obs;
  RxInt _index = 1.obs;

  CurrentState get state => _state.value;
  DateTime get date => _date.value;
  MealType get mealType => _mealType.value;
  int get index => _index.value;

  Timer? _timer;

  @override
  onInit() {
    fetchMeals();
    super.onInit();
  }

  void fetchMeals() async {
    _timer?.cancel();
    _state.value = LoadingState();

    try {
      _timer = Timer(Duration(milliseconds: 500), () {
        APIService.instance.fetchMealByDuration(mealType, date).then((value) {
          _state.value = DoneState(result: value);
        });
      });
    } catch (e) {
      _state.value = ErrorState(e.toString());
    }
  }

  setDate(DateTime date) {
    _date.value = date;
    fetchMeals();
  }

  setMealType(MealType mealType) {
    _mealType.value = mealType;
    fetchMeals();
  }

  setTabIndex(int index) {
    _index.value = index;
    switch (_index.value) {
      case 0:
        _mealType.value = MealType.breakfast;
        fetchMeals();
        break;
      case 1:
        _mealType.value = MealType.lunch;
        fetchMeals();
        break;
      case 2:
        _mealType.value = MealType.dinner;
        fetchMeals();
        break;
      default:
        _index.value = 1;
        fetchMeals();
        break;
    }
  }
}