import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final labelText;
  final validator;
  final TextEditingController? controller;
  final type;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final border;

  const CustomTextField(
      {required this.type,
      this.labelText,
      this.validator,
      this.controller,
        this.onChanged,
      this.onSubmitted,
        this.border,
      super.key});

  // TODO: Add Focusing (next or done in keyboard)
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
          color: Theme.of(context).dialogBackgroundColor,
          borderRadius: border != null ? border : BorderRadius.circular(6),
          border: Border.all(color: Color.fromARGB(31, 22, 20, 20))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: CupertinoTextField(
          controller: controller,
          decoration: BoxDecoration(),
          obscureText: type == CustomTextFieldType.password ? true : false,
          keyboardType: type == CustomTextFieldType.email
              ? TextInputType.emailAddress
              : TextInputType.text,
          scribbleEnabled: type == CustomTextFieldType.password ? false : true,
          toolbarOptions: ToolbarOptions(
              copy: type == CustomTextFieldType.password ? false : true,
              cut: type == CustomTextFieldType.password ? false : true,
              paste: type == CustomTextFieldType.password ? false : true,
              selectAll: type == CustomTextFieldType.password ? false : true),
          placeholder: labelText,
          placeholderStyle: Theme.of(context)
              .inputDecorationTheme
              .hintStyle
              ?.copyWith(fontFamily: "Pretendard"),
          style: Theme.of(context).inputDecorationTheme.labelStyle?.copyWith(
              fontFamily:
                  (type == CustomTextFieldType.password ? null : "Pretendard")),
          onSubmitted: onSubmitted,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

enum CustomTextFieldType { email, password, other }
