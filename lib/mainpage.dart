import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoolman/controller/auth_controller.dart';
import 'package:schoolman/controller/mainpage_controller.dart';
import 'package:schoolman/uitools/custom_button.dart';

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  final controller = Get.put(MainPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).viewPadding.top + 68,
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
                              child: Text("${DateFormat.yMd().format(DateTime.now())}"),
                            ),
                            Text(
                              "Good day",
                              style: TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Spacer(),
                        CustomButton(width: 30, height: 30, onTap: () {})
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(controller.schoolInfo!.value.schoolCode),
                      Container(
                        width: Get.width - 20,
                        height: 1200,
                        color: Colors.white,
                        child: Text("nice"),
                      ),
                      Container(height: MediaQuery.of(context).viewPadding.bottom + 20,)
                    ],
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
