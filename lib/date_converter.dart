import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeConverter on String {
  convertFromyyyyMMdd() {
    DateFormat format = DateFormat("yyyy/MM/dd");
    String dateString = '${this.substring(0, 4)}/${this.substring(4, 6)}/${this.substring(6, 8)}';

    return format.parse(dateString);
  }
}

extension Extensions on DateTime {
  List<DateTime> listByWeekday() {
    DateFormat f = DateFormat('EEEE');
    List<DateTime> addToList(int start, int end) {
      List<DateTime> list = [];
      for (int i = start; i <= end; i++) list.add(this.add(Duration(days: i)));
      return list;
    }

    void rearrange(List<DateTime> list, int from, int to) {
      DateTime copy = list[from];
      list.removeAt(from);
      list.insert(to, copy);
    }

    switch (f.format(this)) {
      case 'Sunday':
        return addToList(1, 5);
      case 'Monday':
        return addToList(0, 4);
      case 'Tuesday':
        List<DateTime> dates = addToList(-1, 3);
        rearrange(dates, 1, 0);
        rearrange(dates, 1, 4);
        return dates;
      case 'Wednesday':
        List<DateTime> dates = addToList(-2, 2);
        rearrange(dates, 2, 0);
        rearrange(dates, 1, 4);
        rearrange(dates, 1, 4);
        return dates;
      case 'Thursday':
        List<DateTime> dates = addToList(-3, 1);
        rearrange(dates, 3, 0);
        rearrange(dates, 1, 4);
        rearrange(dates, 1, 4);
        rearrange(dates, 1, 4);
        return dates;
      case 'Friday':
        List<DateTime> dates = addToList(-4, 0);
        rearrange(dates, 4, 0);
        return dates;
      case 'Saturday':
        return addToList(2, 6);
      default:
        return [DateTime.now()];
    }
  }

  String showRangeAsString(BuildContext context) {
    DateFormat f = DateFormat('EEEE');
    List<DateTime> addToList(int start, int end) {
      List<DateTime> list = [];
      for (int i = start; i <= end; i++) list.add(this.add(Duration(days: i)));
      return list;
    }

    void rearrange(List<DateTime> list, int from, int to) {
      DateTime copy = list[from];
      list.removeAt(from);
      list.insert(to, copy);
    }

    List<DateTime> list;

    switch (f.format(this)) {
      case 'Sunday':
        list = addToList(1, 5);
        break;
      case 'Monday':
        list = addToList(0, 4);
        break;
      case 'Tuesday':
        List<DateTime> dates = addToList(-1, 3);
        rearrange(dates, 1, 0);
        list = dates;
        break;
      case 'Wednesday':
        List<DateTime> dates = addToList(-2, 2);
        rearrange(dates, 2, 0);
        list = dates;
        break;
      case 'Thursday':
        List<DateTime> dates = addToList(-3, 1);
        rearrange(dates, 3, 0);
        list = dates;
        break;
      case 'Friday':
        List<DateTime> dates = addToList(-4, 0);
        rearrange(dates, 4, 0);
        list = dates;
        break;
      case 'Saturday':
        list = addToList(2, 6);
        break;
      default:
        list = [DateTime.now()];
    }

    switch (f.format(this)) {
      case 'Sunday':
        return '${list.first.formatToString(context)} ~ ${list.last.formatToStringShort(context)}';
      case 'Monday':
        return '${list.first.formatToString(context)} ~ ${list.last.formatToStringShort(context)}';
      case 'Tuesday':
        return '${list[1].formatToString(context)} ~ ${list.last.formatToStringShort(context)}';
      case 'Wednesday':
        return '${list[1].formatToString(context)} ~ ${list.last.formatToStringShort(context)}';
      case 'Thursday':
        return '${list[1].formatToString(context)} ~ ${list.last.formatToStringShort(context)}';
      case 'Friday':
        return '${list[1].formatToString(context)} ~ ${list.first.formatToStringShort(context)}';
      case 'Saturday':
        return '${list.first.formatToString(context)} ~ ${list.last.formatToStringShort(context)}';
      default:
        return '';
    }
  }

  String formatToString(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    DateFormat f2;

    if (myLocale == Locale('ko')) {
      f2 = DateFormat('yyyy년 M월 d일');
    } else {
      f2 = DateFormat('MMM. d, yyyy');
    }

    return f2.format(this);
  }

  String formatToStringShort(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    DateFormat f2;

    if (myLocale == Locale('ko')) {
      f2 = DateFormat('M월 d일');
    } else {
      f2 = DateFormat('MMM. d');
    }

    return f2.format(this);
  }
}
