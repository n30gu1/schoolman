import 'dart:async';
import 'package:get/get.dart';
import 'package:schoolman/apitools/api_service.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/date_converter.dart';
import 'package:schoolman/model/meal.dart';
import 'package:schoolman/model/school.dart';

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
    ever(GlobalController.instance.user, (_) {
      print("changed!");
      fetchMeals();
    });
  }

  void fetchMeals() async {
    _timer?.cancel();
    change(null, status: RxStatus.loading());
    _timer = Timer(Duration(milliseconds: 500), () async {
      List<Meal> meals = [];
      for (DateTime d in date.listByWeekdayWithAutoListing()) {
        School school = GlobalController.instance.school!;
        await APIService.instance
            .fetchMeal(school.regionCode, school.schoolCode, mealType, d)
            .then((value) {
          meals.add(value);
        }).onError((error, stackTrace) => null);
      }

      if (meals.isEmpty) {
        change(null, status: RxStatus.error("There is no meal"));
      } else {
        change(meals, status: RxStatus.success());
      }
    });
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
