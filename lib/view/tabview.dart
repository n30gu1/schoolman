import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolman/view/tabview_controller.dart';
import 'package:schoolman/view/mainpage/mainpage.dart';
import 'package:schoolman/view/mealpage/mealpage.dart';
import 'package:schoolman/view/timetable/timetablepage.dart';

class TabView extends StatelessWidget {
  final List<Widget> views = [MainPage(), TimeTablePage(), MealPage()];

  final controller = Get.put(TabViewController());

  TabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Obx(() {
          return Column(
            children: [
              Flexible(child: views[controller.index]),
              Stack(
                children: [
                  Container(
                    color: Colors.white,
                    width: double.infinity,
                    height: MediaQuery.of(context).viewPadding.bottom + 50,
                  ),
                  TabBar(
                    onTap: (index) {
                      controller.setIndex(index);
                    },
                    enableFeedback: true,
                    indicatorColor: Colors.black,
                    labelColor: Colors.black,
                    tabs: [
                      Tab(
                        child: Text(
                          "Dashboard",
                          style: TextStyle(
                              fontWeight: controller.index == 0
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "Time Table",
                          style: TextStyle(
                              fontWeight: controller.index == 1
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "Meal",
                          style: TextStyle(
                              fontWeight: controller.index == 2
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}