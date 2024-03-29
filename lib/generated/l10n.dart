// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Welcome!`
  String get welcome {
    return Intl.message(
      'Welcome!',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message(
      'Sign In',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message(
      'Sign Up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Apple`
  String get signInWithApple {
    return Intl.message(
      'Sign in with Apple',
      name: 'signInWithApple',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Google`
  String get signInWithGoogle {
    return Intl.message(
      'Sign in with Google',
      name: 'signInWithGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Sign in Anonymously`
  String get signInAnonymously {
    return Intl.message(
      'Sign in Anonymously',
      name: 'signInAnonymously',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `or`
  String get or {
    return Intl.message(
      'or',
      name: 'or',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Grade`
  String get grade {
    return Intl.message(
      'Grade',
      name: 'grade',
      desc: '',
      args: [],
    );
  }

  /// `Class`
  String get className {
    return Intl.message(
      'Class',
      name: 'className',
      desc: '',
      args: [],
    );
  }

  /// `School Name`
  String get schoolName {
    return Intl.message(
      'School Name',
      name: 'schoolName',
      desc: '',
      args: [],
    );
  }

  /// `Summary`
  String get titleSummary {
    return Intl.message(
      'Summary',
      name: 'titleSummary',
      desc: '',
      args: [],
    );
  }

  /// `Time Table`
  String get titleTimeTable {
    return Intl.message(
      'Time Table',
      name: 'titleTimeTable',
      desc: '',
      args: [],
    );
  }

  /// `Meal`
  String get titleMeal {
    return Intl.message(
      'Meal',
      name: 'titleMeal',
      desc: '',
      args: [],
    );
  }

  /// `Notice Board`
  String get titleNoticeBoard {
    return Intl.message(
      'Notice Board',
      name: 'titleNoticeBoard',
      desc: '',
      args: [],
    );
  }

  /// `Events`
  String get titleEvents {
    return Intl.message(
      'Events',
      name: 'titleEvents',
      desc: '',
      args: [],
    );
  }

  /// `Todo List`
  String get titleTodoList {
    return Intl.message(
      'Todo List',
      name: 'titleTodoList',
      desc: '',
      args: [],
    );
  }

  /// `Authorize School`
  String get authorizeSchool {
    return Intl.message(
      'Authorize School',
      name: 'authorizeSchool',
      desc: '',
      args: [],
    );
  }

  /// `Input New School Code`
  String get authorizeSchoolInputNewCode {
    return Intl.message(
      'Input New School Code',
      name: 'authorizeSchoolInputNewCode',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong: `
  String get somethingWentWrong {
    return Intl.message(
      'Something went wrong: ',
      name: 'somethingWentWrong',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ko', countryCode: 'KR'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
