import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/generated/l10n.dart';
import 'package:schoolman/model/notice.dart';
import 'package:schoolman/uitools/custom_appbar.dart';
import 'package:schoolman/uitools/custom_button.dart';
import 'package:schoolman/uitools/custom_scaffold.dart';
import 'package:schoolman/view/notice_board/add_notice/add_notice_page.dart';
import 'package:schoolman/view/notice_board/notice_board_controller.dart';
import 'package:schoolman/view/notice_board/notice_detail/notice_detail_page.dart';

class NoticeBoardPage extends StatelessWidget {
  final c = Get.put(NoticeBoardController());
  final globalC = Get.find<GlobalController>();

  NoticeBoardPage({Key? key}) : super(key: key);

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
                    child:
                        Text("${globalC.school?.schoolName}"),
                  ),
                ],
              ),
              title: S.of(context).titleNoticeBoard,
              trailing: FutureBuilder(
                future: globalC.validateAdmin(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data! as bool)
                      return SizedBox(
                        width: 40,
                        height: 40,
                        child: CustomButton(
                          onTap: () {
                            Get.to(() => AddNoticePage());
                          },
                          borderRadius: double.infinity,
                          child: Icon(Icons.add),
                        ),
                      );
                  }
                  return Container();
                },
              ),
          ),
          body: Column(
            children: [
              c.obx((state) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.length,
                    itemBuilder: (context, index) {
                      Notice? result = state[index];
                      if (result != null) {
                        return _NoticeListCell(result: result);
                      } else {
                        return Text("Null Detected");
                      }
                    },
                  ),
                );
              }, onLoading: PlatformCircularProgressIndicator())
            ],
          ),
        );
  }
}

class _NoticeListCell extends StatelessWidget {
  _NoticeListCell({
    Key? key,
    required this.result,
  }) : super(key: key);

  final NoticeBoardController c = Get.find<NoticeBoardController>();
  final globalC = Get.find<GlobalController>();
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
              FutureBuilder(
                future: globalC.validateAdmin(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data! as bool)
                      return IconButton(
                        onPressed: () => c.deleteNotice(result),
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
