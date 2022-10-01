// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ko_KR locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ko_KR';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "email": MessageLookupByLibrary.simpleMessage("이메일"),
        "forgotPassword": MessageLookupByLibrary.simpleMessage("비밀번호를 잊으셨나요?"),
        "password": MessageLookupByLibrary.simpleMessage("비밀번호"),
        "signIn": MessageLookupByLibrary.simpleMessage("로그인"),
        "signUp": MessageLookupByLibrary.simpleMessage("회원가입"),
        "socialSignIn": MessageLookupByLibrary.simpleMessage("소셜 로그인"),
        "titleEvents": MessageLookupByLibrary.simpleMessage("일정"),
        "titleMeal": MessageLookupByLibrary.simpleMessage("급식"),
        "titleNoticeBoard": MessageLookupByLibrary.simpleMessage("공지사항"),
        "titleSummary": MessageLookupByLibrary.simpleMessage("요약"),
        "titleTimeTable": MessageLookupByLibrary.simpleMessage("시간표"),
        "titleTodoList": MessageLookupByLibrary.simpleMessage("할일"),
        "welcome": MessageLookupByLibrary.simpleMessage("반가워요!")
      };
}
