import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/model/notice.dart';
import 'package:schoolman/uitools/custom_appbar.dart';
import 'package:schoolman/uitools/custom_button.dart';
import 'package:schoolman/uitools/loading_indicator.dart';
import 'package:schoolman/view/notice_board/add_notice/add_notice_page.dart';
import 'package:schoolman/view/notice_board/notice_board_controller.dart';
import 'package:schoolman/view/notice_board/notice_detail/notice_detail_page.dart';

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
              c.obx((state) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.length,
                    itemBuilder: (context, index) {
                      Notice? result = state[index];
                      if (result != null) {
                        return _NoticeListCell(c: c, result: result);
                      } else {
                        return Text("Null Detected");
                      }
                    },
                  ),
                );
              }, onLoading: LoadingIndicator())
            ],
          ),
        ));
  }
}

class _NoticeListCell extends StatelessWidget {
  const _NoticeListCell({
    Key? key,
    required this.c,
    required this.result,
  }) : super(key: key);

  final NoticeBoardController c;
  final Notice result;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => NoticeDetailPage(result)),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c.format.format((result.timeCreated.toDate()))),
                  Text(result.title),
                  Text(result.content),
                ],
              ),
              Spacer(),
              if (GlobalController.instance.user!.isAdmin) ...[
                IconButton(
                  onPressed: () => c.deleteNotice(result),
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
