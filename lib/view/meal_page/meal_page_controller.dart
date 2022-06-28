import 'dart:async';
import 'package:get/get.dart';
import 'package:schoolman/apitools/api_service.dart';
import 'package:schoolman/model/meal.dart';

class MealPageController extends GetxController with StateMixin {
  Rx<MealType> _mealType = MealType.lunch.obs;
  Rx<DateTime> _date = DateTime.now().obs;
  RxInt _index = 1.obs;

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
    change(null, status: RxStatus.loading());

    try {
      _timer = Timer(Duration(milliseconds: 500), () {
        APIService.instance.fetchMealByDuration(mealType, date).then((value) {
          change(value, status: RxStatus.success());
        });
      });
    } catch (e) {
      change(null, status: RxStatus.error());
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
