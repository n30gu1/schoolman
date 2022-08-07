import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_widgetkit/flutter_widgetkit.dart';
import 'package:get/get.dart';
import 'package:schoolman/apitools/api_service.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/model/meal.dart';
import 'package:schoolman/model/notice.dart';
import 'package:schoolman/model/event.dart';
import 'package:schoolman/model/school.dart';
import 'package:schoolman/model/timetable.dart';
import 'package:schoolman/model/user.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

class MainPageController extends GetxController with StateMixin {
  Rx<TimeTable?> _timeTable = Rx(null);
  Rx<Meal?> _meal = Rx(null);
  Rx<Event?> _event = Rx(null);
  Rx<Notice?> _notice = Rx(null);

  TimeTable? get timeTable => _timeTable.value;

  Meal? get meal => _meal.value;

  Event? get event => _event.value;

  Notice? get notice => _notice.value;

  @override
  void onInit() async {
    build();

    super.onInit();
  }

  void build() async {
    change(null, status: RxStatus.loading());
    try {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        writeSchoolDataToUserDefault();
        sendSchoolDataViaWC();
      }
      await fetchTimeTable();
      await fetchMeal();
      await fetchEvent();
      await fetchNotice();
      change(null, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  void writeSchoolDataToUserDefault() {
    try {
      WidgetKit.setItem(
          "regionCode",
          GlobalController.instance.school?.regionCode,
          "group.com.n30gu1.schoolman");
      WidgetKit.setItem(
          "schoolCode",
          GlobalController.instance.user.value?.schoolCode,
          "group.com.n30gu1.schoolman");
      WidgetKit.setItem(
          "schoolType",
          GlobalController.instance.school?.schoolType.code.toString(),
          "group.com.n30gu1.schoolman");
      WidgetKit.setItem("grade", GlobalController.instance.user.value?.grade,
          "group.com.n30gu1.schoolman");
      WidgetKit.setItem(
          "class",
          GlobalController.instance.user.value?.className,
          "group.com.n30gu1.schoolman");
    } catch (e) {
      print("Error occured while writing data to UserDefault $e");
    }
  }

  void sendSchoolDataViaWC() {
    try {
      WatchConnectivity wc = WatchConnectivity();
      wc.sendMessage({
        "regionCode": GlobalController.instance.school?.regionCode,
        "schoolCode": GlobalController.instance.user.value?.schoolCode,
        "schoolType":
            GlobalController.instance.school?.schoolType.code.toString(),
        "grade": GlobalController.instance.user.value?.grade,
        "class": GlobalController.instance.user.value?.className
      });
    } catch (e) {
      print("Error occured while sending via WatchConnectivity $e");
    }
  }

  Future<void> fetchTimeTable() async {
    try {
      School school = GlobalController.instance.school!;
      User user = GlobalController.instance.user.value!;
      _timeTable.value = await APIService.instance.fetchTimeTable(
          school.schoolType,
          school.regionCode,
          school.schoolCode,
          user.grade,
          user.className);
    } catch (error) {
      print(error);
    }
  }

  Future<void> fetchMeal() async {
    try {
      School school = GlobalController.instance.school!;
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
        if (now < 13) {
          _mealType = MealType.lunch;
        } else {
          _mealType = MealType.nextDayLunch;
        }
      }

      _meal.value = await APIService.instance
          .fetchMeal(
              school.regionCode, school.schoolCode, _mealType, DateTime.now())
          .then((value) => value);
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchEvent() async {
    try {
      _event.value = (await APIService.instance.fetchEvents(1))[0];
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchNotice() async {
    try {
      School currentSchool = GlobalController.instance.school!;
      QuerySnapshot noticesCollection = await FirebaseFirestore.instance
          .collection("${currentSchool.regionCode}")
          .doc("${currentSchool.schoolCode}")
          .collection("notices")
          .orderBy("timeCreated", descending: true)
          .get();

      _notice.value =
          Notice.fromMap(await noticesCollection.docs.first.data() as Map);
    } catch (e) {
      print(e);
    }
  }
}
