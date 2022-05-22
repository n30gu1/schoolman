import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolman/current_state.dart';
import 'package:schoolman/uitools/loading_indicator.dart';
import 'package:schoolman/validator.dart';

import 'sign_in_controller.dart';

class SignInPage extends StatelessWidget {
  final String regionCode;
  final String schoolCode;

  SignInPage(this.regionCode, this.schoolCode, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = Get.put(SignInController(regionCode, schoolCode));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Obx(() {
        if (c.state is DoneState) {
          return Column(
            children: [
              Text("Teacher Sign In Page"),
              Text("Under Construction, needs a design"),
              TextFormField(
                autofocus: true,
                decoration: InputDecoration(label: Text("Email")),
                validator: (value) => Validator.validateEmail(email: value!),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                controller: c.emailController,
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(label: Text("Password")),
                validator: (value) =>
                    Validator.validatePassword(password: value!),
                controller: c.passwordController,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(label: Text("Name")),
                      controller: c.nameController,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(label: Text("Number")),
                      controller: c.studentNumberController,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(onPressed: () => c.signIn(), child: Text("Sign In")),
                  ElevatedButton(
                      onPressed: () => c.signUp(), child: Text("Sign Up"))
                ],
              ),
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "학년",
                        ),
                      ),
                      SizedBox(
                        height: 100,
                        child: CupertinoPicker(
                            itemExtent: 29,
                            scrollController:
                            FixedExtentScrollController(initialItem: 0),
                            onSelectedItemChanged: (item) {
                              c.gradeSelected.value =
                              c.gradeMap["grades"].toList()[item];
                            },
                            children: c.gradeMap["grades"].map<Widget>((item) {
                              return Text(
                                item.toString(),
                              );
                            }).toList()),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text("-", textScaleFactor: 3),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "반",
                        ),
                      ),
                      SizedBox(
                        height: 100,
                        child: CupertinoPicker(
                            itemExtent: 29,
                            scrollController:
                            FixedExtentScrollController(initialItem: 0),
                            onSelectedItemChanged: (item) {
                              c.classSelected.value = c.gradeMap["classes"]
                              [c.gradeSelected.value][item];
                            },
                            children: c.gradeMap["classes"][c.gradeSelected.value]
                                .map<Widget>((item) {
                              return Text(
                                item,
                              );
                            }).toList()),
                      ),
                    ],
                  ),
                ),
              ]),
            ],
          );
        } else {
          return LoadingIndicator();
        }
      }),
    );
  }
}
