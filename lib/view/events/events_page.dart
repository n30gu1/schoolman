import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/generated/l10n.dart';
import 'package:schoolman/uitools/custom_appbar.dart';
import 'package:schoolman/uitools/custom_button.dart';
import 'package:schoolman/uitools/custom_scaffold.dart';
import 'package:schoolman/view/events/add_event/add_event_page.dart';
import 'package:schoolman/view/events/events_controller.dart';
import 'package:table_calendar/table_calendar.dart';

class EventsPage extends StatelessWidget {
  final c = Get.put(EventsController());
  EventsPage({Key? key}) : super(key: key);

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
              child: Text("${Get.find<GlobalController>().school?.schoolName}"),
            ),
          ],
        ),
        title: S.of(context).titleEvents,
        trailing: FutureBuilder(
          future: Get.find<GlobalController>().validateAdmin(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data! as bool)
                return SizedBox(
                  width: 40,
                  height: 40,
                  child: CustomButton(
                    onTap: () {
                      Get.to(() => AddEventPage());
                    },
                    borderRadius: double.infinity,
                    child: Icon(Icons.add),
                  ),
                );
              else
                return Container();
            } else {
              return Container();
            }
          },
        ),
      ),
      body: Column(
        children: [
          Obx(
            () => TableCalendar(
              firstDay: DateTime.now().subtract(Duration(days: 1000)),
              focusedDay: c.dateSelected.value,
              lastDay: DateTime.now().add(Duration(days: 1000)),
            ),
          ),
          c.obx((state) {
            List result = state;
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
                          onPressed: () => c.deleteEvent(result[index]),
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                        )
                      ]
                    ],
                  ),
                );
              },
            ));
          }, onLoading: PlatformCircularProgressIndicator())
        ],
      ),
    );
  }
}
