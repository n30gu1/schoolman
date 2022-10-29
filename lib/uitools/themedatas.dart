import 'package:flutter/material.dart';

final LightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Pretendard",
    scaffoldBackgroundColor: Colors.white,
    dialogBackgroundColor: Color.fromRGBO(248, 248, 248, 1),
    cardColor: Color.fromRGBO(210, 210, 210, 1),
    primaryColor: Colors.green,
    focusColor: Colors.green,
    hoverColor: Colors.green,
    highlightColor: Colors.green,
    splashColor: Colors.green,
    indicatorColor: Colors.green,
    toggleableActiveColor: Colors.green,
    textTheme: TextTheme(
        headline1: TextStyle(color: Colors.black),
        headline2: TextStyle(color: Colors.black),
        headline3: TextStyle(color: Colors.black),
        headline4: TextStyle(color: Colors.black),
        headline5: TextStyle(color: Colors.black),
        headline6: TextStyle(color: Colors.black),
        subtitle1: TextStyle(color: Colors.black),
        subtitle2: TextStyle(color: Colors.black),
        bodyText1: TextStyle(color: Colors.black),
        bodyText2: TextStyle(color: Colors.black),
        caption: TextStyle(color: Colors.black),
        button: TextStyle(color: Colors.black),
        overline: TextStyle(color: Colors.black)),
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
        labelStyle: TextStyle(color: Colors.black),
        hintStyle: TextStyle(color: Colors.grey),
        errorStyle: TextStyle(color: Colors.red)),
    dividerColor: Colors.black26,
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.green));

final DarkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Pretendard",
    scaffoldBackgroundColor: Colors.black,
    dialogBackgroundColor: Color.fromRGBO(33, 33, 33, 1),
    cardColor: Color.fromRGBO(70, 70, 70, 1),
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
    textTheme: TextTheme(
        headline1: TextStyle(color: Colors.white),
        headline2: TextStyle(color: Colors.white),
        headline3: TextStyle(color: Colors.white),
        headline4: TextStyle(color: Colors.white),
        headline5: TextStyle(color: Colors.white),
        headline6: TextStyle(color: Colors.white),
        subtitle1: TextStyle(color: Colors.white),
        subtitle2: TextStyle(color: Colors.white),
        bodyText1: TextStyle(color: Colors.white),
        bodyText2: TextStyle(color: Colors.white),
        caption: TextStyle(color: Colors.white),
        button: TextStyle(color: Colors.white),
        overline: TextStyle(color: Colors.white)),
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
        labelStyle: TextStyle(color: Colors.white),
        hintStyle: TextStyle(color: Colors.grey),
        errorStyle: TextStyle(color: Colors.red)),
    dividerColor: Color.fromRGBO(100, 100, 100, 1),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.green));

final LightThemeIOS = LightTheme.copyWith(
    textTheme: LightTheme.textTheme
        .copyWith(button: TextStyle(color: Colors.black, fontSize: 16, fontFamily: "Pretendard")));
final DarkThemeIOS = DarkTheme.copyWith(
    textTheme: DarkTheme.textTheme
        .copyWith(button: TextStyle(color: Colors.black, fontSize: 16, fontFamily: "Pretendard")));
