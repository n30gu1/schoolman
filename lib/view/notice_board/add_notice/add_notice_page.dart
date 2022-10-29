import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:schoolman/uitools/custom_scaffold.dart';
import 'package:schoolman/view/notice_board/add_notice/add_notice_controller.dart';

class AddNoticePage extends StatelessWidget {
  final c = Get.put(AddNoticeController());
  AddNoticePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          shadowColor: Colors.transparent,
          actions: [
            c.obx((state) {
              return IconButton(
                  onPressed: () {
                    c.upload();
                  },
                  icon: Icon(Icons.add));
            }, onLoading: PlatformCircularProgressIndicator())
          ],
        ),
        body: Obx(
          () => SingleChildScrollView(
            child: Column(children: [
              TextField(
                controller: c.titleController,
                decoration: InputDecoration(hintText: "Title"),
              ),
              TextField(
                controller: c.contentController,
                decoration: InputDecoration(hintText: "Content"),
              ),
              TextButton(
                  onPressed: () {
                    c.expandTodoTab.toggle();
                  },
                  child: Text("Expand Todo Tab")),
              if (c.expandTodoTab.isTrue) ...[
                Column(
                  children: [
                    TextField(
                      controller: c.todoTitleController,
                      decoration: InputDecoration(hintText: "Title"),
                    ),
                    TextField(
                      controller: c.todoCommentController,
                      decoration: InputDecoration(hintText: "Comment"),
                    ),
                    TextButton(
                        onPressed: () => showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate:
                                    DateTime.now().add(Duration(days: 1000000)))
                            .then((value) => c.setDueDate),
                        child: Text("Set Due Date")),
                    Switch(
                        value: c.isAssignedToAllClasses.value,
                        onChanged: (value) {
                          c.isAssignedToAllClasses.value = value;
                        }),
                    c.obx(
                        (state) => Column(
                              children: [
                                for (var key in c.gradeMap["grades"]) ...[
                                  Row(
                                    children: [
                                      Text(key),
                                      Row(children: [
                                        for (int i = 0;
                                            i <
                                                c.gradeMap["classes"][key]
                                                    .length;
                                            i++) ...[
                                          Column(
                                            children: [
                                              Obx(() {
                                                var className =
                                                    c.gradeMap["classes"][key]
                                                        [i];
                                                return Checkbox(value: () {
                                                  if (c.classSelected[key] ==
                                                      null) {
                                                    print("Null!");
                                                    return false;
                                                  } else {
                                                    return (c.classSelected[key]
                                                            as List)
                                                        .contains(className);
                                                  }
                                                }(), onChanged: (value) {
                                                  print("onchanged");
                                                  if (c.classSelected[key] ==
                                                      null) {
                                                    c.classSelected[key] =
                                                        RxList();
                                                  }
                                                  if (c.classSelected[key]
                                                      .contains(className)) {
                                                    (c.classSelected[key]
                                                            as List)
                                                        .removeWhere(
                                                            (element) =>
                                                                element ==
                                                                className);
                                                  } else {
                                                    c.classSelected[key]
                                                        .add(className);
                                                  }
                                                });
                                              }),
                                              Text(
                                                  "${c.gradeMap["classes"][key][i]}"),
                                            ],
                                          )
                                        ]
                                      ])
                                    ],
                                  )
                                ]
                              ],
                            ),
                        onLoading: PlatformCircularProgressIndicator())
                  ],
                )
              ]
            ]),
          ),
        ));
  }
}
