import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/generated/l10n.dart';
import 'package:schoolman/uitools/custom_scaffold.dart';
import 'package:schoolman/view/main/main_page_controller.dart';
import 'package:schoolman/model/meal.dart';
import 'package:schoolman/uitools/custom_appbar.dart';
import 'package:schoolman/uitools/custom_button.dart';
import 'package:schoolman/view/main/switch_user/switch_user_page.dart';
import 'package:schoolman/view/studyplanner/studyplanner_page.dart';

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  final c = Get.put(MainPageController());

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        appBar: CustomAppBar(
            subView: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Text("${DateFormat.yMd().format(DateTime.now())}"),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Text(
                      "${Get.find<GlobalController>().school?.schoolName}"),
                ),
              ],
            ),
            title: S.of(context).titleSummary,
            trailing: SizedBox(
              width: 40,
              height: 40,
              child: CustomButton(
                onTap: () {
                  Get.bottomSheet(SwitchUserPage(),
                      enterBottomSheetDuration: Duration(milliseconds: 100),
                      exitBottomSheetDuration: Duration(milliseconds: 100),
                      persistent: false);
                },
                borderRadius: double.infinity,
                child: Icon(Icons.account_circle_sharp),
              ),
            )),

        // Body
        body: Column(children: [
          c.obx((_) {
            return Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                    ],
                  ),
                ),
              ),
            );
          },
              onLoading: Center(
                child: PlatformCircularProgressIndicator(),
              ))
        ]));
  }
}
