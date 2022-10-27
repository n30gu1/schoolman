import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/model/user.dart';
import 'package:schoolman/view/info/info_page.dart';
import 'package:schoolman/view/input_school_info/input_school_info.dart';
import 'package:schoolman/view/main/switch_user/switch_user_controller.dart';

class SwitchUserPage extends StatelessWidget {
  SwitchUserPage({Key? key}) : super(key: key);

  final c = Get.put(SwitchUserController());
  final gc = Get.find<GlobalController>();

  Widget cell(UserProfile item) {
    bool isCurrentProfile = () {
      var gc = Get.find<GlobalController>();
      return item.id == gc.userProfile!.id;
    }();

    return GestureDetector(
      onTap: () {
        Get.find<GlobalController>().switchUser(item.id);
        c.userProfile.value = item;
      },
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  offset: Offset(0, 0.75),
                  blurRadius: 1,
                  spreadRadius: 1,
                  color: isCurrentProfile ? Colors.blue : Colors.black38,
                  blurStyle: BlurStyle.normal),
            ], color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // TODO: Add School Name
                  // Text(item.schoolName),
                  Text(item.schoolCode),
                  Spacer(),
                  if (item.id == gc.user!.mainProfile) ...[
                    Text(
                      "main ",
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                  Text("${item.grade}-${item.className}")
                ],
              ),
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 100),
      child: Scaffold(
        body: Column(children: [
          Text("Switch User"),
          SizedBox(
            height: 10,
          ),
          Obx(() => ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: c.profiles.length,
              shrinkWrap: true,
              itemBuilder: ((context, index) => Dismissible(
                  direction: gc.user!.profiles[index]!.id == gc.userProfile!.id
                      ? DismissDirection.none
                      : DismissDirection.endToStart,
                  onDismissed: ((direction) {
                    c.removeProfile(c.profiles[index]);
                  }),
                  key: Key(c.profiles[index].id),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: cell(c.profiles[index]),
                  ))),
            )),
          TextButton(
              onPressed: () {
                Get.to(() => InputSchoolInfo());
              },
              child: Text("Add User")),
          TextButton(
              onPressed: () {
                Get.to(() => InfoPage());
              },
              child: Text("Info Page"))
        ]),
      ),
    );
  }
}
