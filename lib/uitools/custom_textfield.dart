import 'package:flutter/cupertino.dart';

class LoginTextField extends StatelessWidget {
  final labelText;
  final validator;
  final controller;
  final type;
  const LoginTextField(
      {required this.type,
      this.labelText,
      this.validator,
      required this.controller,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
          color: Color.fromRGBO(248, 248, 248, 1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Color.fromARGB(31, 22, 20, 20))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: CupertinoTextField(
          controller: controller,
          decoration: BoxDecoration(),
          obscureText: type == LoginTextFieldType.password ? true : false,
          keyboardType: type == LoginTextFieldType.email
              ? TextInputType.emailAddress
              : TextInputType.text,
          placeholder: labelText,
        ),
      ),
    );
  }
}

enum LoginTextFieldType { email, password, other }
