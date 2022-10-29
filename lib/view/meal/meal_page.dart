import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/uitools/custom_scaffold.dart';
import 'package:schoolman/view/meal/meal_page_controller.dart';
import 'package:schoolman/date_converter.dart';
import 'package:schoolman/uitools/custom_appbar.dart';
import 'package:schoolman/uitools/custom_button.dart';
import 'package:schoolman/uitools/loading_indicator.dart';

class MealPage extends StatelessWidget {
  final c = Get.put(MealPageController());

  MealPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: CustomScaffold(
        appBar: CustomAppBar(
            trailing: SizedBox(
              width: 45,
              height: 45,
              child: CustomButton(
                  onTap: () {
                    showDatePicker(
                            context: context,
                            initialDate: c.date,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now().add(Duration(days: 365)))
                        .then((value) => c.setDate(value ?? DateTime.now()));
                  },
                  borderRadius: double.infinity,
                  child: Icon(Icons.calendar_month)),
            ),
            title: "Meal",
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
                      Text("${Get.find<GlobalController>().school?.schoolName}"),
                ),
              ],
            )),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                            onTap: () {
                              c.setDate(c.date.add(Duration(days: -7)));
                            },
                            borderRadius: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.chevron_left),
                            )),
                        Obx(() => Text("${c.date.showRangeAsString(context)}")),
                        CustomButton(
                            onTap: () {
                              c.setDate(c.date.add(Duration(days: 7)));
                            },
                            borderRadius: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.chevron_right),
                            ))
                      ],
                    ),
                    TabBar(
                        labelColor: Colors.black,
                        indicatorColor: Colors.black,
                        onTap: (index) {
                          c.setTabIndex(index);
                        },
                        tabs: [
                          Tab(
                            child: Text(
                              "Breakfast",
                              style: TextStyle(
                                  fontWeight: c.index == 0
                                      ? FontWeight.bold
                                      : FontWeight.normal),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "Lunch",
                              style: TextStyle(
                                  fontWeight: c.index == 1
                                      ? FontWeight.bold
                                      : FontWeight.normal),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "Dinner",
                              style: TextStyle(
                                  fontWeight: c.index == 2
                                      ? FontWeight.bold
                                      : FontWeight.normal),
                            ),
                          ),
                        ])
                  ],
                ),
              ),
            ),
            c.obx((state) {
              List meals = state;
              return Expanded(
                  child: ListView.builder(
                      itemCount: meals.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text((meals[index].date as DateTime)
                                  .formatToString(context)),
                              for (var meal in meals[index].meal) Text(meal)
                            ],
                          ),
                        );
                      }));
            }, onLoading: LoadingIndicator())
          ],
        ),
      ),
    );
  }
}
