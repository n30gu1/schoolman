import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/view/main_page/main_page_controller.dart';
import 'package:schoolman/model/meal.dart';
import 'package:schoolman/uitools/custom_appbar.dart';
import 'package:schoolman/uitools/custom_button.dart';
import 'package:schoolman/uitools/loading_indicator.dart';
import 'package:schoolman/uitools/mainpagecard.dart';
import 'package:schoolman/view/info_page/info_page.dart';

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  final c = Get.put(MainPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: c.obx((state) {
        if (GlobalController.instance.state is LoadingState ||
            c.state is LoadingState) {
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
                                      for (var item in c.timeTable?.items ?? [])
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
                                    switch (c.meal!.mealType) {
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
                                      for (var item
                                          in c.meal?.meal ?? ["No meal now."])
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
                              if (c.event != null) {
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        format.format(c.event!.date),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      Spacer(),
                                      Text(c.event!.title,
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
                                  if (c.notice != null) ...[
                                    Text(
                                      c.notice!.title,
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    Text(c.notice!.content)
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
