import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolman/current_state.dart';
import 'package:schoolman/uitools/loading_indicator.dart';
import 'package:schoolman/validator.dart';
import 'sign_in_controller.dart';

class SignInPage extends StatelessWidget {
  SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = Get.put(SignInController());
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.black,
        ),
        body: Column(
          children: [
            Text("Sign In Page"),
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
                )
              ],
            ),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () => c.signIn(), child: Text("Sign In")),
                ElevatedButton(
                    onPressed: () => c.signUp(), child: Text("Sign Up")),
                ElevatedButton(
                    onPressed: () => c.signInWithGoogle(),
                    child: Text("Google")),
                ElevatedButton(
                    onPressed: () => c.signInWithApple(), child: Text("Apple"))
              ],
            ),
          ],
        ));
  }
}
