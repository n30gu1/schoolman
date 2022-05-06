import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolman/controller/tabview_controller.dart';
import 'package:schoolman/view/mainpage.dart';
import 'package:schoolman/view/mealpage.dart';
import 'package:schoolman/view/timetablepage.dart';

class TabView extends StatelessWidget {
  final List<Widget> views = [MainPage(), TimeTablePage(), MealPage()];

  final controller = Get.put(TabViewController());

  TabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Column(
          children: [
            Flexible(child: views[controller.index]),
            Stack(
              children: [
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: MediaQuery.of(context).viewPadding.bottom + 40,
                ),
                Container(
                  width: double.infinity,
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TabBarItem(title: "Dashboard", index: 0),
                      TabBarItem(title: "Time Table", index: 1),
                      TabBarItem(title: "Meal", index: 2)
                    ],
                  ),
                )
              ],
            )
          ],
        );
      }),
    );
  }
}

class TabBarItem extends StatelessWidget {
  final String title;
  final int index;

  TabBarItem({required this.title, required this.index, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TabViewController controller = Get.find();
    return ExpandTapWidget(
      onTap: () {
        controller.setIndex(index);
      },
      tapPadding: EdgeInsets.all(26),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
            fontWeight:
                controller.index == index ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }
}
