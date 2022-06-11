import 'package:background_fetch/background_fetch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_widgetkit/flutter_widgetkit.dart';
import 'package:get/get.dart';
import 'package:schoolman/apitools/api_service.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/current_state.dart';
import 'package:schoolman/model/meal.dart';
import 'package:schoolman/model/notice.dart';
import 'package:schoolman/model/event.dart';
import 'package:schoolman/model/school.dart';
import 'package:schoolman/model/timetable.dart';
import 'package:schoolman/model/user.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

class MainPageController extends GetxController {
  Rx<TimeTable?> _timeTable = Rx(null);
  Rx<Meal?> _meal = Rx(null);
  Rx<Event?> _event = Rx(null);
  Rx<Notice?> _notice = Rx(null);
  Rx<CurrentState> _state = CurrentState().obs;

  TimeTable? get timeTable => _timeTable.value;

  Meal? get meal => _meal.value;

  Event? get event => _event.value;

  Notice? get notice => _notice.value;

  CurrentState? get state => _state.value;

  @override
  void onInit() async {
    _state.value = LoadingState();
    writeSchoolDataToUserDefault();
    await fetchTimeTable();
    await fetchMeal();
    await fetchEvent();
    await fetchNotice();
    sendToWidgetAndWatch();
    _state.value = DoneState();

    super.onInit();
  }

  void writeSchoolDataToUserDefault() {
    FlutterSecureStorage()
      ..write(
          key: "regionCode",
          value: GlobalController.instance.school?.regionCode)
      ..write(
          key: "schoolCode", value: GlobalController.instance.user?.schoolCode)
      ..write(
          key: "schoolType",
          value: GlobalController.instance.school?.schoolType.code.toString())
      ..write(key: "grade", value: GlobalController.instance.user?.grade)
      ..write(key: "class", value: GlobalController.instance.user?.className);
  }

  Future<void> fetchTimeTable() async {
    try {
      School school = GlobalController.instance.school!;
      User user = GlobalController.instance.user!;
      _timeTable.value = await APIService.instance.fetchTimeTable(
          school.schoolType,
          school.regionCode,
          school.schoolCode,
          user.grade,
          user.className);
    } catch (error) {
      print(error);
      _state.value = ErrorState(error.toString());
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
          .fetchMeal(school.regionCode, school.schoolCode, _mealType)
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

      _state.value = DoneState();
    } catch (e) {
      print(e);
    }
  }

  Future<void> scheduleBackgroundEvent() async {
    try {
      int now = DateTime.now().hour;
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        print("platform is iOS");

        int status = await BackgroundFetch.configure(
            BackgroundFetchConfig(minimumFetchInterval: 60),
            (String taskId) async {
          print("[BackgroundFetch] taskId: $taskId");
          FlutterSecureStorage storage = FlutterSecureStorage();

          String? regionCode = await storage.read(key: "regionCode");
          String? schoolCode = await storage.read(key: "schoolCode");
          String? rawSchoolType = await storage.read(key: "schoolType");
          String? grade = await storage.read(key: "grade");
          String? className = await storage.read(key: "class");

          MealType mealType;

          if (regionCode != null &&
              schoolCode != null &&
              rawSchoolType != null &&
              grade != null &&
              className != null) {
            SchoolType schoolType;
            switch (rawSchoolType) {
              case "0":
                schoolType = SchoolType.elementary;
                break;
              case "1":
                schoolType = SchoolType.middle;
                break;
              case "2":
                schoolType = SchoolType.high;
                break;
              default:
                schoolType = SchoolType.other;
                break;
            }

            if (schoolType == SchoolType.high) {
              if (now < 8) {
                mealType = MealType.breakfast;
              } else if (now >= 8 && now < 13) {
                mealType = MealType.lunch;
              } else if (now >= 13 && now < 19) {
                mealType = MealType.dinner;
              } else {
                mealType = MealType.nextDayBreakfast;
              }
            } else {
              if (now < 13) {
                mealType = MealType.lunch;
              } else {
                mealType = MealType.nextDayLunch;
              }
            }

            Meal meal = await APIService.instance
                .fetchMeal(regionCode, schoolCode, mealType);
            TimeTable timeTable = await APIService.instance.fetchTimeTable(
                schoolType, regionCode, schoolCode, grade, className);
            WidgetKit.setItem(
                "meal", meal.toJson(), "group.com.n30gu1.schoolman");
            WidgetKit.setItem(
                "timeTable", timeTable.toJson(), "group.com.n30gu1.schoolman");
            WidgetKit.reloadAllTimelines();
            print("Done!");
          } else {
            throw "Failed to fetch widget datas";
          }
          BackgroundFetch.finish(taskId);
        }, (String taskId) async {
          print("[BackgroundFetch] TIMEOUT taskId: $taskId");
          BackgroundFetch.finish(taskId);
        });

        BackgroundFetch.start();

        print("BackgroundFetch status $status");
      } else {
        print("not supported");
      }
    } catch (e) {
      print("Error at scheduleBackgroundEvent: $e");
    }
  }

  void sendToWidgetAndWatch() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        WidgetKit.setItem(
            "meal", meal?.toJson() ?? "", "group.com.n30gu1.schoolman");
        WidgetKit.setItem("timeTable", timeTable?.toJson() ?? "",
            "group.com.n30gu1.schoolman");
        WidgetKit.reloadAllTimelines();
        print("done");

        final watch = WatchConnectivity();

        if (await watch.isSupported) {
          if (await watch.isPaired && await watch.isReachable) {
            watch.sendMessage({
              "meal": meal?.toJson() ?? "",
              "timeTable": timeTable?.toJson() ?? ""
            });
            print("sent messages to watch!");
          }
        }
      }
    } catch (e) {
      print("Error at sendToWidgetAndWatch: $e");
    }
  }
}
