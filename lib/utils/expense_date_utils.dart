import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ExpenseDateUtils {
  static DateTime? parse(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  static bool isInMonth(DateTime date, DateTime month) {
    return date.year == month.year && date.month == month.month;
  }

  static String monthLabel(DateTime date, [String? locale]) {
    return DateFormat.yMMMM(locale).format(date);
  }
}
