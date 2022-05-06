import 'package:get/get.dart';

class TabViewController extends GetxController {
  RxInt _index = 0.obs;

  get index => _index.value;

  void setIndex(int value) {
    _index.value = value;
  }
}