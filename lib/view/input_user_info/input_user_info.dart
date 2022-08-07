import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolman/uitools/loading_indicator.dart';
import 'package:schoolman/view/input_user_info/input_user_info_controller.dart';

class InputUserInfo extends StatelessWidget {
  InputUserInfo(this.regionCode, this.schoolCode, this.schoolName, {Key? key})
      : super(key: key);

  final String regionCode;
  final String schoolCode;
  final String schoolName;

  final TextStyle textStyle = TextStyle(fontFamily: "Pretendard");

  @override
  Widget build(BuildContext context) {
    InputUserInfoController c =
        Get.put(InputUserInfoController(regionCode, schoolCode, schoolName));

    return SizedBox(
      height: 250,
      child: Scaffold(
        body: c.obx((state) {
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
                        c.submitUserInfo();
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
                              c.gradeSelected.value =
                                  c.gradeMap["grades"].toList()[item];
                            },
                            children: c.gradeMap["grades"].map<Widget>((item) {
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
                              c.classSelected.value = c.gradeMap["classes"]
                                  [c.gradeSelected.value][item];
                            },
                            children: c.gradeMap["classes"]
                                    [c.gradeSelected.value]
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
              TextField(
                controller: c.studentNumberInputController,
              )
            ],
          );
        },
            onLoading: LoadingIndicator(),
            onError: (e) => Center(
                  child: Text("Something went wrong: $e"),
                )),
      ),
    );
  }
}
