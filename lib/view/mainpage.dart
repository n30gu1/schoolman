import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoolman/controller/global_controller.dart';
import 'package:schoolman/controller/mainpage_controller.dart';
import 'package:schoolman/current_state.dart';
import 'package:schoolman/model/meal.dart';
import 'package:schoolman/model/school.dart';
import 'package:schoolman/uitools/custom_button.dart';
import 'package:schoolman/uitools/mainpagecard.dart';

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  final controller = Get.put(MainPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (GlobalController.instance.state is LoadingState ||
            controller.state is LoadingState) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery
                        .of(context)
                        .viewPadding
                        .top + 72,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery
                            .of(context)
                            .viewPadding
                            .top + 8,
                        left: 16,
                        right: 16),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 2.0),
                              child: Text(
                                  "${DateFormat.yMd().format(DateTime.now())}"),
                            ),
                            Text(
                              "Good day",
                              style: TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Spacer(),
                        CustomButton(
                          width: 40,
                          height: 40,
                          onTap: () {
                            print("onTap");
                            GlobalController.instance.signOut();
                          },
                          child: Icon(Icons.door_back_door),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(

                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: MainPageCard(
                                title: "Time Table",
                                height: 230,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      for (var item in controller.timeTable
                                          .value!.items)
                                        Text("${item.period}교시   ${item
                                            .subject}")
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(width: 16,),
                            Expanded(
                              child: MainPageCard(
                                title: () {
                                  switch (controller.meal.value!.mealType) {
                                    case MealType.breakfast:
                                      return "breakfast";
                                    case MealType.lunch:
                                      return "lunch";
                                    case MealType.dinner:
                                      return "dinner";
                                    case MealType.nextDayBreakfast:
                                      return "tomorrow breakfast";
                                  }
                                }(),
                                height: 230,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      for (var item in controller.meal.value!
                                          .meal)
                                        Text("${item}")
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        MainPageCard(title: "Upcoming Schedule", child: Column(
                          children: [Text("Nope.")],)),
                        MainPageCard(
                            title: "School Info (FOR DEBUGGING)", child: () {
                              School s = GlobalController.instance.school!;
                              return Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  Text("${s.schoolCode} - ${s.schoolName}"),
                                  Text("${s.regionCode} - ${s.orgName} - ${s.regionName}"),
                                    Text("Founded at: ${s.foundationDate}"),
                                    Text("${s.foundationType.name}")
                                ],),
                              );
                        }(),)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
