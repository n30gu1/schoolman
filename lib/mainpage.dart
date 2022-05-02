import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoolman/controller/global_controller.dart';
import 'package:schoolman/controller/mainpage_controller.dart';
import 'package:schoolman/current_state.dart';
import 'package:schoolman/model/timetable.dart';
import 'package:schoolman/uitools/custom_button.dart';

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  final controller = Get.put(MainPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (GlobalController.instance.state is LoadingState ||
            controller.state is LoadingState) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).viewPadding.top + 72,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).viewPadding.top + 8,
                        left: 16,
                        right: 16),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 2.0),
                              child: Text(
                                  "${DateFormat.yMd().format(DateTime.now())}"),
                            ),
                            Text(
                              "Good day",
                              style: TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Spacer(),
                        CustomButton(
                          width: 40,
                          height: 40,
                          onTap: () {
                            print("onTap");
                            GlobalController.instance.signOut();
                          },
                          child: Icon(Icons.door_back_door),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 500,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: (() {
                                if (controller.state is DoneState) {
                                  return ListView.builder(
                                    itemCount: controller
                                            .timeTable.value?.items.length ??
                                        0,
                                    itemBuilder: (context, index) {
                                      TimeTableItem? item = controller
                                          .timeTable.value?.items[index];
                                      return Text(
                                          "${item?.period}교시: ${item?.subject}");
                                    },
                                  );
                                } else {
                                  return Text((controller.state as ErrorState).error);
                                }
                              })()),
                        ),
                        Container(
                          height:
                              MediaQuery.of(context).viewPadding.bottom + 20,
                        )
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
