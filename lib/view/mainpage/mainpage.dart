import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/view/mainpage/mainpage_controller.dart';
import 'package:schoolman/current_state.dart';
import 'package:schoolman/model/meal.dart';
import 'package:schoolman/uitools/custom_appbar.dart';
import 'package:schoolman/uitools/custom_button.dart';
import 'package:schoolman/uitools/loading_indicator.dart';
import 'package:schoolman/uitools/mainpagecard.dart';
import 'package:schoolman/view/infopage/infopage.dart';

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  final controller = Get.put(MainPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (GlobalController.instance.state is LoadingState ||
            controller.state is LoadingState) {
          return Center(child: LoadingIndicator());
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomAppBar(
                  subView: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child:
                            Text("${DateFormat.yMd().format(DateTime.now())}"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: Text(
                            "${GlobalController.instance.school?.schoolName}"),
                      ),
                    ],
                  ),
                  title: "Dashboard",
                  trailing: CustomButton(
                    width: 40,
                    height: 40,
                    onTap: () {
                      Get.to(() => InfoPage());
                    },
                    borderRadius: BorderRadius.circular(1000),
                    child: Icon(Icons.info_outline),
                  )),
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
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      for (var item
                                          in controller.timeTable?.items ?? [])
                                        Text(
                                            "${item.period}교시   ${item.subject}")
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 16,
                            ),
                            Expanded(
                              child: MainPageCard(
                                title: () {
                                  try {
                                    switch (controller.meal!.mealType) {
                                      case MealType.breakfast:
                                        return "Breakfast";
                                      case MealType.lunch:
                                        return "Lunch";
                                      case MealType.dinner:
                                        return "Dinner";
                                      case MealType.nextDayBreakfast:
                                        return "Breakfast (+1)";
                                      case MealType.nextDayLunch:
                                        return "Lunch (+1)";
                                    }
                                  } catch (e) {
                                    return "Meal";
                                  }
                                }(),
                                height: 230,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      for (var item in controller.meal?.meal ??
                                          ["No meal now."])
                                        Text("${item}")
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        MainPageCard(
                            title: "Upcoming Schedule",
                            child: () {
                              DateFormat format = DateFormat("M. d.");
                              if (controller.schedule != null) {
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        format
                                            .format(controller.schedule!.date),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      Spacer(),
                                      Text(controller.schedule!.title,
                                          style: TextStyle(fontSize: 20)),
                                    ],
                                  ),
                                );
                              } else {
                                return Center(
                                    child: Text("No upcoming event."));
                              }
                            }()),
                        MainPageCard(
                            title: "Recent Notice",
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (controller.notice != null) ...[
                                    Text(
                                      controller.notice!.title,
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    Text(controller.notice!.content)
                                  ] else ...[
                                    Text("There is no notice yet.")
                                  ]
                                ],
                              ),
                            ))
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
