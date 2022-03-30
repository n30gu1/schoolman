import 'package:flutter/material.dart';
import 'package:schoolman/controller/input_user_info_controller.dart';
import 'package:get/get.dart';

class InputUserInfo extends StatelessWidget {
  const InputUserInfo(this.regionCode, this.schoolCode, {Key? key})
      : super(key: key);

  final String regionCode;
  final String schoolCode;

  @override
  Widget build(BuildContext context) {
    InputUserInfoController controller =
        Get.put(InputUserInfoController(regionCode, schoolCode));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        title: const Text(
          "User Info",
        ),
        foregroundColor: Colors.black,
      ),
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
              itemCount: controller.classInfo.length,
              itemBuilder: ((context, index) {
                return ListTile(
                  title: Text(controller.classInfo[index]["CLASS_NM"]),
                );
              }));
        }
      }),
    );
  }
}
