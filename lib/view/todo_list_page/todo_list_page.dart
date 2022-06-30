import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/uitools/custom_appbar.dart';
import 'package:schoolman/uitools/custom_button.dart';
import 'package:schoolman/uitools/loading_indicator.dart';
import 'package:schoolman/view/todo_list_page/todo_list_controller.dart';

class TodoListPage extends StatelessWidget {
  TodoListPage({Key? key}) : super(key: key);

  final c = Get.put(TodoListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        CustomAppBar(
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
        c.obx((state) {
          return Expanded(
            child: ListView.builder(
              itemCount: state.length,
                itemBuilder: ((context, index) => ListTile(
                      title: Text(state[index].title),
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
