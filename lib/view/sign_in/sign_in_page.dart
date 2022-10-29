import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //
                // Logo And Welcome Message Area
                //
                SizedBox.square(
                  dimension: 150,
                  child: FittedBox(child: Image.asset("images/logo_green.png")),
                ),
                Text(
                  S.of(context).welcome,
                  textScaleFactor: 1.5,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 36,
                ),
                //
                // Text Field Area
                //
                CustomTextField(
                  type: CustomTextFieldType.email,
                  labelText: S.of(context).email,
                  validator: (value) => Validator.validateEmail(email: value!),
                  controller: c.emailController,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  type: CustomTextFieldType.password,
                  labelText: S.of(context).password,
                  controller: c.passwordController,
                  validator: (value) =>
                      Validator.validatePassword(password: value!),
                ),
                //
                // Forgot Password Button Area
                //
                Row(
                  children: [
                    Spacer(),
                    PlatformTextButton(
                      child: Text(
                        S.of(context).forgotPassword,
                        style: Theme.of(context)
                            .textTheme
                            .button
                            ?.copyWith(color: Colors.grey),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                //
                // Sign In Button Area
                //
                LoginButton(
                  label: S.of(context).signIn,
                  onTap: () => c.signIn(),
                  textStyle: Theme.of(context).textTheme.button?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                LoginButton(
                  label: S.of(context).signUp,
                  onTap: () {},
                  textStyle: Theme.of(context).textTheme.button,
                  color: Theme.of(context).cardColor,
                ),
                SizedBox(
                  height: 24,
                ),
                //
                // Sign In With Social Account Area
                //
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1.5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        S.of(context).or,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1.5,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 24),
                if (defaultTargetPlatform == TargetPlatform.iOS) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: SignInWithAppleButton(),
                  ),
                ],
                SignInWithGoogleButton(),
                PlatformTextButton(
                  child: Text(
                    S.of(context).signInAnonymously,
                    style: Theme.of(context)
                        .textTheme
                        .button
                        ?.copyWith(color: Colors.grey),
                  ),
                  onPressed: () {
                    c.signInAnonymously();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
