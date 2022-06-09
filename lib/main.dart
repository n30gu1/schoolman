import 'dart:io';
import 'package:background_fetch/background_fetch.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_widgetkit/flutter_widgetkit.dart';
import 'package:get/get.dart';
import 'package:schoolman/apitools/api_service.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/current_state.dart';
import 'package:schoolman/model/meal.dart';
import 'package:schoolman/model/school.dart';
import 'package:schoolman/model/timetable.dart';
import 'package:schoolman/uitools/loading_indicator.dart';

// TODO: MAKE TABVIEW CAN DO LAZY LOADING
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final c = Get.put(GlobalController());

  @override
  void initState() {
    // initBackgroundTask();
    super.initState();
  }

  // Future<void> initBackgroundTask() async {
  //   await BackgroundFetch.configure(
  //       BackgroundFetchConfig(minimumFetchInterval: 60), (String taskId) async {
  //     print("[BackgroundFetch] taskId: $taskId");
  //     FlutterSecureStorage storage = FlutterSecureStorage();

  //     String? regionCode = await storage.read(key: "regionCode");
  //     String? schoolCode = await storage.read(key: "schoolCode");
  //     String? rawSchoolType = await storage.read(key: "schoolType");
  //     String? grade = await storage.read(key: "grade");
  //     String? className = await storage.read(key: "class");

  //     MealType mealType;

  //     if (regionCode != null &&
  //         schoolCode != null &&
  //         rawSchoolType != null &&
  //         grade != null &&
  //         className != null) {
  //       SchoolType schoolType;
  //       switch (rawSchoolType) {
  //         case "0":
  //           schoolType = SchoolType.elementary;
  //           break;
  //         case "1":
  //           schoolType = SchoolType.middle;
  //           break;
  //         case "2":
  //           schoolType = SchoolType.high;
  //           break;
  //         default:
  //           schoolType = SchoolType.other;
  //           break;
  //       }

  //       int now = DateTime.now().hour;

  //       if (schoolType == SchoolType.high) {
  //         if (now < 8) {
  //           mealType = MealType.breakfast;
  //         } else if (now >= 8 && now < 13) {
  //           mealType = MealType.lunch;
  //         } else if (now >= 13 && now < 19) {
  //           mealType = MealType.dinner;
  //         } else {
  //           mealType = MealType.nextDayBreakfast;
  //         }
  //       } else {
  //         if (now < 13) {
  //           mealType = MealType.lunch;
  //         } else {
  //           mealType = MealType.nextDayLunch;
  //         }
  //       }

  //       Meal meal = await APIService.instance
  //           .fetchMeal(regionCode, schoolCode, mealType);
  //       TimeTable timeTable = await APIService.instance.fetchTimeTable(
  //           schoolType, regionCode, schoolCode, grade, className);
  //       WidgetKit.setItem("meal", meal.toJson(), "group.com.n30gu1.schoolman");
  //       WidgetKit.setItem(
  //           "timeTable", timeTable.toJson(), "group.com.n30gu1.schoolman");
  //       WidgetKit.reloadAllTimelines();
  //       print("Done!");
  //     } else {
  //       throw "Failed to fetch widget datas";
  //     }
  //     BackgroundFetch.finish(taskId);
  //   }, (String taskId) async {
  //     print("[BackgroundFetch] TIMEOUT taskId: $taskId");
  //     BackgroundFetch.finish(taskId);
  //   });

  //   BackgroundFetch.start();

  //   BackgroundFetch.scheduleTask(
  //       TaskConfig(taskId: "com.transistorsoft.fetch", delay: 7200000));
  // }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          fontFamily: "Pretendard",
          primaryColor: Colors.black,
          focusColor: Colors.black),
      home: () {
        return Obx(() => Scaffold(body: () {
              final userState = GlobalController.instance.userState;
              if (userState is LoadingState) {
                return const Center(child: LoadingIndicator());
              } else if (userState is DoneState) {
                return userState.result?[0];
              } else {
                return const Center(child: Text("something went wrong!"));
              }
            }()));
      }(),
    );
  }
}
