import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/view/mealpage/mealpage_controller.dart';
import 'package:schoolman/current_state.dart';
import 'package:schoolman/date_converter.dart';
import 'package:schoolman/uitools/custom_appbar.dart';
import 'package:schoolman/uitools/custom_button.dart';
import 'package:schoolman/uitools/loading_indicator.dart';

class MealPage extends StatelessWidget {
  final controller = Get.put(MealPageController());

  MealPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Column(
          children: [
            CustomAppBar(
                title: "Meal",
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
                          "${GlobalController.instance.school?.schoolName}"),
                    ),
                  ],
                )),
            Container(
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                            onTap: () {
                              controller
                                  .setDate(controller.date.add(Duration(days: -7)));
                            },
                            borderRadius: BorderRadius.circular(1000),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.chevron_left),
                            )),
                        Text("${controller.date.showRangeAsString(context)}"),
                        CustomButton(
                            onTap: () {
                              controller
                                  .setDate(controller.date.add(Duration(days: 7)));
                            },
                            borderRadius: BorderRadius.circular(1000),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.chevron_right),
                            ))
                      ],
                    ),

                    Row(
                      children: [

                      ],
                    )
                  ],
                ),
              ),
            ),
            () {
              if (!(controller.state is DoneState)) {
                return LoadingIndicator();
              } else {
                return Expanded(
                    child: ListView.builder(
                        itemCount: controller.meals.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(controller.meals[index].date
                                    .formatToString(context)),
                                for (var meal in controller.meals[index].meal)
                                  Text(meal)
                              ],
                            ),
                          );
                        }));
              }
            }()
          ],
        );
      }),
    );
  }
}
