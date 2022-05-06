import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schoolman/controller/global_controller.dart';
import 'package:schoolman/uitools/custom_appbar.dart';

class MealPage extends StatelessWidget {
  const MealPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: "Meal", subView: Column(
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
          ))
        ],
      ),
    );
  }
}
