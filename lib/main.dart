import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/generated/l10n.dart';
import 'package:schoolman/uitools/loading_indicator.dart';
import 'package:schoolman/uitools/themedatas.dart';

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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: S.delegate.supportedLocales,
        theme: Platform.isIOS ? LightThemeIOS : LightTheme,
        darkTheme: Platform.isIOS ? DarkThemeIOS : DarkTheme, // TODO: Temporary, must be ditched to DarkTheme
        // home: GetBuilder<GlobalController>(
        //     init: GlobalController(),
        //     builder: (c) {
        //       return Splash();
        //     })
      home: Splash(),
    );
  }
}

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(GlobalController(), permanent: true);
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Seenac",
                style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.bold),
                textScaleFactor: 2,
              ),
              Container(
                height: 16,
              ),
              LoadingIndicator()
            ],
          ),
        ));
  }
}

