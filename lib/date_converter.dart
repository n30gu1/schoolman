import 'dart:core';

import 'package:intl/intl.dart';

extension DateTimeConverter on String {
  convertFromyyyyMMdd() {
    DateFormat format = DateFormat("yyyy/MM/dd");
    String dateString = '${this.substring(0, 4)}/${this.substring(4, 6)}/${this.substring(6, 8)}';

    return format.parse(dateString);
  }
}