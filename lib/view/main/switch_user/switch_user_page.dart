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

  Widget cell(User item) {
    bool isCurrentProfile = () {
      var gc = GlobalController.instance;
      return item.schoolCode == gc.user.value!.schoolCode &&
          item.grade == gc.user.value!.grade &&
          item.className == gc.user.value!.className;
    }();
    return GestureDetector(
      onTap: () {
        GlobalController.instance.switchUser(item);
        c.fetchSchools();
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
                  Text(item.schoolName),
                  Spacer(),
                  if (item.isMainProfile == true) ...[
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
          c.obx(
            (state) => ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: state.length,
              shrinkWrap: true,
              itemBuilder: ((context, index) => Dismissible(
                  direction: state[index].isMainProfile
                      ? DismissDirection.none
                      : DismissDirection.endToStart,
                  onDismissed: ((direction) {
                    c.removeProfile(state[index]);
                  }),
                  key: Key(state[index].toString()),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: cell(state[index]),
                  ))),
            ),
          ),
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
