import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolman/current_state.dart';
import 'package:schoolman/uitools/loading_indicator.dart';
import 'package:schoolman/view/events_page/add_event_page/add_event_controller.dart';

class AddEventPage extends StatelessWidget {
  final c = Get.put(AddEventController());
  AddEventPage({Key? key}) : super(key: key);

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
              return IconButton(onPressed: () {}, icon: Icon(Icons.add));
            }
          })
        ],
      ),
      body: Column(children: [
        TextField(
          controller: c.titleController,
          decoration: InputDecoration(hintText: "Title"),
        ),
        ElevatedButton(
            onPressed: () {
              showDateRangePicker(
                      context: context,
                      firstDate: DateTime.parse("20200302"),
                      lastDate: DateTime.parse("21000302"))
                  .then((value) => c.setRange(value!));
            },
            child: Text("showDatePicker"))
      ]),
    );
  }
}
