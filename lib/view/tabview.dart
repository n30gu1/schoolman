import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolman/generated/l10n.dart';
import 'package:schoolman/view/events/events_page.dart';
import 'package:schoolman/view/notice_board/notice_board_page.dart';
import 'package:schoolman/view/tabview_controller.dart';
import 'package:schoolman/view/main/main_page.dart';
import 'package:schoolman/view/meal/meal_page.dart';
import 'package:schoolman/view/time_table/time_table_page.dart';
import 'package:schoolman/view/todo_list/todo_list_page.dart';

class TabView extends StatelessWidget {
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
              Flexible(child: () {
                switch (controller.index) {
                  case 0:
                    return MainPage();
                  case 1:
                    return TimeTablePage();
                  case 2:
                    return MealPage();
                  case 3:
                    return NoticeBoardPage();
                  case 4:
                    return EventsPage();
                  case 5:
                    return TodoListPage();
                  default:
                    return MainPage();
                }
              }()),
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
                          S.of(context).titleSummary,
                          style: TextStyle(
                              fontWeight: controller.index == 0
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        ),
                      ),
                      Tab(
                        child: Text(
                          S.of(context).titleTimeTable,
                          style: TextStyle(
                              fontWeight: controller.index == 1
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        ),
                      ),
                      Tab(
                        child: Text(
                          S.of(context).titleMeal,
                          style: TextStyle(
                              fontWeight: controller.index == 2
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        ),
                      ),
                      Tab(
                        child: Text(
                          S.of(context).titleNoticeBoard,
                          style: TextStyle(
                              fontWeight: controller.index == 3
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        ),
                      ),
                      Tab(
                        child: Text(
                          S.of(context).titleEvents,
                          style: TextStyle(
                              fontWeight: controller.index == 4
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        ),
                      ),
                      Tab(
                        child: Text(
                          S.of(context).titleTodoList,
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
