import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/generated/l10n.dart';
import 'package:schoolman/uitools/custom_scaffold.dart';
import 'package:schoolman/view/main/main_page_controller.dart';
import 'package:schoolman/model/meal.dart';
import 'package:schoolman/uitools/custom_appbar.dart';
import 'package:schoolman/uitools/custom_button.dart';
import 'package:schoolman/view/main/switch_user/switch_user_page.dart';
import 'package:schoolman/view/studyplanner/studyplanner_page.dart';

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  final c = Get.put(MainPageController());

  Widget titleBox(BuildContext context, {required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).dialogBackgroundColor),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        appBar: CustomAppBar(
            subView: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Text("${DateFormat.yMd().format(DateTime.now())}"),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Text(
                      "${Get.find<GlobalController>().school?.schoolName}"),
                ),
              ],
            ),
            title: S.of(context).titleSummary,
            trailing: SizedBox(
              width: 40,
              height: 40,
              child: CustomButton(
                onTap: () {
                  Get.bottomSheet(SwitchUserPage(),
                      enterBottomSheetDuration: Duration(milliseconds: 100),
                      exitBottomSheetDuration: Duration(milliseconds: 100),
                      persistent: false);
                },
                borderRadius: double.infinity,
                child: Icon(Icons.account_circle_sharp),
              ),
            )),

        // Body
        body: Column(children: [
          c.obx((_) {
            return Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 4),
                              child: Text(
                                S.of(context).titleTimeTable,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 4),
                              child: Text(
                                () {
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
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            titleBox(
                              context,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (var item in c.timeTable?.items ?? [])
                                      Text("${item.period}교시   ${item.subject}")
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 16,
                            ),
                            titleBox(
                              context,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (var item
                                        in c.meal?.meal ?? ["No meal now."])
                                      Text("${item}")
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 4),
                        child: Text(
                          "Upcoming Schedule",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      titleBox(context, child: () {
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
                          return Center(child: Text("No upcoming event."));
                        }
                      }()),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 4),
                        child: Text(
                          "Recent Notice",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      titleBox(context,
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
                          )),
                      ElevatedButton(
                          onPressed: () => Get.to(() => StudyPlannerPage()),
                          child: Text("DEBUG: Go to Study Planner!"))
                    ],
                  ),
                ),
              ),
            );
          },
              onLoading: Center(
                child: PlatformCircularProgressIndicator(),
              ))
        ]));
  }
}
