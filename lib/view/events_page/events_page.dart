import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/current_state.dart';
import 'package:schoolman/uitools/custom_appbar.dart';
import 'package:schoolman/uitools/custom_button.dart';
import 'package:schoolman/uitools/loading_indicator.dart';
import 'package:schoolman/view/events_page/add_event_page/add_event_page.dart';
import 'package:schoolman/view/events_page/events_controller.dart';

class EventsPage extends StatelessWidget {
  final c = Get.put(EventsController());
  EventsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
      () => Column(
        children: [
          CustomAppBar(
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
                        Text("${GlobalController.instance.school?.schoolName}"),
                  ),
                ],
              ),
              title: "Events",
              trailing: () {
                if (GlobalController.instance.user!.isAdmin) {
                  return CustomButton(
                    width: 40,
                    height: 40,
                    onTap: () {
                      if (GlobalController.instance.user!.isAdmin) {
                        Get.to(() => AddEventPage());
                      }
                    },
                    borderRadius: BorderRadius.circular(1000),
                    child: Icon(Icons.add),
                  );
                }
              }()),
          () {
            if (c.state is DoneState) {
              List result = (c.state as DoneState).result!;
              return Expanded(
                  child: ListView.builder(
                itemCount: result.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(DateFormat.yMd().format(result[index].date)),
                        Spacer(),
                        Text(result[index].title),
                        if (result[index].fromFirebase == true) ...[
                          IconButton(
                            onPressed: () => c.removeEvent(result[index]),
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                          )
                        ]
                      ],
                    ),
                  );
                },
              ));
            } else {
              return LoadingIndicator();
            }
          }()
        ],
      ),
    ));
  }
}
