import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:schoolman/generated/l10n.dart';
import 'package:schoolman/view/sign_in/sign_in_controller.dart';

class LoginButton extends StatelessWidget {
  final Function() onTap;
  final String label;
  final TextStyle? textStyle;
  final Color? color;

  const LoginButton(
      {required this.onTap,
      required this.label,
      this.textStyle,
      this.color,
      super.key});

  @override
  Widget build(BuildContext context) {
    final mainWidget = Container(
      height: 54,
      decoration: BoxDecoration(
          color: color != null ? color : Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(6)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Center(
            child: Text(
          label,
          style: textStyle,
        )),
      ),
    );

    return PlatformWidget(
      material: (_, __) => SizedBox(
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                color != null ? color : Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          onPressed: onTap,
          child: Center(child: Text(label, style: textStyle)),
        ),
      ),
      cupertino: (_, __) => CupertinoButton.filled(
        onPressed: onTap,
        padding: EdgeInsets.zero,
        child: mainWidget,
      ),
    );
  }
}

class SignInWithAppleButton extends StatelessWidget {
  SignInWithAppleButton({super.key});

  final Function() onPressed = () {
    Get.find<SignInController>().signInWithApple();
  };

  @override
  Widget build(BuildContext context) {
    final mainWidget = Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'images/apple_logo.png',
          width: 26,
        ),
        Text(S.of(context).signInWithApple,
            style: Theme.of(context).textTheme.button?.copyWith(color: Colors.white, fontWeight: FontWeight.w500)),
      ],
    ));

    return CupertinoButton.filled(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(6),
            border: MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Border.all(color: Colors.white)
                : null),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: mainWidget,
        ),
      ),
    );
  }
}

class SignInWithGoogleButton extends StatelessWidget {
  SignInWithGoogleButton({super.key});

  final Function() onPressed = () {
    Get.find<SignInController>().signInWithGoogle();
  };

  @override
  Widget build(BuildContext context) {
    final mainWidget = Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'images/g_logo.png',
          width: 20,
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          S.of(context).signInWithGoogle,
          style: Theme.of(context).textTheme.button?.copyWith(color: Colors.black),
        ),
      ],
    ));

    return PlatformWidget(
      material: (_, __) => Container(
        height: 54,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          onPressed: onPressed,
          child: mainWidget,
        ),
      ),
      cupertino: (_, __) => CupertinoButton.filled(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        child: Container(
          height: 54,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border:
                  MediaQuery.of(context).platformBrightness == Brightness.light
                      ? Border.all(color: Colors.black)
                      : null),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: mainWidget,
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final Function() onTap;
  final Widget child;
  final double borderRadius;
  final Color? color;

  CustomButton(
      {required this.onTap,
        required this.child,
        this.borderRadius = 6.0,
        this.color,
        super.key});

  @override
  Widget build(BuildContext context) {
    final mainWidget = Container(
      height: 54,
      decoration: BoxDecoration(
          color: color != null ? color : Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(borderRadius)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Center(
            child: child),
      ),
    );

    return PlatformWidget(
      material: (_, __) => SizedBox(
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
            color != null ? color : Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          onPressed: onTap,
          child: Center(child: child),
        ),
      ),
      cupertino: (_, __) => CupertinoButton.filled(
        onPressed: onTap,
        padding: EdgeInsets.zero,
        child: mainWidget,
      ),
    );
  }
}