import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoolman/controller/global_controller.dart';
import 'package:schoolman/controller/timetable_controller.dart';
import 'package:schoolman/uitools/custom_appbar.dart';
import 'package:schoolman/uitools/custom_button.dart';

class TimeTablePage extends StatelessWidget {
  TimeTablePage({Key? key}) : super(key: key);

  final controller = Get.put(TimeTableController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: "Time Table", subView: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child:
                Text("${DateFormat.yMd().format(DateTime.now())}"),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Text(
                    "${GlobalController.instance.school?.schoolName}"),
              ),
            ],
          )),

          Container(
            width: double.infinity,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(onTap: () {}, borderRadius: BorderRadius.circular(1000), child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.chevron_left),
                  )),
                  Text("${DateFormat.yMd().format(DateTime.now())}"),
                  CustomButton(onTap: () {}, borderRadius: BorderRadius.circular(1000), child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.chevron_right),
                  ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
