import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/current_state.dart';
import 'package:schoolman/uitools/custom_appbar.dart';
import 'package:schoolman/uitools/custom_button.dart';
import 'package:schoolman/uitools/loading_indicator.dart';
import 'package:schoolman/view/noticeboardpage/add_notice_page/add_notice_page.dart';
import 'package:schoolman/view/noticeboardpage/noticeboardcontroller.dart';

class NoticeBoardPage extends StatelessWidget {
  final c = Get.put(NoticeBoardController());

  NoticeBoardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: Column(
            children: [
              CustomAppBar(
                  subView: Column(
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
                  ),
                  title: "Notice Board",
                  trailing: () {
                    if (GlobalController.instance.user!.isAdmin) {
                      return CustomButton(
                        width: 40,
                        height: 40,
                        onTap: () {
                          if (GlobalController.instance.user!.isAdmin) {
                            Get.to(() => AddNoticePage());
                          }
                        },
                        borderRadius: BorderRadius.circular(1000),
                        child: Icon(Icons.add),
                      );
                    }
                  }()),
              if (c.state is LoadingState) ...[
                LoadingIndicator()
              ] else ...[
                Expanded(
                  child: ListView.builder(
                    itemCount: (c.state as DoneState).result?.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text((c.state as DoneState).result?[index].title),
                          Text((c.state as DoneState).result?[index].content),
                        ],
                      );
                    },
                  ),
                ),
              ]
            ],
          ),
        ));
  }
}
