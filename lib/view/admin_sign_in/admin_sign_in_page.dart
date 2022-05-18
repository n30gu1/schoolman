import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'admin_sign_in_controller.dart';

class AdminSignInPage extends StatelessWidget {
  final c = Get.put(AdminSignInController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Text("Teacher Sign In Page"),
          Text("Under Construction, needs a design"),
          TextField(
            autofocus: true,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          TextField(obscureText: true)
        ],
      ),
    );
  }
}
