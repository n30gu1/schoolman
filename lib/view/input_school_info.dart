import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolman/controller/input_school_info_controller.dart';
import 'package:schoolman/current_state.dart';
import 'package:schoolman/uitools/loading_indicator.dart';
import 'package:schoolman/view/input_user_info.dart';

class InputSchoolInfo extends StatelessWidget {
  InputSchoolInfo({Key? key}) : super(key: key);

  final controller = Get.put(InputSchoolInfoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Select School",
            style: TextStyle(color: Colors.black),
          ),
          shadowColor: Colors.transparent,
          backgroundColor: Colors.white,
          centerTitle: false,
        ),
        body: Obx(() {
          if (controller.state is LoadingState) {
            return const Center(
              child: LoadingIndicator(),
            );
          } else {
            return Column(
              children: [
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  child: Center(
                      child: Padding(
                    padding:
                        const EdgeInsets.only(bottom: 8.0, left: 10, right: 10),
                    child: Container(
                      height: 35,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.black12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(children: [
                          const Icon(Icons.search),
                          Flexible(
                              child: CupertinoTextField.borderless(
                            onChanged: (query) => controller.search(query),
                          ))
                        ]),
                      ),
                    ),
                  )),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: controller.schoolList.length,
                      itemBuilder: ((context, index) {
                        return ListTile(
                          title: Text(controller.schoolList[index]["SCHUL_NM"]),
                          trailing: Text(
                            controller.schoolList[index]["ATPT_OFCDC_SC_NM"],
                            style: const TextStyle(fontWeight: FontWeight.w200),
                          ),
                          onTap: () {
                            Get.bottomSheet(
                                InputUserInfo(
                                    controller.schoolList[index]
                                        ["ATPT_OFCDC_SC_CODE"],
                                    controller.schoolList[index]
                                        ["SD_SCHUL_CODE"]),
                                enterBottomSheetDuration:
                                    Duration(milliseconds: 150),
                                exitBottomSheetDuration:
                                    Duration(milliseconds: 150),
                                isScrollControlled: true);
                          },
                        );
                      })),
                )
              ],
            );
          }
        }));
  }
}
