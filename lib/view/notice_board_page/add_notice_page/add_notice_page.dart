import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolman/current_state.dart';
import 'package:schoolman/uitools/loading_indicator.dart';
import 'package:schoolman/view/notice_board_page/add_notice_page/add_notice_controller.dart';

class AddNoticePage extends StatelessWidget {
  final c = Get.put(AddNoticeController());
  AddNoticePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        shadowColor: Colors.transparent,
        actions: [
          Obx(() {
            if (c.state is LoadingState) {
              return LoadingIndicator();
            } else {
              return IconButton(
                  onPressed: () {
                    c.upload();
                  },
                  icon: Icon(Icons.add));
            }
          })
        ],
      ),
      body: Column(children: [
        TextField(
          controller: c.titleController,
          decoration: InputDecoration(hintText: "Title"),
        ),
        TextField(
          controller: c.contentController,
          decoration: InputDecoration(hintText: "Content"),
        ),
      ]),
    );
  }
}