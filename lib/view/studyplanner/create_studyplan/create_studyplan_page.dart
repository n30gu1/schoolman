import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolman/view/studyplanner/create_studyplan/create_studyplan_controller.dart';

class CreateStudyPlanPage extends StatelessWidget {
  CreateStudyPlanPage({Key? key}) : super(key: key);

  final c = Get.put(CreateStudyPlanController());

  Widget cell(BuildContext context, StudyPlanItem item) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: c.title,
              decoration: InputDecoration(
                labelText: "Subject",
              ),
              onChanged: ((value) => item.subject.value = value),
            ),
            TextField(
              controller: c.description,
              decoration: InputDecoration(
                labelText: "Description",
              ),
              onChanged: ((value) => item.description.value = value),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: (() => showTimePicker(
                            context: context, initialTime: TimeOfDay.now())
                        .then((value) =>
                            item.startTime.value = value ?? TimeOfDay.now())),
                    child: Text(item.startTime.value.toString())),
                ElevatedButton(
                    onPressed: (() => showTimePicker(
                            context: context, initialTime: TimeOfDay.now())
                        .then((value) =>
                            item.endTime.value = value ?? TimeOfDay.now())),
                    child: Text(item.endTime.value.toString()))
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Plan")),
      body: Column(children: [
        TextField(
          controller: c.title,
          decoration: InputDecoration(labelText: "Title"),
        ),
        TextField(
          controller: c.description,
          decoration: InputDecoration(labelText: "Description"),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  c.createItem();
                },
                child: Text("Add Item")),
            ElevatedButton(
              child: Text("Create"),
              onPressed: () {
                // c.create();
              },
            ),
          ],
        ),
        Obx(
          () => Expanded(
            child: ListView.builder(
              itemCount: c.items.length,
              itemBuilder: (context, index) {
                return cell(context, c.items[index]);
              },
            ),
          ),
        ),
      ]),
    );
  }
}
