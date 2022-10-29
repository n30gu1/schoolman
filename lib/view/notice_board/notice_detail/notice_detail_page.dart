import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:schoolman/generated/l10n.dart';
import 'package:schoolman/model/notice.dart';
import 'package:schoolman/model/todoitem.dart';
import 'package:schoolman/uitools/custom_scaffold.dart';
import 'package:schoolman/view/notice_board/notice_detail/notice_detail_controller.dart';

class NoticeDetailPage extends StatelessWidget {
  NoticeDetailPage(this.notice, {Key? key}) : super(key: key);

  final Notice notice;

  @override
  Widget build(BuildContext context) {
    NoticeDetailController c = Get.put(NoticeDetailController(notice));
    return CustomScaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(notice.title),
      ),
      body: Column(
        children: [
          Text(notice.content),
          Text(notice.timeCreated.toDate().toString()),
          Text(notice.attachments.toString()),
          Container(
            height: 10,
          ),
          Text(
            "Todo Info",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          c.obx((state) {
            TodoItem todoItem = state;
            return Column(
              children: [
                Text(todoItem.id),
                Text(todoItem.title),
                Text(todoItem.comment),
                Text(todoItem.classAssigned.toString()),
                Text(todoItem.dueDate.toDate().toString())
              ],
            );
          },
              onLoading: PlatformCircularProgressIndicator(),
              onError: (e) => Text(S.of(context).somethingWentWrong + e.toString()),
              onEmpty: Text("No related todo"))
        ],
      ),
    );
  }
}
