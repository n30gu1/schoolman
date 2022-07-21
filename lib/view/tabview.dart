import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolman/view/events/events_page.dart';
import 'package:schoolman/view/notice_board/notice_board_page.dart';
import 'package:schoolman/view/tabview_controller.dart';
import 'package:schoolman/view/main/main_page.dart';
import 'package:schoolman/view/meal/meal_page.dart';
import 'package:schoolman/view/time_table/time_table_page.dart';
import 'package:schoolman/view/todo_list/todo_list_page.dart';

class TabView extends StatelessWidget {
  final List<Widget> views = [
    MainPage(),
    TimeTablePage(),
    MealPage(),
    NoticeBoardPage(),
    EventsPage(),
    TodoListPage()
  ];

  final controller = Get.put(TabViewController());

  TabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
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
                      Tab(
                        child: Text(
                          "Notice Board",
                          style: TextStyle(
                              fontWeight: controller.index == 3
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "Events",
                          style: TextStyle(
                              fontWeight: controller.index == 4
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "Todo List",
                          style: TextStyle(
                              fontWeight: controller.index == 5
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
