import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class Horizontal_pickerComponent extends StatelessWidget {
  final logic = Get.put(Horizontal_pickerLogic());
  final state = Get.find<Horizontal_pickerLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
