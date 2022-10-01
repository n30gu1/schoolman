import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolman/generated/l10n.dart';
import 'package:schoolman/uitools/custom_button.dart';
import 'package:schoolman/uitools/custom_textfield.dart';
import 'package:schoolman/validator.dart';
import 'sign_in_controller.dart';

class SignInPage extends StatelessWidget {
  SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = Get.put(SignInController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox.square(
              dimension: 100,
              child: Text('Logo'),
            ),
            Text(
              S.of(context).welcome,
              textScaleFactor: 1.5,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 50,
            ),
            LoginTextField(
              type: LoginTextFieldType.email,
              labelText: S.of(context).email,
              validator: (value) => Validator.validateEmail(email: value!),
              controller: c.emailController,
            ),
            SizedBox(
              height: 10,
            ),
            LoginTextField(
              type: LoginTextFieldType.password,
              labelText: S.of(context).password,
              controller: c.passwordController,
              validator: (value) =>
                  Validator.validatePassword(password: value!),
            ),
            SizedBox(
              height: 20,
            ),
            LoginButton(
              label: S.of(context).signIn,
              onTap: () {},
              textStyle:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            LoginButton(
              label: S.of(context).signUp,
              onTap: () {},
              color: Colors.black12,
            ),
            TextButton(
              child: Text(
                S.of(context).forgotPassword,
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {},
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    thickness: 1.5,
                    color: Colors.black26,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    S.of(context).socialSignIn,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Expanded(
                  child: Divider(
                    thickness: 1.5,
                    color: Colors.black26,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
