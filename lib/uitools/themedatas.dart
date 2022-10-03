import 'package:flutter/material.dart';

final LightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Pretendard",
    backgroundColor: Colors.white,
    primaryColor: Colors.green,
    focusColor: Colors.green,
    hoverColor: Colors.green,
    highlightColor: Colors.green,
    splashColor: Colors.green,
    indicatorColor: Colors.green,
    toggleableActiveColor: Colors.green,
    textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.green,
        selectionColor: Colors.green,
        selectionHandleColor: Colors.green),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: Colors.green)),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(foregroundColor: Colors.green)),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(foregroundColor: Colors.green)),
    inputDecorationTheme: InputDecorationTheme(
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
        errorBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        focusedErrorBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        disabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        labelStyle: TextStyle(color: Colors.green),
        hintStyle: TextStyle(color: Colors.green),
        errorStyle: TextStyle(color: Colors.red)),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.green));
