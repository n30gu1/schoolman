import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/generated/l10n.dart';
import 'package:schoolman/uitools/custom_scaffold.dart';
import 'package:schoolman/view/time_table/time_table_controller.dart';
import 'package:schoolman/date_converter.dart';
import 'package:schoolman/uitools/custom_appbar.dart';
import 'package:schoolman/uitools/custom_button.dart';

class TimeTablePage extends StatelessWidget {
  TimeTablePage({Key? key}) : super(key: key);

  final c = Get.put(TimeTableController());

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        appBar: CustomAppBar(
            title: S.of(context).titleTimeTable,
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
                      Text("${Get.find<GlobalController>().school?.schoolName}"),
                ),
              ],
            )),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                        onTap: () {
                          c.setDate(c.date.add(Duration(days: -7)));
                        },
                        borderRadius: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.chevron_left),
                        )),
                    Obx(() => Text("${c.date.showRangeAsString(context)}")),
                    CustomButton(
                        onTap: () {
                          c.setDate(c.date.add(Duration(days: 7)));
                        },
                        borderRadius: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.chevron_right),
                        ))
                  ],
                ),
              ),
            ),
            c.obx((state) {
              return Row(
                children: [
                  for (var timeTable in state)
                    Expanded(
                      child: Column(
                        children: [
                          for (var item in timeTable.items)
                            Text("${item.subject}")
                        ],
                      ),
                    )
                ],
              );
            },
                onLoading: Center(
                  child: PlatformCircularProgressIndicator(),
                ),
                onError: (error) => Center(
                      child: Text("Couldn't load: ${error}"),
                    )),
          ],
        ));
  }
}
