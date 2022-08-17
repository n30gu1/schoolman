import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/uitools/custom_appbar.dart';
import 'package:schoolman/uitools/custom_scaffold.dart';
import 'package:schoolman/uitools/loading_indicator.dart';
import 'package:schoolman/view/todo_list/todo_list_controller.dart';

class TodoListPage extends StatelessWidget {
  TodoListPage({Key? key}) : super(key: key);

  final c = Get.put(TodoListController());

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        appBar: CustomAppBar(
            title: "Todo List",
            subView: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Text("${DateFormat.yMd().format(DateTime.now())}"),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child:
                      Text("${GlobalController.instance.school?.schoolName}"),
                ),
              ],
            )),
        body: Column(
          children: [
            c.obx((state) {
              return Expanded(
                child: ListView.builder(
                    itemCount: state.length,
                    itemBuilder: ((context, index) => ListTile(
                          title: Text(state[index].title),
                          trailing: Obx(() => IconButton(
                                icon: Icon((c.todoDone.contains(state[index].id)
                                    ? Icons.check_circle_rounded
                                    : Icons.check_circle_outlined)),
                                onPressed: () {
                                  c.markReminderAsDone(state[index]);
                                },
                              )),
                        ))),
              );
            },
                onLoading: Center(
                  child: LoadingIndicator(),
                )),
          ],
        ));
  }
}
