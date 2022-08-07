import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolman/view/input_school_info/input_school_info_controller.dart';
import 'package:schoolman/uitools/loading_indicator.dart';
import 'package:schoolman/view/input_user_info/input_user_info.dart';

class InputSchoolInfo extends StatelessWidget {
  InputSchoolInfo({Key? key}) : super(key: key);

  final c = Get.put(InputSchoolInfoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Container(
            color: Colors.white,
            width: double.infinity,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 10, right: 10),
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
                      onChanged: (query) => c.search(query),
                    ))
                  ]),
                ),
              ),
            )),
          ),
          c.obx(
              (state) => Expanded(
                    child: ListView.builder(
                        itemCount: state.length,
                        itemBuilder: ((context, index) {
                          return ListTile(
                            title: Text(state[index]["SCHUL_NM"]),
                            trailing: Text(
                              state[index]["ATPT_OFCDC_SC_NM"],
                              style:
                                  const TextStyle(fontWeight: FontWeight.w200),
                            ),
                            onTap: () {
                              Get.bottomSheet(
                                  InputUserInfo(
                                      state[index]["ATPT_OFCDC_SC_CODE"],
                                      state[index]["SD_SCHUL_CODE"],
                                      state[index]["SCHUL_NM"]),
                                  enterBottomSheetDuration:
                                      Duration(milliseconds: 100),
                                  exitBottomSheetDuration:
                                      Duration(milliseconds: 100));
                            },
                          );
                        })),
                  ),
              onLoading: LoadingIndicator())
        ],
      ),
    ));
  }
}
