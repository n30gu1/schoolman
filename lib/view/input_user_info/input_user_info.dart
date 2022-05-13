import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/view/input_user_info/input_user_info_controller.dart';
import 'package:get/get.dart';
import 'package:schoolman/current_state.dart';

class InputUserInfo extends StatelessWidget {
  InputUserInfo(this.regionCode, this.schoolCode, {Key? key})
      : super(key: key);

  final String regionCode;
  final String schoolCode;

  final TextStyle textStyle = TextStyle(fontFamily: "Pretendard");

  @override
  Widget build(BuildContext context) {
    InputUserInfoController controller =
        Get.put(InputUserInfoController(regionCode, schoolCode));

    return SizedBox(
      height: 250,
      child: Scaffold(
        body: Obx(() {
          if (controller.state is LoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (controller.state is DoneState) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                        child: Text(
                          "Cancel",
                          style: textStyle,
                        ),
                        onPressed: () {
                          Get.back();
                        }),
                    CupertinoButton(
                        child: Text(
                          "Done",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Pretendard"),
                        ),
                        onPressed: () {
                          print("Grade: ${controller.gradeSelected.value}");
                          print("Class: ${controller.classSelected.value}");
                          print("RegionCode: ${this.regionCode}");
                          print("SchoolCode: ${this.schoolCode}");
                          GlobalController.instance.submitNewUser(
                              this.regionCode,
                              this.schoolCode,
                              controller.gradeSelected.value,
                              controller.classSelected.value);
                        })
                  ],
                ),
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "학년",
                            style: textStyle,
                          ),
                        ),
                        SizedBox(
                          height: 100,
                          child: CupertinoPicker(
                              itemExtent: 29,
                              scrollController:
                                  FixedExtentScrollController(initialItem: 0),
                              onSelectedItemChanged: (item) {
                                controller.gradeSelected.value = controller
                                    .gradeMap["grades"]
                                    .toList()[item];
                              },
                              children: controller.gradeMap["grades"]
                                  .map<Widget>((item) {
                                return Text(
                                  item.toString(),
                                  style: textStyle,
                                );
                              }).toList()),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text("-", textScaleFactor: 3),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "반",
                            style: textStyle,
                          ),
                        ),
                        SizedBox(
                          height: 100,
                          child: CupertinoPicker(
                              itemExtent: 29,
                              scrollController:
                                  FixedExtentScrollController(initialItem: 0),
                              onSelectedItemChanged: (item) {
                                controller.classSelected.value =
                                    controller.gradeMap["classes"]
                                        [controller.gradeSelected.value][item];
                              },
                              children: controller.gradeMap["classes"]
                                      [controller.gradeSelected.value]
                                  .map<Widget>((item) {
                                return Text(
                                  item,
                                  style: textStyle,
                                );
                              }).toList()),
                        ),
                      ],
                    ),
                  ),
                ]),
              ],
            );
          } else if (controller.state is ErrorState) {
            return Center(
              child: Text(
                (controller.state as ErrorState).error,
                style: textStyle,
              ),
            );
          } else {
            return Center(
              child: Text(
                "What Happened?",
                style: textStyle,
              ),
            );
          }
        }),
      ),
    );
  }
}
