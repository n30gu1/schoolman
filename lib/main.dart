import 'dart:io';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/uitools/loading_indicator.dart';
import 'package:schoolman/view/titleview.dart';

// TODO: MAKE TABVIEW CAN DO LAZY LOADING
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final c = Get.put(GlobalController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          fontFamily: "Pretendard",
          primaryColor: Colors.black,
          focusColor: Colors.black),
      home: () {
        return c.obx((state) {
          if (defaultTargetPlatform == TargetPlatform.macOS) {
            return Scaffold(
              body: TitleView(appWindow.titleBarHeight, child: state),
            );
          }
          return Scaffold(body: state);
        },
            onLoading: Center(
              child: LoadingIndicator(),
            ));
      }(),
    );
  }
}
