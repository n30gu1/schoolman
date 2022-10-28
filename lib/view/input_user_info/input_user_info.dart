import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:schoolman/generated/l10n.dart';
import 'package:schoolman/view/input_user_info/input_user_info_controller.dart';

class InputUserInfo extends StatelessWidget {
  InputUserInfo(this.regionCode, this.schoolCode, this.schoolName, {Key? key})
      : super(key: key);

  final String regionCode;
  final String schoolCode;
  final String schoolName;

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
                  PlatformTextButton(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: Text(
                        S.of(context).cancel,
                        style: Theme.of(context).textTheme.button?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w400),
                      ),
                      onPressed: () {
                        Get.back();
                      }),
                  PlatformTextButton(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: Text(
                        S.of(context).done,
                        style: Theme.of(context).textTheme.button?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
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
                          S.of(context).grade,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      SizedBox(
                        height: 100,
                        child: CupertinoPicker(
                            itemExtent: 30,
                            scrollController:
                                FixedExtentScrollController(initialItem: 0),
                            onSelectedItemChanged: (item) {
                              c.gradeSelected.value =
                                  c.gradeMap["grades"].toList()[item];
                            },
                            children: c.gradeMap["grades"].map<Widget>((item) {
                              return Align(
                                widthFactor: 0,
                                child: Text(
                                  item.toString(),
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              );
                            }).toList()),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 22.0),
                  child: Text(
                    "-",
                    textScaleFactor: 3,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          S.of(context).className,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      SizedBox(
                        height: 100,
                        child: CupertinoPicker(
                            itemExtent: 30,
                            scrollController:
                                FixedExtentScrollController(initialItem: 0),
                            onSelectedItemChanged: (item) {
                              c.classSelected.value = c.gradeMap["classes"]
                                  [c.gradeSelected.value][item];
                            },
                            children: c.gradeMap["classes"]
                                    [c.gradeSelected.value]
                                .map<Widget>((item) {
                              return Align(
                                widthFactor: 0,
                                child: Text(
                                  item,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              );
                            }).toList()),
                      ),
                    ],
                  ),
                ),
              ]),
              TextField(
                controller: c.studentNumberInputController,
                keyboardType: TextInputType.number,
              )
            ],
          );
        },
            onLoading: Center(child: PlatformCircularProgressIndicator()),
            onError: (e) => Center(
                  child: Text(S.of(context).somethingWentWrong + e.toString()),
                )),
      ),
    );
  }
}
