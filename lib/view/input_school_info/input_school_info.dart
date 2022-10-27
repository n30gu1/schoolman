import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:schoolman/generated/l10n.dart';
import 'package:schoolman/uitools/custom_textfield.dart';
import 'package:schoolman/view/input_school_info/input_school_info_controller.dart';
import 'package:schoolman/view/input_user_info/input_user_info.dart';

class InputSchoolInfo extends StatelessWidget {
  InputSchoolInfo({Key? key}) : super(key: key);

  final c = Get.put(InputSchoolInfoController());

  @override
  Widget build(BuildContext context) {
    Widget boxFrame(Widget child) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
              constraints: BoxConstraints(maxHeight: 300),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(6),
                      bottomRight: Radius.circular(6)),
                  border: Border.all(color: Color.fromARGB(31, 22, 20, 20))),
              child: child),
        );
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  height: 200,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    // TODO: Implement bottom border
                    child: CustomTextField(
                      type: CustomTextFieldType.other,
                      border: BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                          bottomLeft: Radius.circular(6),
                          bottomRight: Radius.circular(6)),
                      labelText: S.of(context).schoolName,
                      onChanged: (value) => c.search(value),
                    )),
                c.obx(
                    (state) => boxFrame(
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                for (var i in state) ...[
                                  PlatformWidget(
                                    cupertino: (_, __) => CupertinoButton(
                                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      borderRadius: BorderRadius.zero,
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              i["SCHUL_NM"],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            ),
                                            Text(
                                              i["ATPT_OFCDC_SC_NM"],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  ?.copyWith(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w200),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onPressed: () {
                                        Get.bottomSheet(
                                            InputUserInfo(
                                                i["ATPT_OFCDC_SC_CODE"],
                                                i["SD_SCHUL_CODE"],
                                                i["SCHUL_NM"]),
                                            enterBottomSheetDuration:
                                                Duration(milliseconds: 100),
                                            exitBottomSheetDuration:
                                                Duration(milliseconds: 100));
                                      },
                                    ),
                                    material: (_, __) => ListTile(
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(i["SCHUL_NM"]),
                                          Text(
                                            i["ATPT_OFCDC_SC_NM"],
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w200),
                                          )
                                        ],
                                      ),
                                      onTap: () {
                                        Get.bottomSheet(
                                            InputUserInfo(
                                                i["ATPT_OFCDC_SC_CODE"],
                                                i["SD_SCHUL_CODE"],
                                                i["SCHUL_NM"]),
                                            enterBottomSheetDuration:
                                                Duration(milliseconds: 100),
                                            exitBottomSheetDuration:
                                                Duration(milliseconds: 100));
                                      },
                                    ),
                                  ),
                                  if (i != state.last) const Divider(height: 0,)
                                ]
                              ],
                            ),
                          ),
                        ),
                    onLoading: boxFrame(SizedBox(
                        height: 70,
                        child: Center(
                            child: PlatformCircularProgressIndicator()))))
              ],
            ),
          ),
        ));
  }
}
